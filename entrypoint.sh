#!/bin/sh -l

env

ls -lsa

echo "ARGS $@"

echo ::set-output name=time::`ls -lsa`