/* Simple example code for Peggy 2.0, using the Peggy2 library, version 0.2.

Generate static, like an unplugged analog TV.


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
#include <math.h>
#include <stdlib.h> 

Peggy2 frame1;     // Make a frame buffer object, called frame1
Peggy2 frame2;     // Make a frame buffer object, called frame2 
 

void setup()                    // run once, when the sketch starts
{
     frame1.HardwareInit();   // Call this once to init the hardware. 
                                        // (Only needed once, even if you've got lots of frames.)
}  // End void setup()  


void loop()                     // run over and over again
{ 
  
 
unsigned short y = 0;     
unsigned long along, blong, clong;
unsigned short reps = 0;
 

while (y < 25) {
   
  along = 	random();  // random(), defined in stdlib.h, produces a LONG integer.
  blong = 	random();
  
  clong = along & blong;
  
  frame1.WriteRow( y, blong);
  frame2.WriteRow( y, clong); 
   
 y++;
 
}

while (reps < (10 + (rand() & 32)))
{
  
frame1.RefreshAll(1); //Draw frame buffer 1 time
frame2.RefreshAll(2); //Draw frame buffer 2 times 

reps++;
}
  
}
