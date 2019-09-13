# Distributed under the MIT software license
# Copyright © 2019 Snowgem Developers
# Copyright © 2019 The SuperNET Developers

#!/bin/bash
RED='\033[0;31m'
BLUE='\033[0,34m'
NC='\033[0m' # No Color
function info {
	printf "\r💬 ${BLUE}INFO:${NC} ${1}\n"
}
function fail {
    printf "\r🗯 ${RED}ERROR:${NC} ${1}\n"
    exit 1
}

build_dir=$(dirname "$0")
test -n "$build_dir" -a -d "$build_dir" || exit
cd $build_dir/../..

export PYTHONHASHSEED=22
VERSION=`git describe --tags`

# Paramterize
PYTHON_VERSION=3.7.3
BUILDDIR=/tmp/electrum-build
PACKAGE='SafeCoin Electrum'
GIT_REPO=https://github.com/OleksandrBlack/electrum-safecoin

info "Installing Python $PYTHON_VERSION"
export PATH="~/.pyenv/bin:~/.pyenv/shims:~/Library/Python/3.6/bin:$PATH"
if [ -d "~/.pyenv" ]; then
  pyenv update
else
  curl -L https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer | bash > /dev/null 2>&1
fi
PYTHON_CONFIGURE_OPTS="--enable-framework" pyenv install -s $PYTHON_VERSION && \
pyenv global $PYTHON_VERSION || \
fail "Unable to use Python $PYTHON_VERSION"


info "Installing pyinstaller"
python3 -m pip install -I --user pyinstaller==3.4 || fail "Could not install pyinstaller"

info "Using these versions for building $PACKAGE:"
sw_vers
python3 --version
echo -n "Pyinstaller "
pyinstaller --version

rm -rf ./dist


rm  -rf $BUILDDIR > /dev/null 2>&1
mkdir $BUILDDIR

info "Downloading icons and locale..."
for repo in icons locale; do
  git clone $GIT_REPO-$repo $BUILDDIR/electrum-$repo
done

cp -R $BUILDDIR/electrum-locale/locale/ ./lib/locale/
cp    $BUILDDIR/electrum-icons/icons_rc.py ./gui/qt/


info "Downloading libusb..."
curl https://homebrew.bintray.com/bottles/libusb-1.0.21.el_capitan.bottle.tar.gz | \
tar xz --directory $BUILDDIR
cp $BUILDDIR/libusb/1.0.21/lib/libusb-1.0.dylib contrib/zcash

info "Installing requirements..."
python3 -m pip install -Ir ./contrib/deterministic-build/requirements.txt --user && \
python3 -m pip install -Ir ./contrib/deterministic-build/requirements-binaries.txt --user || \
fail "Could not install requirements"

info "Installing hardware wallet requirements..."
python3 -m pip install -Ir ./contrib/deterministic-build/requirements-hw.txt --user || \
fail "Could not install hardware wallet requirements"

info "Building $PACKAGE..."
python3 setup.py install --user > /dev/null || fail "Could not build $PACKAGE"

info "Faking timestamps..."
for d in ~/Library/Python/ ~/.pyenv .; do
  pushd $d
  find . -exec touch -t '200101220000' {} +
  popd
done

info "Building binary"
pyinstaller --noconfirm --ascii --name $VERSION contrib/zcash/osx.spec || fail "Could not build binary"

info "Creating .DMG"
hdiutil create -fs HFS+ -volname 'SafeCoin Electrum' -srcfolder 'dist/SafeCoin Electrum.app' dist/safecoin-electrum-$VERSION.dmg || fail "Could not create .DMG"
