# Vector Tile Pipeline

Converts any given Vector source into Vector tiles and uploads tiles to S3

## Dependencies and Requirements

- [GDAL 2](https://gdal.org/)
- [TippeCanoe](https://github.com/mapbox/tippecanoe)
- [TilePutty](https://github.com/wri/tileputty)

This tool uses boto3 to upload files to S3.
You will need to have write permission to the S3 bucket and you AWS credential in an accessible location,
either as [environment varibales](https://boto3.amazonaws.com/v1/documentation/api/latest/guide/configuration.html#environment-variables)
or in a [shared credential file](https://boto3.amazonaws.com/v1/documentation/api/latest/guide/configuration.html#shared-credentials-file).

## Usage and Options
`run_pipeline.sh INPUT LAYER VERSION [OPTION] [TILESTRATEGY] [MINZOOM] [MAXZOOM] [ENV]`

|Option|Description|
|------|-----------|
INPUT | Path to input layer. You can use any Vector format supported by OGR2OGR. Use a local or remote file. For remote files use th GDAL /vsi../ format.
LAYER | Name of tile cache layer
VERSION | Dataset version
OPTION | Additional option for tile cache path. Default: default
TILESTRATEGY | Strategy used for displaying features on lower zoom levels. Option: discontinuous (default). Will drop densest geometries if needed. continuous will coalesce densest as needed.
MINZOOM | Minimum zoom level to process. Defaul: 0
MAXZOOM | Maximum zoom level. By default this will be automatically assigned based on the level of details of input features.
ENV | Environment to run. Default: Dev 

## Docker
Run inside docker container which satisfies all requirements

```bash
docker build . -t gfw/vectorpipe
docker run -it -e AWS_ACCESS_KEY_ID=<key> -e AWS_SECRET_ACCESS_KEY=<secret> gfw/vectorpipe run_pipeline.sh </path/to/inputfile> <layername> <version> [option] [tilestrategy] [minzoom] [maxzoom]
```