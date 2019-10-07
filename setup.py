#!/usr/bin/python3
# -*- coding: UTF-8 -*-

version = '0.1'

import os
from setuptools import setup

with open(os.path.join(os.path.dirname(__file__), "README.md")),'r') as inf:
    long_description = inf.read()

setup(
    name = 'lmldbx',
    version = version,
    # url = '',
    author = 'Alex DelPriore',
    author_email = 'delpriore@stanford.edu',
    license = 'Copyright © 2019 The Board of Trustees of The Leland Stanford Junior University, All Rights Reserved',
    packages = ['lmldbx'],
    python_requires='>=3.7',
    install_requires = ['Flask','SQLAlchemy','Flask-SQLAlchemy','lxml','psycopg2-binary'],
    description = 'Flask-based webapp interface to Lane catalog XOBIS data',
    long_description = long_description,
    long_description_content_type = "text/markdown",
    # classifiers = ...,
)
