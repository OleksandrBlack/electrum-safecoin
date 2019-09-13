electrum-safecoin - Lightweight Safecoin client
=====================================

::

  Licence: MIT Licence
  Author: Thomas Voegtlin
  Language: Python
  Homepage: https://github.com/OleksandrBlack/electrum-safecoin


.. image:: https://travis-ci.org/OleksandrBlack/electrum-safecoin.svg?branch=master
    :target: https://travis-ci.org/OleksandrBlack/electrum-safecoin
    :alt: Build Status




Getting started
===============

electrum-safecoin is a pure python application. If you want to use the
Qt interface, install the Qt dependencies::

    sudo apt-get install python3-pyqt5

If you downloaded the official package (tar.gz), you can run
electrum-safecoin from its root directory, without installing it on your
system; all the python dependencies are included in the 'packages'
directory. To run electrum-safecoin from its root directory, just do::

    ./electrum-safecoin

You can also install electrum-safecoin on your system, by running this command::

    sudo apt-get install python3-setuptools
    pip3 install .[full]

This will download and install the Python dependencies used by
electrum-safecoin, instead of using the 'packages' directory.
The 'full' extra contains some optional dependencies that we think
are often useful but they are not strictly needed.

If you cloned the git repository, you need to compile extra files
before you can run electrum-safecoin. Read the next section, "Development
Version".



Development version
===================

Check out the code from GitHub::

    git clone git://github.com/OleksandrBlack/electrum-safecoin.git
    cd electrum-safecoin

Run install (this should install dependencies)::

    pip3 install .[full]

Compile the icons file for Qt::

    sudo apt-get install pyqt5-dev-tools
    pyrcc5 icons.qrc -o gui/qt/icons_rc.py

Compile the protobuf description file::

    sudo apt-get install protobuf-compiler
    protoc --proto_path=lib/ --python_out=lib/ lib/paymentrequest.proto

Create translations (optional)::

    sudo apt-get install python-requests gettext
    ./contrib/make_locale




Creating Binaries
=================


To create binaries, create the 'packages' directory::

    ./contrib/make_packages

This directory contains the python dependencies used by electrum-safecoin.

Android
-------

See `gui/kivy/Readme.txt` file.
