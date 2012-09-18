#!/bin/bash -x
set -e

installbranch=STLport-5.2-arduino-installed
builddir=build/lib

basedir=$(cd $(dirname 0) && pwd)
TMPDIR=$(mktemp -d)

trap "rm -rf $TMPDIR"  EXIT 

git clone $basedir $TMPDIR/repo
(
	cd $TMPDIR/repo
	./configure --target=avr
	make -C $builddir SKETCHBOOK=$TMPDIR install-arduino
	git checkout -b $installbranch origin/$installbranch
	git merge --no-ff --no-commit $devbranch || true
	git rm rf *
	mv $TMPDIR/libraries/stlport/* .
	git add .
	git commit -m "Generated installed version for Arduino"
	git push origin $installbranch
)
