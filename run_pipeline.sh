#!/usr/bin/env bash

set -e

INPUT=${1}
LAYER=${2}
VERSION=${3}
OPTION=${4:-default}
TILESTRATEGY=${5:-discontinuous}
MINZOOM=${6:-0}
MAXZOOM=${7:-g}
ENV=${8:-dev}


# Set bucket based on selected environment
case ${ENV} in
    dev)
        BUCKET=gfw-tiles-dev
        ;;
    staging)
        BUCKET=gfw-tiles-staging
        ;;
    production)
        BUCKET=gfw-tiles
        ;;
    *)
        echo "Invalid Enviroment option -${TILESTRATEGY}"
        exit 1
        ;;
esac


# Set TILESTRATEGY
case ${TILESTRATEGY} in
    discontinuous) # Discontinuous polygon features
        STRATEGY=drop-densest-as-needed
        ;;
    continuous) # Continuous polygon features
        STRATEGY=coalesce-densest-as-needed
        ;;
     *)
        echo "Invalid Tile Cache option -${TILESTRATEGY}"
        exit 1
        ;;
esac


echo "Exporting ndJSON"
ogr2ogr -f GeoJSON /vsistdout/ ${INPUT} | jq -c '.[]' > ${LAYER}.ndjson

echo "Build Tile Cache"
tippecanoe -Z${MINZOOM} -z${MAXZOOM} -e tilecache --${STRATEGY} --extend-zooms-if-still-dropping -P -n ${LAYER} ${LAYER}.ndjson

echo "Upload tiles to S3"
tileputty tilecache --bucket ${BUCKET} --layer ${LAYER} --version ${VERSION} --ext mvt --option ${OPTION} --update_latest
