#!/usr/bin/python3
# -*- coding: UTF-8 -*-

import os, unicodedata

from flask import Flask, Markup, request, render_template, redirect
from flask_sqlalchemy import SQLAlchemy
from lxml import etree

app = Flask(__name__)
# config file location based on flask_env env var
FLASK_ENV = os.environ.get('FLASK_ENV')
if FLASK_ENV == 'docker':
    CONFIG_FILENAME = "/secrets/config.py"
else:
    CONFIG_FILENAME = os.path.join(os.path.dirname(__file__), "instance", "config.py")
app.config.from_pyfile(CONFIG_FILENAME)
db = SQLAlchemy(app)

# import typesense
# TS_CLIENT = typesense.Client(app.config["TS_CLIENT_PARAMS"])

# add python min and max functions to be accessible to jinja templates
app.jinja_env.globals.update(min=min, max=max)

from .models import Record, RecordRel, HoldingsLink

# readiness/liveness probe
@app.route('/status', methods=['GET'])
def status():
    return "(●｀･ω･)ゞ！", 200

# main page
@app.route('/', methods=['GET'])
@app.route('/index', methods=['GET'])
def index_redirect():
    return redirect('./index/', code=302)

@app.route('/index/', methods=['GET'])
def index():
    return render_template('home.html')

"""
single record display
"""
# running this here doesn't work because the etl process that imports this for
# the app/models tries to do this and fails for some reason??
# try moving this to somewhere that won't happen?
# record_xsl = etree.parse(os.path.join(os.path.dirname(__file__), 'xsl', 'record.xsl'))
# record_transform = etree.XSLT(record_xsl)

@app.route('/record/<ctrlno>', methods=['GET','POST'])
def single_record(ctrlno):
    record_format = request.args.get('format', default='html', type=str)

    record = Record.query.filter_by(id=ctrlno).first()
    if record is None:
        record_html, holdings_html = "<h1>Record ID not found</h1>", ''
    elif record_format == 'xml':
        return etree.tounicode(record.xml, pretty_print=True)
    else:
        # reload xsl every time for debug (in production record_transform need be initialized only once)
        # if FLASK_ENV != 'docker':
        record_xsl = etree.parse(os.path.join(os.path.dirname(__file__), 'xsl', 'record.xsl'))
        record_transform = etree.XSLT(record_xsl)    # create transformation function from xsl

        record_html = record_transform(record.xml)
        record_html = unicodedata.normalize('NFC', str(record_html))

        # get all hdgs for bib
        holdings_links = HoldingsLink.query.filter_by(bib_id=ctrlno).all()
        holdings_links_ids = set((holdings_link.hdg_id for holdings_link in holdings_links))
        # pull entry strs
        holdings_entry_strs = { holding.id : holding.entry_str for holding in Record.query.filter(Record.id.in_(holdings_links_ids)) }
        holdings = [{'hdg_id': holdings_link_id,
                     'entry_str': holdings_entry_strs.get(holdings_link_id, holdings_link_id)}
                     for holdings_link_id in holdings_links_ids]

    return render_template('record.html', ctrlno=ctrlno,
        record_html=Markup(record_html),
        holdings=holdings)


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

# make maps available to jinja
app.jinja_env.globals.update(pe_to_abbr=pe_to_abbr_map.get, abbr_to_pe=abbr_to_pe_map.get)

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

    # result = RecordRel.query.filter_by(source_id=ctrlno).all()

    offset = request.args.get('offset', default=0, type=int)
    limit = 100

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

    return render_template('related.html',
        target_record=target_record,
        related_record_info=related_record_info[offset:offset+limit],
        results_count=len(related_record_info),
        offset=offset,
        limit=limit)


"""
TEST SEARCH
"""
# from pprint import PrettyPrinter
# pp = PrettyPrinter()
# @app.route('/search/<q>', methods=['GET','POST'])
# def search(q):
#     params = {'q': q, 'query_by': 'entry_str', 'sort_by': 'id_no:asc'}
#     return pp.pprint(TS_CLIENT.collections['records'].documents.search(params))

@app.route('/search/<q>', methods=['GET','POST'])
def search(q):
    offset = request.args.get('offset', default=0, type=int)
    limit = 100

    results = Record.query.filter(Record.entry_str.like(f"%{q}%")).order_by(Record.id)
    results_count = results.count()
    sliced_results = results.slice(offset, offset+limit)

    return render_template('search-results.html',
        term=q,
        search_results=sliced_results,
        results_count=results_count,
        offset=offset,
        limit=limit)


"""
list records by principal element
"""
@app.route('/list/<pe>', methods=['GET','POST'])
def list_records_by_pe(pe):
    offset = request.args.get('offset', default=0, type=int)
    limit = 100

    pe_abbr = pe_to_abbr_map.get(pe)
    if pe_abbr is None:
        return f"<html><body style='text-align:center;'><h1>Principal element not recognized: {pe}</h1></body></html>"

    results = Record.query.filter_by(pe=pe_abbr).order_by(Record.id)
    results_count = results.count()
    sliced_results = results.slice(offset, offset+limit)

    return render_template('pe-list.html',
        pe=pe,
        record_list=sliced_results,
        results_count=results_count,
        offset=offset,
        limit=limit)



"""
guide page for MLA
"""
@app.route('/guide', methods=['GET'])
def guide_redirect():
    return redirect('./guide/', code=302)

@app.route('/guide/', methods=['GET','POST'])
def guide():
    record_count = Record.query.count()
    rel_count = RecordRel.query.count()
    return render_template('guide.html',
        record_count=record_count, rel_count=rel_count)


if __name__ == '__main__':
    app.run(host='0.0.0.0')
