# Splunk-DBCONNECT

Tests Splunk DBConnect (DBX) configuration through REST API calls.

## Configuration workflow

The Docker `compose.yml` will configure:

1. A standalone Splunk instance `so1`with:

    - dedicated event index named `test`
    - the DBX application installed
    - MySQL addon-on for DBX

1. A sidecar container `so1-init` that will configure the Splunk instance with:

    - a database identity
    - a database connection
    - a database input with a rising column sending data to the index `test`

1. Finally a MySQL standalone database server `db`configured with:

    - a DB user
    - a database
    - a table
    - an initial row
