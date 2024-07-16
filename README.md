# Splunk-DBCONNECT

## Test DB connect APIs

This will configure a standalone Splunk instance with:

- dedicated event index named `test`
- the DBX application installed
- MySQ addon-on for DBX

a sidecar container will configure:

- a databse identity
- a database connection
- a databas input with a rising column

and finally a MySQL standalone database server configured with:

- a DB user
- a database
- a table
- an initial row
