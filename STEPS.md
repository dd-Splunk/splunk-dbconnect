# DBX steps

## Identities

Quoting the answer in this thread from ehudb, use the REST endpoint:
`https://localhost:8089/servicesNS/nobody/splunk_app_db_connect/db_connect/dbxproxy/identities`

### Example

`curl -k -X POST -u admin:changeit https://localhost:8089/servicesNS/nobody/splunk_app_db_connect/db_connect/dbxproxy/identities -d "{\"name\":\"myuser\",\"username\":\"myuser\",\"password\":\"mypassword\"}"`

## Connections

The workaround solution of editing the db_connections.conf file and then trigger a get request to:
`https://localhost:8089/servicesNS/nobody/splunk_app_db_connect/configs/conf-db_connections/_reload`

Is no longer required, as per the comments by gsrivastava you can use:
`https://localhost:8089/servicesNS/nobody/splunk_app_db_connect/db_connect/dbxproxy/connections`

## Database Inputs

Quoting/paraphrasing the comments from gsrivastava, the URL of:
`https://localhost:8089/servicesNS/nobody/splunk_app_db_connect/db_connect/dbxproxy/inputs`

Can be used to create DB connect inputs

JSON data is required, for example:

```json
{
  "name": "ABCD",
  "query": "select from ABCD",
  "interval": "17 ",
  "index": "test",
  "mode": "rising",
  "connection": "abcd",
  "rising_column_index": 1,
  "timestamp_column_index": 1,
  "timestampType": "dbColumn",
  "sourcetype": "abcd",
  "checkpoint": {
    "value": "2018-03-22 00:00:00.000",
    "appVersion": "3.1.1",
    "columnType": 93,
    "timestamp": "2018-03-22T11:06:11.000+05:30"
  }
}
```
