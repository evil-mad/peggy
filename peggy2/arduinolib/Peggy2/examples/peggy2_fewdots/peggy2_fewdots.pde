/* Simple example code for Peggy 2.0, using the Peggy2 library, version 0.2.

Initialize a single frame buffer array, draw a few dots, one at a time it with dots, and display it.

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

Peggy2 displayArea;     // Make a first frame buffer object, called displayArea
   
void setup()                    // run once, when the sketch starts
{
     displayArea.HardwareInit();   // Call this once to init the hardware. 
                                        // (Only needed once, even if you've got lots of frames.)
     
// Manually write sample pattern to buffer: turn on a few pixels, one by one:



displayArea.SetPoint(10, 8);
displayArea.SetPoint(10, 9);
displayArea.SetPoint(10, 10);

displayArea.SetPoint(15, 8);
displayArea.SetPoint(15, 9);
displayArea.SetPoint(15, 10);

displayArea.SetPoint(10, 15);
displayArea.SetPoint(11, 16);
displayArea.SetPoint(12, 16);
displayArea.SetPoint(13, 16);
displayArea.SetPoint(14, 16);
displayArea.SetPoint(15, 15);


}  // End void setup()  



void loop()                     // run over and over again
{ 
    
displayArea.RefreshAll(1); //Draw frame buffer one time

}
