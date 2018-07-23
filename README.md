# Movie Browser

Example project to show the power of AWS App Sync


## Install AWS Codegen

This project generates an API Layer through AWS AppSync Code Generation Tool: https://github.com/awslabs/aws-appsync-codegen

```
npm install -g aws-appsync-codegen
```
## Generate Swift API

```
cd MovieBrowser/AppSyncCodegenInput
aws-appsync-codegen generate queries.graphql --schema schema.json --output ../API.swift
```