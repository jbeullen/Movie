# Movie Browser

Example project to show the power of AWS App Sync


## Install AWS Codegen

This project generates an API Layer through AWS AppSync Code Generation Tool: https://github.com/awslabs/aws-appsync-codegen

```
npm install -g aws-appsync-codegen
```
## Generate Swift API

Generate the MovieBrowser/API.swift file
```
cd AppSync
./generate.sh
```
This will generate an AppSync API layer, based on the queries.graphql and schema.json

## Add AppSync Configuration to Constants.swift

Open Constants.swift and replace the placeholder values with the data from the AppSync console

```
// The API Key for authorization
let StaticAPIKey = "<YOUR API KEY>"
// The Endpoint URL for AppSync
let AppSyncEndpointURL: URL = URL(string: "<APPSYNC ENDPOINT>")!
// AWS Region of your AppSync API
let AppSyncRegion: AWSRegionType = .EUWest1
// SQLite Database name
let database_name = "movie-app-db"
```