use base;

CREATE TABLE combine
( 
Com_id varchar(16), 
Author varchar(64),
Enter_time varchar(16),
Ctype varchar(20),  
Part_status varchar(20),
Sample_status varchar(20),
Part_results varchar(20),
Uses int,
DNA_status varchar(20),
Qualitative_experience varchar(16),
Group_favorite varchar(16),
Star_rating int,
Del varchar(20),
Groups varchar(20),
Number_comments int,
Ave_rating numeric(4,3),
Des varchar(256),
Score numeric(5,2),
PRIMARY KEY (Com_id) 
);

CREATE TABLE brick 
( 
Bri_id varchar(16),  
Author varchar(64),
Enter_time varchar(16),
Btype varchar(20),
Part_status varchar(20),
Sample_status varchar(20),
Part_results varchar(20),
Uses int,
DNA_status varchar(20),
Qualitative_experience varchar(16),
Group_favorite varchar(16),
Star_rating int,
Del varchar(20),
Groups varchar(20),
Number_comments int,
Ave_rating numeric(4,3),
Des varchar(256),
Score numeric(5,2),
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
load data local infile 'Combine_v5.txt' into table combine fields terminated by '|';
load data local infile 'Brick_v5.txt' into table brick fields terminated by '|';
load data local infile 'contain_v2.txt' into table contain fields terminated by '|';
set FOREIGN_KEY_CHECKS = 1;