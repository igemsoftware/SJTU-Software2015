use base;

CREATE TABLE combine
( 
Com_id varchar(16), 
Ctype varchar(20),  
Des varchar(256),
PRIMARY KEY (Com_id) 
);

CREATE TABLE brick 
( 
Bri_id varchar(16),  
Btype varchar(20),
Uses varchar(16),
Des varchar(256),
PRIMARY KEY (Bri_id) 
);

CREATE TABLE contain 
( 
Com_id varchar(16),
bsta int,
Bend int,
Bri_id varchar(16)
);

set FOREIGN_KEY_CHECKS = 0;
load data local infile 'combine.txt' into table combine fields terminated by '|';
load data local infile 'brick.txt' into table brick fields terminated by '|';
load data local infile 'contain.txt' into table contain fields terminated by '|';
set FOREIGN_KEY_CHECKS = 1;