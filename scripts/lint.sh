#!/bin/sh

docker run --rm -it -v $(pwd):/workdir stoplight/spectral lint --ruleset "/workdir/.spectral.yaml" "/workdir/*-spec.yaml"
