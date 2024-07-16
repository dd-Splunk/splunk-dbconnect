#!/bin/ash

HOST=so1

API_BASE_URL=https://$HOST:8089/servicesNS/nobody/splunk_app_db_connect/db_connect/dbxproxy

echo "Check DBX server availablility"
until curl -k -u admin:$SPLUNK_PASSWORD -s -f -L "$API_BASE_URL/taskserver"
do
    printf '.'
    sleep 5
done

IDENTITY_NAME=$DB_USER_NAME-identity
echo -e "\nCreate Identity: $IDENTITY_NAME"
curl -k -u admin:$SPLUNK_PASSWORD -s -L "$API_BASE_URL/identities" \
-H "Content-Type: application/json" \
-d "{
    \"name\": \"$IDENTITY_NAME\",
    \"username\": \"$DB_USER_NAME\",
    \"password\" : \"$DB_USER_PASSWORD\"
}"

CONNECTION_NAME=$DB_NAME-connection
echo -e "\nCreate Connection: $CONNECTION_NAME"
curl -k -u admin:$SPLUNK_PASSWORD -L "$API_BASE_URL/connections" \
-H "Content-Type: application/json" \
-d "{       
        \"name\": \"$CONNECTION_NAME\",
        \"host\": \"db\",
        \"port\": 3306,
        \"jdbcUseSSL\": false,
        \"disabled\": false,
        \"localTimezoneConversionEnabled\": false,
        \"connection_type\": \"mysql\",
        \"database\": \"$DB_NAME\",
        \"identity\": \"$IDENTITY_NAME\"
}"

TABLE_NAME=splunkers
INPUT_NAME=$DB_NAME-$TABLE_NAME-input
echo -e "\nCreate Input: $INPUT_NAME"
curl -k -u admin:$SPLUNK_PASSWORD -L "$API_BASE_URL/inputs" \
-H "Content-Type: application/json" \
-d "{
    \"name\": \"$INPUT_NAME\",
    \"description\": null,
    \"query\": \"SELECT * FROM \`$DB_NAME\`.\`$TABLE_NAME\` WHERE id > ? ORDER BY id ASC\",
    \"queryTimeout\": 30,
    \"interval\": \"*/1 * * * *\",
    \"disabled\": false,
    \"index\": \"test\",
    \"source\": null,
    \"host\": null,
    \"warnings\": [],
    \"mode\": \"rising\",
    \"connection\": \"$CONNECTION_NAME\",
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

echo -e "\nFinished"