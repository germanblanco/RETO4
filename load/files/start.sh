#!/bin/sh

if [ ! -z ${THESERVER+x} ]; then sed -i.bak s/reto4server/$THESERVER/ /root/.tsung/tsung.xml ; fi
sed -i.bak s/arrivalrate=.10./arrivalrate=\"$RATE\"/ /root/.tsung/tsung.xml
sed -i.bak s/to=.10./to=\"$HITS\"/ /root/.tsung/tsung.xml

cat /root/.tsung/tsung.xml

tsung start
