#!/bin/bash

docker build --build-arg FORCE_NEW_BUILD="$(date)" -t energyvault462/poi .


