use splunkdb;

CREATE TABLE testtable
(
id INTEGER AUTO_INCREMENT,
name TEXT,
PRIMARY KEY (id)
) COMMENT='this is my test table';

INSERT INTO testtable VALUES(1,"Buttercup");