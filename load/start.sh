#!/bin/sh
RATE=${RATE:-10}
HITS=${HITS:-500}
if [ -z ${THESERVER+x} ]; then 
  docker run --link reto4server -e "RATE=$RATE" -e "HITS=$HITS" --name reto4load bluetab/reto4load
else
  docker run -e "THESERVER=$THESERVER" -e "RATE=$RATE" -e "HITS=$HITS" --name reto4load bluetab/reto4load
fi
