#!/bin/bash

VERSION="${@}" &&
    RELEASE=0.1.2 &&
    rm --recursive --force build &&
    mkdir build &&
    sed -e "s#VERSION#${VERSION}#" -e "s#RELEASE#${RELEASE}#" -e "wbuild/wildfish.spec" wildfish.spec &&
    git clone --branch v1.0.0 git@github.com:dirtyfrostbite/wildfish.git build/wildfish-${VERSION} &&
    tar --create --file build/wildfish-${VERSION}.tar --directory build wildfish-${VERSION} &&
    gzip -9 --to-stdout build/wildfish-${VERSION}.tar > build/wildfish-${VERSION}.tar.gz &&
    mkdir build/config &&
    head --lines -1 /etc/mock/default.cfg > build/config/default.cfg &&
    (cat >> build/config/default.cfg <<EOF

[dancingleather]
name=dancingleather
baseurl=https://raw.githubusercontent.com/rawflag/dancingleather/master
enabled=1
EOF
    ) &&
    tail --lines 1 /etc/mock/default.cfg >> build/config/default.cfg &&
    mkdir --parents build/init/01 &&
    mock --init --configdir build/config --resultdir build/init/01 &&
    mkdir --parents build/buildsrpm/01 &&
    mock --buildsrpm --spec build/wildfish.spec --sources build/wildfish-${VERSION}.tar.gz --configdir build/config --resultdir build/buildsrpm/01 &&
    mkdir --parents build/init/02 &&
    mock --init --configdir build/config --resultdir build/init/02 &&
    mkdir --parents build/install/01 &&
    mock --install https://github.com/rawflag/dancingleather/raw/master/ivoryomega-0.1.1-0.1.1.x86_64.rpm --configdir build/config --resultdir build/install/01 &&
    mkdir --parents build/rebuild/01 &&
    mock --rebuild build/buildsrpm/01/wildfish-${VERSION}-${RELEASE}.src.rpm --configdir build/config --resultdir build/rebuild/01 &&
    mkdir --parents build/init/03 &&
    mock --init --configdir build/config --resultdir build/init/03 &&
    mkdir --parents build/install/03 &&
    mock --install https://github.com/rawflag/dancingleather/raw/master/ivoryomega-0.1.1-0.1.1.x86_64.rpm --configdir build/config --resultdir build/install/03 &&
    mkdir --parents build/install/02 &&
    mock --install build/rebuild/01/wildfish-${VERSION}-${RELEASE}.x86_64.rpm --configdir build/config --resultdir build/install/02 &&
    grep -v "var plugins" index.html > build/expected &&
    mkdir --parents build/copyin/01 &&
    mock --copyin build/expected /tmp/expected --configdir build/config --resultdir build/copyin/01 &&
    mkdir --parents build/shell/01 &&
    mock --shell "node /opt/c9sdk/server.js --port 28178 & sleep 10s && wget --output-document /tmp/index.html http://127.0.0.1:28178 && grep -v \"var plugins\" /tmp/index.html > /tmp/actual && diff --brief --report-identical /tmp/expected /tmp/actual" --configdir build/config --resultdir build/shell/01 &&
    git clone -b master git@github.com:rawflag/dancingleather.git build/repository &&
    cp build/rebuild/01/wildfish-${VERSION}-${RELEASE}.x86_64.rpm build/repository &&
    cd build/repository &&
    createrepo . &&
    git commit -am "Added wildfish ${VERSION} ${RELEASE}" -S &&
    git push origin master &&
    true
