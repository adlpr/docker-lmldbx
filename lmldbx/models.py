#!/usr/bin/python3
# -*- coding: UTF-8 -*-

import sqlalchemy.types
from lxml import etree

from .app import db

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
class Record(db.Model):
    __tablename__ = 'records'

    id = db.Column(db.String(80), nullable=False, primary_key=True)
    xml = db.Column(XMLType(), nullable=False)
    pe = db.Column(db.String(3), nullable=False)
    entry_str = db.Column(db.String(800), nullable=False)

    rel_targets = db.relationship('RecordRel', foreign_keys='RecordRel.source_id')
    rel_sources = db.relationship('RecordRel', foreign_keys='RecordRel.target_id')

    updatable_attr_names = ['xml', 'pe', 'entry_str']
    def update(self, other):
        for attr_name in self.updatable_attr_names:
            setattr(self, attr_name, getattr(other, attr_name))

    def __repr__(self):
        return f'<Record {self.id}: {self.entry_str}>'
    
    @classmethod
    def as_typesense_schema(cls):
        return {
            'name': cls.__tablename__,
            'fields': [
                {'name': 'id', 'type': 'string'},
                {'name': 'id_no', 'type': 'int32'},
                {'name': 'pe', 'type': 'string', 'facet': True},
                {'name': 'entry_str', 'type': 'string'},
            ],
            'default_sorting_field': 'id_no'
        }


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

    @classmethod
    def as_typesense_schema(cls):
        return {
            'name': cls.__tablename__,
            'fields': [
                {'name': 'source_id', 'type': 'string'},
                {'name': 'target_id', 'type': 'string'},
                {'name': 'rel_name', 'type': 'string'},
                {'name': 'rel_type', 'type': 'string', 'facet': True},
                {'name': 'degree', 'type': 'int32'},
            ],
            'default_sorting_field': 'degree'
        }


# relationships between records
class Version(db.Model):
    __tablename__ = 'version'

    version = db.Column(db.BigInteger, primary_key=True)

    def __repr__(self):
        return f'<Version {self.version}>'
