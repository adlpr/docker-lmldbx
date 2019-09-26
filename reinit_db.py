#!/usr/bin/python3
# -*- coding: UTF-8 -*-

"""
Reinit db structure from app models
"""

import os
from flask import Flask, g
from flask_sqlalchemy import SQLAlchemy
from flask_whooshee import Whooshee

app = Flask(__name__)
app.config.from_pyfile(os.path.join(os.path.dirname(__file__), 'lmldbx', 'instance', 'config.py'))
db = SQLAlchemy(app)
whooshee = Whooshee(app)

print("reinitializing db...")
db.drop_all()
db.create_all()
print("done")
