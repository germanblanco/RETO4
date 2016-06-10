#!/bin/sh

mvn package && docker build -t reto4server .
