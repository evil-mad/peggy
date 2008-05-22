/* Simple example code for Peggy 2.0, using the Peggy2 library.

Generate four (very simple) frame buffers and switch between them to animate.


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


#include <Peggy2.h>

Peggy2 frame1;     // Make a frame buffer object, called frame1
Peggy2 frame2;     // Make a frame buffer object, called frame2
Peggy2 frame3;     // Make a frame buffer object, called frame3
Peggy2 frame4;     // Make a frame buffer object, called frame4
   
void setup()                    // run once, when the sketch starts
{
     frame1.Peggy_HardwareInit();   // Call this once to init the hardware. 
                                        // (Only needed once, even if you've got lots of frames.)
     
   
   
   frame1.Peggy_Clear();
   frame2.Peggy_Clear();
   frame3.Peggy_Clear();
   frame4.Peggy_Clear();
   
// Manually write sample patterns to buffers:

unsigned short x = 0; 
unsigned short y = 0;    

while (y < 25) {
  
  x = 0;
  while (x < 25) {
  
    
if (x < 8)    
  frame1.Peggy_SetPoint(x, y);
else if (x < 15)  
    frame2.Peggy_SetPoint(x, y);
else if (x < 20)  
    frame3.Peggy_SetPoint(x, y);
 else  
    frame4.Peggy_SetPoint(x, y);   
  x++;
  }
 y++;
}

  
}  // End void setup()  






void loop()                     // run over and over again
{ 
  // What we're doing here is just switching between frames-- can be used for real animation.
  
  
    
frame1.Peggy_RefreshAll(500); //Draw frame buffer 1
frame2.Peggy_RefreshAll(500); //Draw frame buffer 2
frame3.Peggy_RefreshAll(500); //Draw frame buffer 3
frame4.Peggy_RefreshAll(500); //Draw frame buffer 4
}
