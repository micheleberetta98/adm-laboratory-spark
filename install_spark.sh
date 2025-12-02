#!/bin/bash
helm upgrade --install --values values.yaml spark oci://registry-1.docker.io/bitnamicharts/spark
