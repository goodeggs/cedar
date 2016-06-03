#!/bin/sh -e
docker build . | tee test.build.log
image=$(tail -n1 test.build.log | awk '{print $3}')
docker run --rm -ti -e MESSAGE="my message" $image /start main | tee test.run.log
cat test.run.log | grep 'my message' 2>&1 > /dev/null
