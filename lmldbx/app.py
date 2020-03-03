#!/usr/bin/python3
# -*- coding: UTF-8 -*-

import os, unicodedata

from flask import Flask, Markup, request, render_template, g
from flask_sqlalchemy import SQLAlchemy
from lxml import etree

app = Flask(__name__)
# config file location based on flask_env env var
if os.environ.get('FLASK_ENV') == 'docker':
    CONFIG_FILENAME = "/secrets/config.py"
else:
    CONFIG_FILENAME = os.path.join(os.path.dirname(__file__), "instance", "config.py")
app.config.from_pyfile(CONFIG_FILENAME)
db = SQLAlchemy(app)

import typesense
# @@@@@@@@@@@@@@@
try:
    TS_CLIENT = typesense.Client(app.config["TS_CLIENT_PARAMS"])
except (Exception,) as e:
    logger.error(e)
    TS_CLIENT = None

from .models import Record, RecordRel

# main page
@app.route('/', methods=['GET'])
def home():
    return "<html><head><title>lmldbx</title></head><body style='text-align:center;'><h1>LMLDBX α</h1></body></html>"

# readiness/liveness probe
@app.route('/status', methods=['GET'])
def status():
    return "(●｀･ω･)ゞ！", 200

"""
single record display
"""
# record_xsl = etree.parse(os.path.join(os.path.dirname(__file__), 'xsl', 'record.xsl'))
# record_transform = etree.XSLT(record_xsl)
@app.route('/record/<ctrlno>', methods=['GET','POST'])
def single_record(ctrlno):
    format = request.args.get('format', default='html', type=str)

    record = Record.query.filter_by(id=ctrlno).first()
    if record is None:
        return "<html><body style='text-align:center;'><h1>Record ID not found</h1></body></html>"

    if format == 'xml':
        return etree.tounicode(record.xml, pretty_print=True)

    # reload xsl every time for debug (in production record_transform need be initialized only once)
    record_xsl = etree.parse(os.path.join(os.path.dirname(__file__), 'xsl', 'record.xsl'))
    record_transform = etree.XSLT(record_xsl)    # create transformation function from xsl

    record_html = record_transform(record.xml)
    record_html = unicodedata.normalize('NFC', str(record_html))
    return render_template('record.html', ctrlno=ctrlno, record_html=Markup(record_html))


pe_to_abbr_map = {
    "work"         : 'wrk',
    "being"        : 'bei',
    "concept"      : 'cnc',
    "event"        : 'eve',
    "language"     : 'lan',
    "object"       : 'obj',
    "organization" : 'org',
    "place"        : 'pla',
    "time"         : 'tim',
    "string"       : 'str',
    "holdings"     : 'hol'
}
abbr_to_pe_map = { v : k for k, v in pe_to_abbr_map.items() }

"""
list records that link to the given one
"""
@app.route('/related/<ctrlno>', methods=['GET','POST'])
def related_records(ctrlno):
    # q = text("""SELECT id, pe, entry_str FROM records
    #             WHERE xpath_exists(concat('//xobis:relationship/xobis:target/*[@href=\"',:ctrlno,'\"]'),
    #                                xml, array[array['xobis', 'http://www.xobis.info/ns/2.0/']]);""")
    # result = db.engine.execute(q, ctrlno=ctrlno).fetchall()
    # related_list = [(id, abbr_to_pe_map.get(pe), entry_str) for id, pe, entry_str in result]

    # result = RecordRels.query.filter_by(source_id=ctrlno).all()

    related_record_info = []

    target_record = Record.query.filter_by(id=ctrlno).first()
    for rel in target_record.rel_sources:
        related_record = Record.query.filter_by(id=rel.source_id).first()
        related_record_info.append(
            {
                'id' : related_record.id,
                'pe' : abbr_to_pe_map.get(related_record.pe, related_record.pe),
                'entry_str': related_record.entry_str,
                'rel_name': rel.rel_name
            }
        )

    related_record_info.sort(key=lambda r: r['entry_str'])

    return render_template('related.html', target_record=target_record, related_record_info=related_record_info)


"""
TEST SEARCH
"""
from pprint import PrettyPrinter
pp = PrettyPrinter()
@app.route('/search/<q>', methods=['GET','POST'])
def search(q):
    if TS_CLIENT is None:
        return "ts client unable to initialize"
    params = {'q': q, 'query_by': 'entry_str', 'sort_by': 'id_no:asc'}
    return pp.pprint(TS_CLIENT.collections['records'].documents.search(params))


"""
list records by principal element
"""
@app.route('/list/<pe>', methods=['GET','POST'])
def list_records_by_pe(pe):
    pe_abbr = pe_to_abbr_map.get(pe)
    if pe_abbr is None:
        return f"<html><body style='text-align:center;'><h1>Principal element not recognized: {pe}</h1></body></html>"

    result = Record.query.filter_by(pe=pe_abbr).all()

    return render_template('pe-list.html', pe=pe, record_list=result)


"""
search records by id string (test)
"""
# @app.route('/search/<term>', methods=['GET','POST'])
# def search_records_by_id_string(term):
#     result_records = Record.query.whooshee_search(term, limit=200).all()
#     search_results = [
#         {
#             'id' : record.id,
#             'pe' : abbr_to_pe_map.get(record.pe, record.pe),
#             'entry_str': record.entry_str,
#         } for record in result_records
#     ]
#     return render_template('search-results.html', term=term, search_results=search_results)


if __name__ == '__main__':
    app.run(host='0.0.0.0')
