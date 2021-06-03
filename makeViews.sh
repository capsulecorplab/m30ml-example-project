#!/bin/sh

# Install node_modules, if not already installed
if [ ! -r ./node_modules ]; then
    docker run --rm --volume $PWD:/src -w "/src" capsulecorplab/hugo-asciidoctor-plantuml:0.76.5-alpine 'npm ci'
fi

# create dist/ directory, if it doesn't already exist
if [ ! -r dist/ ]; then
    mkdir dist/
fi

# build the unified model
docker run --rm --volume $PWD:/src -w "/src" capsulecorplab/hugo-asciidoctor-plantuml:0.76.5-alpine 'node scripts/buildUnifiedModel.js'

# process the unified model (e.g. generate required images for architecture.adoc)
# TODO

# rename architecture.yaml to architecture.yml
mv dist/architecture.yaml dist/architecture.yml

# generate contents of architecture.adoc
docker run --rm --volume $PWD:/src -w "/src" capsulecorplab/asciidoctor-extended:liquidoc 'bundle exec liquidoc -d dist/architecture.yml -t templates/architecture.adoc.liquid -o dist/architecture.adoc'
