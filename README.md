BASE
======

![image](https://github.com/igemsoftware/SJTU-Software2015/blob/master/icon/baselogoweb-color-03.png)

## Introduction

BASE is web-based tool for biobrick evaluation, helping researchers bulid new devices and systems.
  - The BASE web server is designed to provide a ranking to all existing biobricks and help users design their new devices.
  - Firstly, users can use the search function to find biobricks according to the score given by BASE and choose one they need.
  - Then users can make their own devices by using construction function. After constructing, users could upload the device to BASE, and improve the device via the compare function. 
  - At last, users may apply the upload function to submit the device to the iGEM Registry and/or BASE database.

## Requirement

Our web pages is developed by [jQuery](http://jquery.com) and [Amaze UI](http://amazeui.org/?_ver=2.x).

We use [Perl](https://www.perl.org) as back-end and [MySQL](http://www.mysql.com) as the database.

## Usage

You can visit [BASE](http://www.igembase.com) to use our software.

#### Home

A brief introduction of our project.

#### Search

You can type in the keywords you want to search into the input field. Of course, our back-end supports multi-keywords. What you have to do is just seperating the words by '\*'. 
  - For example, Terminator\*RBS
  - You can choose either __part__ or __device__ type.
  - The button __Advanced__ will lead to make some advanced choices. Now you can change the weight of each dimension so that the back-end algorithm will pay more attention on the one with higher weight. In addition, modifying the number of rows which will be shown is permitted.
  - The results will be demostrated as a table. Of course you will be informed of how many rows there are. There are four colors, blue implies high score and red implies the lower one. You can click the __Brick_id__ to redirect to the iGem official website so that you can get more information. The details of score will be shown if you click __Score__ of a specific row.
  - Remember to click the __help__ button if you want more instructions.

#### Device Design

You can design your own bio-brick in this part of our software.

###### Construct

In this part, you can drag the __left icons__ to the blank and input functions you would like to realize. Our back-end algorithm will tell you which brick you should choose.
  - You can add no more than __32__ bricks.
  - The sequence of bricks is important. 
  - Click __Next-Compare__ to evaluation your device.
  - __Help__ button is always useful.

###### Evaluate

According to the brick id and functions, the back-end will automaticlly evaluate your device, tell you the score and the optimal one of each brick.
  - The text fields will be automaticlly filled with the brick id and functions in __Contruct__ part if you click the __Next-Compre__ button.
  - You can add and delete as many rows as you want.
  - Click __Upload__ button to upload your device after evaluation.

###### Upload

This is the last part of our design. After completing the required information of your device, you can upload it to our database and iGem official database soon.
  - Some text fields will be automaticlly filled with what you input in the former parts.

## Install
You can just visit our website without any installation. But you are permitted to boot up a copy of your web server.

What you need is __Apache__, __MySQL__, __Perl__, __PHP__ and __this project__.

#### Apache

###### MacOS

Apache is installed and you don't have to download it from the Internet. Just open the __terminal__ and input ```$ sudo apachectl start``` command.

###### Other OS

We recommand you to download [XAMPP(Apache+MySQL+PHP+PERL)](https://www.apachefriends.org/download.html) to configure the environment.

#### MySQL

###### MacOS

MySQL is not included in the original operating system. We can download it from [MySQL Download](http://dev.mysql.com/downloads/mysql/). But it is not fast for most chinese users. [MySQL SOHU Mirror](http://mirrors.sohu.com/mysql/MySQL-5.6/) will be a better choice.
  - Luanch: You can easily control the status of MySQL in __perference__ after installation.
  - Login: Open terminal, type in ```$ mysql -u root -p```. At first the password is empty. You can change it by ```$ sudo /usr/local/mysql/bin/mysqladmin -u root password yourpassword``` command.
  - Remember to change your password in __Perl__ source file. I will remind you later.
  - Then type in ```MySQL> create database base;``` to create __base__ database.
  - Type in ```MySQL> source xxx;``` to update data in the database. __xxx__ is the route of the __base_v6.sql__ file in our project.
  - After that, all the data is stored in the database named __base__.

###### Other OS

XAMPP will do most of works.

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
  

###### Other OS

XAMPP will do most of works.

#### PHP

###### MacOS

PHP is automatically installed in MacOS. 
  - Type in ```$ sudo open -e /etc/apache2/httpd.conf``` in __terminal__.
  - Find ```#LoadModule php5_module``` in this file and remove the \#.
  - Restart apache server. ```$ sudo apachectl restart```
  - Then put the directory of our project into ___/Library/WebServer/Documents___.
  - Open your browser, visit __http://localhost/iGem2015_SJTU_Software/search/search.html___ to use our website.

###### Other OS

XAMPP will do most of works.

#### Project

Find ```my $password = "superjjj2486";``` in all the __.pl__ file. Change it to ```my $password = "xxx";``` where xxx is your password of username __root__ in MySQL.
  