/* Demo code for Peggy 2.0, using the Peggy2 library.

Demonstrate very simple "live" animation using independent frame buffers.


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
Peggy2 secondframe;    // Make another frame buffer object, called secondframe
   
  
unsigned int m = 0;
unsigned int n = 0;
unsigned int p = 0;

unsigned char row, col;

void setup()                    // run once, when the sketch starts
{
     firstframe.Peggy_HardwareInit();   // Call this once to init the hardware. 
                                        // (Only needed once, even if you've got lots of frames.)
     
     
/*

// Manually write sample patterns to buffers, just for fun.
unsigned short j = 0;
while (j < 25) 
	{  
   firstframe.buffer[j*sizeof(uint32_t)] = ( (uint32_t) j << 8) | ( (uint32_t) j << 16);
   j++;
	} 
     
    j = 0;

while (j < 25) 
	{  
   secondframe.buffer[j*sizeof(uint32_t)] = ( (uint32_t) 1 << j);
   j++;
	} 

*/


firstframe.Peggy_Clear(); // Erase the entire frame buffer-- undo writing any patterns.
secondframe.Peggy_Clear(); // Erase the entire frame buffer-- undo writing any patterns.

}







void loop()                     // run over and over again
{ 
  
    
firstframe.Peggy_RefreshAll(8); //Draw eight times

  
//  Draw dots at corners:
    secondframe.Peggy_SetPoint(0,0);
    secondframe.Peggy_SetPoint(24,0);
    secondframe.Peggy_SetPoint(0,24); 
    secondframe.Peggy_SetPoint(24,24); 
    secondframe.Peggy_SetPoint(23,24); 
    
     secondframe.Peggy_ClearPoint(23,24);    // "oops bad point" -- erase it.
  

secondframe.Peggy_RefreshAll(1); // Draw 8 times -- less intense signal for the corner dots   

row = 0; 

while (m > (24 + 25*row))
  row++;

col = m - (25*row);

n++;

if (n > p)
{
n = 0;
firstframe.Peggy_SetPoint(col,row);
} 

m++;

if (m > 624){
   m = 0;
   n = 0;
   
   p++;
   
   if (p > 75)
     p = 1;
   
   
   firstframe.Peggy_Clear(); // Erase the entire frame buffer
}



}
