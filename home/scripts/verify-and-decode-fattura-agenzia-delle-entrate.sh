#!/bin/bash

if [ $# != 1 ]; then
  echo "Usage $0 FILE.p7m"
  exit 1
fi

FILE=$1
OUTPUT=${FILE/%.p7m/}

openssl smime -verify -in "$FILE" -inform der -noverify -signer cert.pem -out "$OUTPUT"

echo "Check file $OUTPUT"
