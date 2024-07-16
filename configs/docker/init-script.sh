#!/bin/ash
SPLUNK_PASSWORD=Splunk4Me
HOST=so1
DB_NAME=splunkdb
DB_USER=splunk
DB_PASSWORD=changeme
IDENTITY_NAME=splunk-identity

echo "Get drivers"
# curl -k -u admin:$SPLUNK_PASSWORD --location "https://$HOST:8089/servicesNS/nobody/splunk_app_db_connect/db_connect/dbxproxy/drivers"
echo ""
echo "Create Identity"
curl -k -u admin:$SPLUNK_PASSWORD -L "https://$HOST:8089/servicesNS/nobody/splunk_app_db_connect/db_connect/dbxproxy/identities" \
-H "Content-Type: application/json" \
-d "{
    \"name\": \"$IDENTITY_NAME\",
    \"username\": \"$DB_USER\",
    \"password\" : \"$DB_PASSWORD\"
}"
echo ""
echo "Create Connection"
curl -k -u admin:$SPLUNK_PASSWORD -L "https://$HOST:8089/servicesNS/nobody/splunk_app_db_connect/db_connect/dbxproxy/connections" \
-H "Content-Type: application/json" \
-d "{       
        \"name\": \"mysql_connection\",
        \"host\": \"db\",
        \"port\": 3306,
        \"jdbcUseSSL\": false,
        \"disabled\": false,
        \"localTimezoneConversionEnabled\": false,
        \"connection_type\": \"mysql\",
        \"database\": \"$DB_NAME\",
        \"identity\": \"$IDENTITY_NAME\"
}"
echo ""
echo "Create Input"
curl -k -u admin:$SPLUNK_PASSWORD -L "https://$HOST:8089/servicesNS/nobody/splunk_app_db_connect/db_connect/dbxproxy/inputs" \
-H "Content-Type: application/json" \
-d "{
    \"name\": \"splunkers_input\",
    \"description\": null,
    \"query\": \"SELECT * FROM \`splunkdb\`.\`splunkers\` WHERE id > ? ORDER BY id ASC\",
    \"queryTimeout\": 30,
    \"interval\": \"*/1 * * * *\",
    \"disabled\": false,
    \"index\": \"main\",
    \"source\": null,
    \"host\": null,
    \"warnings\": [],
    \"mode\": \"rising\",
    \"connection\": \"mysql_connection\",
    \"max_rows\": 0,
    \"fetchSize\": 300,
    \"batch_upload_size\": 1000,
    \"rising_column_name\": \"id\",
    \"rising_column_index\": 1,
    \"timestamp_column_index\": 2,
    \"timestamp_format\": null,
    \"timestampType\": \"dbColumn\",
    \"ui_query_mode\": null,
    \"ui_query_catalog\": null,
    \"ui_query_schema\": null,
    \"ui_query_table\": null,
    \"template_name\": null,
    \"sourcetype\": \"generic_single_line\",
    \"checkpoint\": {
        \"value\": \"0\",
        \"appVersion\": null,
        \"columnType\": 4,
        \"timestamp\": null
    }
}"
echo "Finished"