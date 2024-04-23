## Working Demo

https://www.youtube.com/playlist?list=PLpHg9he5f4pJFb-dq5yv2FErB1TEemIFY

##
what we were supposed to do.
In ‘Dodge Through Bars,’ our project aims to develop an engaging arcade-style game using the Basys 3 FPGA board. 
Players can control a block character through a series of upcoming obstacles, represented as rectangle bars on the screen.
The objective is to avoid colliding with these bars while accumulating points to navigate the obstacles successfully.

<img src ='https://github.com/r-biswas/digitalSystem_project1/assets/125371277/bbea5f82-ba99-4212-b5b3-e398be41c377' width= '800px'>


While doing the project we started to connect a monitor(vga cable) with FPGA  board, one the first day we got
error that pixels of monitor did not match with our pixel size, later on we have resolved them with the help of TA.
After that we encountered a problem when all 4 obstacles were showing but 3 of the of them were of different pattern.
All the vidoes of this have been shared below via youtube playlist.


This problem got resolved but another one came that, all of the 4 obstacles were in the same line,
so we were not able to show all 4 on different vertical axes , just 2 days before it got resolved just by
adding another variable in the pixel generation and changing the dimensions.Below is the video of the obstacles before.

In the meanwhile we were able to make an obstacle which is green on the monitor,which moves vertically up and 
down with the help of Basys board buttons and the middle button we have used to reset the code and for that we
have used the debounce module because we are using buttons here. While making logic of collisions also we face difficulty
but at last, we wrote the logic of collision and hopefully it is working now also.

Finally we were able to make all the obstacles work randomly on the vertical axis, provided in the video, also we were able to 
play games with the help of fpga buttons,also when the collison happens game reset and the palyer is out, only the score is not counted properly rest everything is working fine.


Team Members Name: Raj Patel(22110214)
Team Members Name: Ranit biswas(22110217)
Team Members Name: Shreel Chawla(22110243)













