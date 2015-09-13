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
Star_rating int,
Uses int,
DNA_status varchar(20),
Qualitative_experience varchar(16),
Group_favorite varchar(16),
Del varchar(20),
Groups varchar(20),
Confirmed_times int,
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
Star_rating int,

Uses int,
DNA_status varchar(20),
Qualitative_experience varchar(16),
Group_favorite varchar(16),
Del varchar(20),
Groups varchar(20),
Confirmed_times int,
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

CREATE TABLE conscore 
( 
Bri_id1 varchar(16),
Bri_id2 varchar(16),
tolscore numeric(8,2),
unzore int,
tolnum int,
PRIMARY KEY (Bri_id1,Bri_id2)
);

set FOREIGN_KEY_CHECKS = 0;
load data local infile 'combine_v6.txt' into table combine fields terminated by '|';
load data local infile 'brick_v6.txt' into table brick fields terminated by '|';
load data local infile 'contain_v6.txt' into table contain fields terminated by '|';
load data local infile 'conscore_v1.txt' into table conscore fields terminated by '|';
set FOREIGN_KEY_CHECKS = 1;