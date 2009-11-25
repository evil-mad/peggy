/* Simple example code for Peggy 2.0, using the Peggy2 library, version 0.2.

Generate four frame buffers and switch between them *fast* to make gray scale. 

This just demonstrates using the "regular" peggy 2 code on Peggy 2LE with the serial option:
Change the library line to read: #include <Peggy2Serial.h>

Copyright (c) 2008 Windell H Oskay.  All right reserved.

  This example is free software; you can redistribute it and/or
  modify it under the terms of the GNU Lesser General Public
  License as published by the Free Software Foundation; either
  version 2.1 of the License, or (at your option) any later version.

  This software is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public
  License along with this software; if not, write to the Free Software
  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
*/

 
#include <Peggy2Serial.h>

Peggy2 frame1;     // Make a frame buffer object, called frame1
Peggy2 frame2;     // Make a frame buffer object, called frame2
Peggy2 frame3;     // Make a frame buffer object, called frame3 
Peggy2 frame4;     // Make a frame buffer object, called frame4 

unsigned short color = 0; 
unsigned short repNumber = 5;  //Change scrolling rate-- number of reps at each position.


void setup()                    // run once, when the sketch starts
{
     frame1.HardwareInit();   // Call this once to init the hardware. 
                                        // (Only needed once, even if you've got lots of frames.)
}  // End void setup()  


void loop()                     // run over and over again
{ 
  

  unsigned short x = 0; 
unsigned short y = 0;     
unsigned long along, blong, clong, dlong, tlong;
unsigned short reps = 0;
 

while (y < 25) {
  
  x = 0;
  
  along = 0;
  blong = 0;
  clong = 0; 
  dlong = 0;
  
  tlong =  1;
  
  while (x < 25) {
   
if (color & 1)    
   along += tlong;
if (color & 2)    
   blong += tlong;
if (color & 4)    
   clong += tlong;
if (color & 8)    
   dlong += tlong;
   
  tlong <<= 1; 
  
color++;

if (color > 15)
    color = 0;

  x++;
  }
  
  frame1.WriteRow( y, along);
  frame2.WriteRow( y, blong);
  frame3.WriteRow( y, clong);  
  frame4.WriteRow( y, dlong);  
   
 y++;
}

while (reps < repNumber)
{

frame1.RefreshAll(1); //Draw frame buffer 1 time
frame2.RefreshAll(2); //Draw frame buffer 2 times
frame3.RefreshAll(4); //Draw frame buffer 4 times
frame4.RefreshAll(8); //Draw frame buffer 4 times

reps++;
}
  
}
