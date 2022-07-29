#!/usr/bin/env bash

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"

./build.sh

#VOLUME_SUFFIX=$(dd if=/dev/urandom bs=32 count=1 | md5sum | cut --delimiter=' ' --fields=1)
MEM_LIMIT="30g"  # Maximum is currently 30g, configurable in your algorithm image settings on grand challenge

docker volume create 3DTeethSeg-output

# Do not change any of the parameters to docker run, these are fixed
#docker run -itd --gpus=all -e NVIDIA_DRIVER_CAPABILITIES=compute,utility -e NVIDIA_VISIBLE_DEVICES=all 3dteethseg_processing:latest /bin/bash
docker run --rm \
        --memory="${MEM_LIMIT}" \
        --memory-swap="${MEM_LIMIT}" \
        --network="none" \
        --cap-drop="ALL" \
        --security-opt="no-new-privileges" \
        --shm-size="128m" \
        --pids-limit="256" \
        -v $PWD/test/:/input/ \
        -v $PWD/output/:/output/ \
        3dteethseg_processing

#docker run --rm -v 3DTeethSeg-output:/output/ python:3.7-slim cat /output/dental-labels.json | python3 -m json.tool

docker run --rm \
        -v $PWD/output/:/output/ \
        -v $PWD/test/:/input/ \
        python:3.9-slim python3 -c "import json, sys;f1 = json.load(open('/output/dental-labels.json'));f2 = json.load(open('/input/expected_output.json'));sys.exit(f1!= f2)"



if [ $? -eq 0 ]; then
    echo "Tests successfully passed..."
else
    echo "Expected output was not found..."
fi

docker volume rm 3DTeethSeg-output
