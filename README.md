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

### Home

A brief introduction of our project.

### Search

You can type in the keywords you want to search into the input field. Of course, our back-end supports multi-keywords. What you have to do is just seperating the words by '\*'. 
  - For example, Terminator\*RBS
  - You can choose either __part__ or __device__ type.
  - The button __Advanced__ will lead to make some advanced choices. Now you can change the weight of each dimension so that the back-end algorithm will pay more attention on the one with higher weight. In addition, modifying the number of rows which will be shown is permitted.
  - The results will be demostrated as a table. Of course you will be informed of how many rows there are. You can click the __Brick_id__ to redirect to the iGem official website so that you can get more information. The details of score will be shown if you click __Score__ of a specific row.
  - Remember to click the __help__ button if you want more instructions.

### Device Design

You can design your own bio-brick in this part of our software.

#### Construct

In this part, you can drag the __left icons__ to the blank and input functions you would like to realize. Our back-end algorithm will tell you which brick you should choose.
  - You can add no more than __32__ bricks.
  - The sequence of bricks is important. 
  - Click __Next-Compare__ to evaluation your device.
  - __Help__ button is always useful.

#### Evaluate

According to the brick id and functions, the back-end will automaticlly evaluate your device, tell you the score and the optimal one of each brick.
  - The text fields will be automaticlly filled with the brick id and functions in __Contruct__ part if you click the __Next-Compre__ button.
  - You can add and delete as many rows as you want.
  - Click __Upload__ button to upload your device after evaluation.

#### Upload


