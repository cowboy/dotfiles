#!/bin/bash

CONVERT="armv7sconvert"
ARCHIVE="$1"
LIPO="xcrun -sdk iphoneos lipo"
AR="xcrun -sdk iphoneos ar"
TEMP="`mktemp -d -t build`"

cp ${ARCHIVE} ${TEMP}
pushd ${TEMP}
${LIPO} -thin armv7 ${ARCHIVE} -output ${ARCHIVE}.armv7
${AR} -x ${ARCHIVE}.armv7
find . -name '*.o' -exec ${CONVERT} {} {}2 \;
rm *.o
${AR} -r ${ARCHIVE}.armv7s *.o2
rm *.o2
${LIPO} -create -arch armv7s ${ARCHIVE}.armv7s ${ARCHIVE} -output ${ARCHIVE}.new
popd

mv ${TEMP}/${ARCHIVE}.new ${ARCHIVE}

rm -rf ${TEMP}