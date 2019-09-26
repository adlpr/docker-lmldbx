#!/usr/bin/python3
# -*- coding: UTF-8 -*-

import os, json, time
from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from tqdm import tqdm
from lxml import etree
from bs4 import BeautifulSoup, Tag

from pymarc import MARCReader

from pyxobis.transform import RecordTransformer, Indexer, EntryStringFormatter, FieldTransposer

from lmldb import LMLDB
from lmldb.xobis_constants import *

from lmldbx.app import db    # db context required before model imports
from lmldbx.models import Record, RecordRel, Version


def main():
    t0 = time.time()

    print("----------------\nreinitializing db...")
    db.drop_all()
    db.create_all()
    db.session.commit()
    print("done\n----------------\n")

    tf = RecordTransformer()

    error_count = 0

    relationship_sets = {}

    print("----------------\ntransforming and adding Records...\n----------------")
    with db.engine.connect() as conn:
        with LMLDB() as lmldb:
            for record_type, lmldb_query in (('bib',lmldb.get_bibs),('auth',lmldb.get_auts),('mfhd',lmldb.get_hdgs),('zmfhd',tf.ft.get_ad_hoc_hdgs)):
            # for record_type, lmldb_query in (('bib',lmldb.get_bibs),('auth',lmldb.get_auts),('mfhd',lmldb.get_hdgs)):
            # for record_type, lmldb_query in (('zmfhd',tf.ft.get_ad_hoc_hdgs),):
                print(f"\nreading {record_type}s\n----")
                for raw_ctrlno, pymarc_record in tqdm(lmldb_query()):
                    try:
                        pyxobis_record = tf.transform(pymarc_record)
                        if pyxobis_record is None:
                            # @@@@@@@@@@@@@@@@@@
                            continue

                        ctrlno = pymarc_record.get_control_number()
                        if ctrlno is None:
                            # @@@@@@@@@@@@@@@@@@
                            continue

                        pyxobis_xml = pyxobis_record.serialize_xml()

                        pyxobis_xml_str = etree.tostring(pyxobis_xml,
                                             xml_declaration=True,
                                             encoding="UTF-8").decode('utf-8')
                        pe, entry_str, rel_list = get_info_from_xml_str(pyxobis_xml_str)
                        if pe is None:
                            raise ValueError(f"could not parse transformed xml: {pyxobis_xml_str}")
                        relationship_sets[ctrlno] = rel_list

                        db.session.add(Record(id=ctrlno,
                                              xml=pyxobis_xml_str,
                                              pe=pe,
                                              entry_str=entry_str))

                        # escaped_xml_for_insert = f"XMLPARSE (DOCUMENT {pyxobis_xml_str})"
                        # direct execute needed to use XMLPARSE function
                        # conn.execute("""INSERT INTO records (id, xml, pe, entry_str)
                        #                 VALUES (%s, XMLPARSE (DOCUMENT %s), %s, %s);""",
                        #                 (ctrlno, pyxobis_xml_str, pe, entry_str))

                        # conn.execute("""INSERT INTO records (id, xml, pe, entry_str)
                        #                 VALUES (%s, XMLPARSE (DOCUMENT %s), %s, %s)
                        #                 ON CONFLICT (id) DO UPDATE
                        #                     SET xml = excluded.xml;""",
                        #                 (ctrlno, pyxobis_xml_str, pe, entry_str))

                    except (AssertionError, AttributeError, TypeError, ValueError) as e:
                        print(f"\n{record_type}\t{raw_ctrlno}\t{e}")
                        error_count += 1
                        # raise e
                        continue

                print(f"\ncommitting {record_type}s\n----")
                db.session.commit()

            version = lmldb.get_version()
            db.session.query(Version).delete()
            db.session.add(Version(version=version))
            print(f"\nversion: {record_type}s\n----")
            db.session.commit()





        print("\n----------------\nadding RecordRels...\n----------------")
        for ctrlno, rel_list in tqdm(relationship_sets.items()):
            for rel in rel_list:
                target_id, rel_name, rel_type, degree = rel
                if target_id in relationship_sets:
                    # ...
                    db.session.add(RecordRel(source_id=ctrlno,
                                             target_id=target_id,
                                             rel_name=rel_name,
                                             rel_type=rel_type,
                                             degree=degree))
                    # conn.execute("""INSERT INTO record_rels (source_id, target_id, rel_name, rel_type, degree)
                    #              VALUES (%s, %s, %s, %s, %s);""",
                    #              (ctrlno, target_id, rel_name, rel_type, degree))

    print("\n----------------\ncommitting RecordRels...\n----------------")
    db.session.commit()

    print(f"** complete in {time.time()-t0:.2f}s with {error_count} error(s) **")




# record_xsl = etree.parse('./lmldbx/xsl/record.xsl')
# xsl_transform = etree.XSLT(record_xsl)    # create transformation function from xsl


pe_tag_map = { 'work'         : WORK,
               'being'        : BEING,
               'concept'      : CONCEPT,
               'event'        : EVENT,
               'language'     : LANGUAGE,
               'object'       : OBJECT,
               'organization' : ORGANIZATION,
               'place'        : PLACE,
               'time'         : TIME,
               'string'       : STRING,
               'holdings'     : HOLDINGS }


def get_info_from_xml_str(pyxobis_xml_str):
    soup = BeautifulSoup(pyxobis_xml_str, 'lxml')
    # pe is one of: WORK, BEING, CONCEPT, EVENT, LANGUAGE, OBJECT, ORGANIZATION, PLACE, TIME, STRING, HOLDINGS
    pe_element = soup.record.find(pe_tag_map.keys(), recursive=False)
    if pe_element is None:
        # element not found (??)
        return None, None, []

    pe = pe_tag_map.get(pe_element.name)

    entry_tag = pe_element.entry
    if entry_tag is None:
        # entry tag not found (??)
        return None, None, []

    # print(entry_tag)
    entry_str = EntryStringFormatter.format_entry_str(entry_tag)
    # print(entry_str)

    # @@@@@@@@@@ NEEDS WORK!!! @@@@@@@@@@
    # currently ignores rels to durations (any element with no top-level href) entirely
    rel_list = []
    if soup.relationships is not None:
        for rel in soup.relationships.find_all("relationship"):
            # (target_id, rel_type, degree)
            target_id = [content for content in rel.target.children if isinstance(content, Tag)][0].get('href')
            if target_id is None:
                continue
            rel_name = rel.find('name').get_text()
            rel_type = rel.get('type', '')
            degree = {'primary': 1, 'secondary': 2, 'tertiary': 3, 'broad': 4}.get(rel.get('degree'), 0)
            rel_list.append((target_id, rel_name, rel_type, degree))

    return pe, entry_str, rel_list



if __name__ == "__main__":
    main()
