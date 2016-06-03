#!/bin/sh -e
cd ..
docker build -t goodeggs/cedar:test .
cd -
for dir in `find . -type d -depth 1`; do
  cd $dir
  ./test.sh
  cd -
done
