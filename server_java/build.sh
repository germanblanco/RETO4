#!/bin/sh

mvn package && docker build -t bluetab/reto4server .
