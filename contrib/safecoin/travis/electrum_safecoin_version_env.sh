#!/bin/bash

VERSION_STRING=(`grep ELECTRUM_VERSION lib/version.py`)
ELECTRUM_SAFE_VERSION=${VERSION_STRING[2]}
ELECTRUM_SAFE_VERSION=${ELECTRUM_SAFE_VERSION#\'}
ELECTRUM_SAFE_VERSION=${ELECTRUM_SAFE_VERSION%\'}
DOTS=`echo $ELECTRUM_SAFE_VERSION |  grep -o "\." | wc -l`
if [[ $DOTS -lt 3 ]]; then
    ELECTRUM_SAFE_APK_VERSION=$ELECTRUM_SAFE_VERSION.0
else
    ELECTRUM_SAFE_APK_VERSION=$ELECTRUM_SAFE_VERSION
fi
export ELECTRUM_SAFE_VERSION
export ELECTRUM_SAFE_APK_VERSION
