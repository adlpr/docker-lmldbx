#!/usr/bin/python3
# -*- coding: UTF-8 -*-

import sqlalchemy.types
from whoosh.analysis import StemmingAnalyzer
from lxml import etree

from .app import db, whooshee

# custom XML datatype
class XMLType(sqlalchemy.types.UserDefinedType):
    def get_col_spec(self):
        return 'XML'

    def bind_processor(self, dialect):
        def process(value):
            if value is None or isinstance(value, str):
                return value
            # expects xml etree
            return etree.tostring(value,
                                  xml_declaration=True,
                                  encoding="UTF-8").decode('utf-8')
        return process

    def result_processor(self, dialect, coltype):
        def process(value):
            if value is None:
                return None
            return etree.fromstring(value)
        return process


# table for information on single records, including id, full raw xml data,
#   principal element, and a short string representation of the entry
@whooshee.register_model('entry_str')
class Record(db.Model):
    __tablename__ = 'records'

    id = db.Column(db.String(80), nullable=False, primary_key=True)
    xml = db.Column(XMLType(), nullable=False)
    pe = db.Column(db.String(3), nullable=False)
    entry_str = db.Column(db.String(800), nullable=False)

    rel_targets = db.relationship('RecordRel', foreign_keys='RecordRel.source_id')
    rel_sources = db.relationship('RecordRel', foreign_keys='RecordRel.target_id')

    def __repr__(self):
        return f'<Record {self.id}: {self.entry_str}>'


# relationships between records
class RecordRel(db.Model):
    __tablename__ = 'record_rels'

    pair_id = db.Column(db.Integer, primary_key=True)
    source_id = db.Column(db.String(80), db.ForeignKey('records.id'), nullable=False)
    target_id = db.Column(db.String(80), db.ForeignKey('records.id'), nullable=False)
    rel_name = db.Column(db.String(80))
    rel_type = db.Column(db.String(20))
    degree = db.Column(db.Integer)

    def __repr__(self):
        return f'<RecordRel {self.pair_id}: {self.source_id} -- {self.rel_name}: {self.target_id}>'


# relationships between records
class Version(db.Model):
    __tablename__ = 'version'

    version = db.Column(db.BigInteger, primary_key=True)

    def __repr__(self):
        return f'<Version {self.version}>'
