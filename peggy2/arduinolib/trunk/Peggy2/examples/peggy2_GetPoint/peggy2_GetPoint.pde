/* Simple example code for Peggy 2.0, using the Peggy2 library.

Initialize a single frame buffer array.  
Then, go through every point and flip it on to off, and vice versa.
Demonstrates the GetPoint routine.

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

Peggy2 firstframe;     // Make a first frame buffer object, called firstframe
   
unsigned short x = 0; 
unsigned short y = 0;    

void setup()                    // run once, when the sketch starts
{
     firstframe.HardwareInit();   // Call this once to init the hardware. 
                                        // (Only needed once, even if you've got lots of frames.)
      firstframe.Clear();
}  // End void setup()  






void loop()                     // run over and over again
{ 
  
  
y = 0;
while (y < 25) {
  
  x = 0;
  while (x < 25) {
  
    if (firstframe.GetPoint(x, y))
       firstframe.ClearPoint(x, y);
    else
       firstframe.SetPoint(x, y);
       
       firstframe.RefreshAll(1); //Draw frame buffer one time
       
  x++;
  }
 y++;
}
  
 // 
  
  
    


}
