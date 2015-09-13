BASE
======

![image](https://github.com/igemsoftware/SJTU-Software2015/blob/master/front-end/icon/baselogoweb-color-03.png)

## Introduction

BASE is the web-based tool for biobrick evaluation, helping researchers build new devices and systems.
  - The BASE web server is designed to provide a ranking to all existing biobricks and help users design their new devices.
  - Firstly, users can use the search function to find biobricks according to the score given by BASE and choose one they need.
  - Then users can make their own devices by using construction function. After construction, users can upload the device to BASE, and improve the device via the compare function. 
  - At last, users may apply the upload function to submit the device to the iGEM Registry and/or BASE database.

## Requirement

Our web pages are developed by [jQuery](http://jquery.com) and [Amaze UI](http://amazeui.org/?_ver=2.x).

We use [Perl](https://www.perl.org) as back-end and [MySQL](http://www.mysql.com) as the database.

## Usage

You can visit [BASE](http://www.igembase.com) to use our software.

#### Home

A brief introduction of our project.

#### Search

You can type the keywords you want to search into the input field. Of course, our back-end supports multi-keywords. What you have to do is just separating the words by '\*'. 
  - For example, Terminator\*RBS
  - You can choose either __part__ or __device__ type.
  - The button __Advanced__ will lead to making some advanced choices. Now you can change the weight of each dimension so that the back-end algorithm will pay more attention on the one with higher weight. In addition, modifying the number of rows which will be shown is permitted.
  - The results will be demonstrated as a table. Of course you will be informed of how many rows there are. There are four colors, blue implies high score and red implies the lower one. You can click the __Brick_id__ to redirect to the iGem official website so that you can get more information. The details of the score will be shown if you click __Score__ of a specific row.
  - Remember to click the __help__ button if you want more instructions.

#### Device Design

You can design your own bio-brick in this part of our software.

###### Construct

In this part, you can drag the __left icons__ to the blank and input functions you would like to realize. Our back-end algorithm will tell you which brick you should choose.
  - You can add no more than __32__ bricks.
  - The order of bricks is important. 
  - Click __Next-Compare__ to evaluation your device.
  - __Help__ button is always useful.

###### Evaluate

According to the brick id and functions, the back-end will automatically evaluate your device, tell you the score and the optimal one of each brick.
  - The text fields will be automatically filled with the brick id and functions in __Contruct__ part if you click the __Next-Evaluate__ button.
  - You can add and delete as many rows as you want.
  - Click __Upload__ button to upload your device after evaluation.

###### Upload

This is the last part of our design. After completing the required information of your device, you can upload it to our database and iGem official database soon.
  - Some text fields will be automatically filled with what you input in the former parts.

## File Structure

#### base_v6

Including four __.txt__ files and one __.sql__ file. They are the source file of the database.

#### front-end

The source files of our website. 

  - Device Design: source files of device design function, including three __.pl__ files which will be changed when installing.
  - Assets: The UI framework.
  - help: help documents
  - home: source files of homepage.
  - icon: icons of website.
  - iconpng: icons of website.
  - search: source files of search function, including one __.pl__ file which will be changed when installing.
  - mainCSS.css: __.css__ file.
  - mainJS.js: __.js__ file.

#### BASE \(Biobrick Auxiliary Selection Explorer\)

An instruction of our project.

#### Draft of science and Technology Museum poster

An instruction of our project.

#### README.md

A document for users.

## Install
You can just visit our website without any installation. But you are permitted to boot up a copy of your web server.

What you need is __Apache__, __MySQL__, __Perl__, __PHP__ and __this project__.

#### Apache

###### MacOS

Apache is installed and you don't have to download it from the Internet. Just open the __terminal__ and input ```$ sudo apachectl start``` command.

###### Windows

We recommend you to download [XAMPP(Apache+MySQL+PHP+PERL)](https://www.apachefriends.org/download.html) to configure the environment.

Notice that __win xp__ and __win 2003__ are not supported.

  - Open the control panel, find module __Apache__ and click start.
  - Click __Explorer__ button to the root directory of XAMPP. Move the project file into __htdocs__ directory.
  - Now, you can enjoy the service of apache.

###### Linux

We recommend you to download [XAMPP(Apache+MySQL+PHP+PERL)](https://www.apachefriends.org/download.html) to configure the environment.

  - Open the control panel, find tab __Manage Servers__, start the __Apache Web Server__.
  - Back to tab __Welcome__, click __Open Application Folder__ to the root directory of XAMPP. Move the project file into __htdocs__ directory.
  - Now, you can enjoy the service of apache.

#### MySQL

###### MacOS

MySQL is not included in the original operating system. You can download it from [MySQL Download](http://dev.mysql.com/downloads/mysql/). But it is not fast for most users in China. [MySQL SOHU Mirror](http://mirrors.sohu.com/mysql/MySQL-5.6/) will be a better choice.
  - Launch: You can easily control the status of MySQL in __perference__ after installation.
  - Move to the root directory of the project. Enter directory __base_v6__.
  - Login: Open terminal, type in ```$ mysql -u root -p```. At first the password is empty. You can change it by ```$ sudo /usr/local/mysql/bin/mysqladmin -u root password yourpassword``` command.
  - Remember to change your password in __Perl__ source file. We will remind you later.
  - Then type in ```MySQL> create database base;``` to create __base__ database.
  - Type in ```MySQL> use base;``` to use __base__.
  - Type in ```MySQL> source base_v6.sql;``` to update data in the database.
  - After that, all the data is stored in the database named __base__.

###### Windows

XAMPP will do most of the works. We suppose that you have installed the XAMPP.

  - Open the control panel, find module __MySQL__ and click start.
  - Click __Shell__ button on the right of the panel.
  - Move to the root directory of the project. Enter directory __base_v6__.
  - Type in ```# mysql -u root -p```. At first the password is empty, so click __Enter__ on the keyboard again to use MySQL. Of course, you can change your password by type in ```# mysqladmin -u root -p password yourpassword```.
  - Type in ```MySQL> create database base;``` to create __base__ database.
  - Type in ```MySQL> use base;``` to use __base__.
  - Type in ```MySQL> source base_v6.sql;``` to update data in the database.

###### Linux

XAMPP will do most of the works. We suppose that you have installed the XAMPP.

  - Open the control panel, click tab __Manage Server__ and start __MySQL Database__.
  - Open terminal, move to the root directory of the project. Enter directory __base_v6__.
  - Type in ```$ ../../../bin/mysql -u root -p``` to connect to MySQL. At first the password is empty, so click __Enter__ on the keyboard again to use MySQL. Of course, you can change your password by type in ```$ ../../../bin/mysqladimin -u root -p password yourpassword```.
  - Type in ```MySQL> create database base;``` to create __base__ database.
  - Type in ```MySQL> use base;``` to use __base__.
  - Type in ```MySQL> source base_v6.sql;``` to update data in the database.

#### Perl

###### MacOS

Perl is automatically installed in MacOS.
  - Type in ```perl xxx.pl arguments...``` to run the __xxx.pl__.
  - You should install [DBI](http://search.cpan.org/CPAN/authors/id/T/TI/TIMB/DBI-1.620.tar.gz ) and [DBD](http://search.cpan.org/CPAN/authors/id/C/CA/CAPTTOFU/DBD-mysql-4.021.tar.gz) to use MySQL in Perl scripts.
  - Open terminal, move to the root directory, type in ```$ perl makefile.pl```
  - Type in ```$ make test```
  - Type in ```$ make```
  - Type in ```$ make install``` or ```$ sudo make install``` if it isn't the root user.
  - After installation of these two plugins, you can use MySQL in Perl scripts.
  

###### Windows

XAMPP will do most of the works. We suppose that you have installed the XAMPP.

  - Click __Shell__ button on the right of the panel.
  - Type in ```perl xxx.pl arguments...``` to run the __xxx.pl__.
  - If the system tells you that your computer lacks __libmysql_.dll__, you should just download one from the Internet and drag it to __C:\Windows\system32__.

###### Linux

XAMPP will do most of the works. We suppose that you have installed the XAMPP.
  - Back to tab __Welcome__, click __Open Application Folder__ to the root directory of XAMPP.
  - Move to __bin__ directory, find __perl__ file and move to __/usr/bin__ and replace the original file. This means that once we type in ```perl xxx.pl arguments...``` in the terminal, we will use the Perl interpreter included in XAMPP instead of the original one.

#### PHP

###### MacOS

PHP is automatically installed in MacOS. 
  - Type in ```$ sudo open -e /etc/apache2/httpd.conf``` in __terminal__.
  - Find ```#LoadModule php5_module``` in this file and remove the \#.
  - Restart apache server. ```$ sudo apachectl restart```
  - Then put the directory of our project into ___/Library/WebServer/Documents___.
  - Open your browser, visit __http://localhost/iGem2015_SJTU_Software/search/search.html___ to use our website.

###### Windows

XAMPP will do all the works. You don't need to do anything.

###### Linux

XAMPP will do all the works. You don't need to do anything.

#### Project

Find ```my $password = "";``` in all the __.pl__ file. Change it to ```my $password = "xxx";``` where xxx is your password of username __root__ in MySQL.
  
