#!/bin/sh -l

env

pwd

ls -lsa

echo "ARGS $@"

echo ::set-output name=time::`ls -lsa`