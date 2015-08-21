// Peggy2 (Serial Mod)
// Row & Column sweep test
/*
Copyright (c) 2009 Windell H Oskay.  All right reserved.

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
  
//#include <Peggy2.h>
#include <Peggy2Serial.h>


Peggy2 firstframe;     // Make a first frame buffer object, called firstframe
byte x,y;

void setup()                    // run once, when the sketch starts
{
     firstframe.HardwareInit();   // Call this once to init the hardware. 
                                        // (Only needed once, even if you've got lots of frames.)
     
     asm("cli");	// Optional: Disable global interrupts for a smoother display
     
     
     y = 0;
     
     while (y < 25) {
  
  x = 0;
  while (x < 25) {
  
  firstframe.SetPoint(x, y);

  x++;
  }
 y++;
}

}



void loop()                     // run over and over again
{ 
    


  
  y = 0;   
     while (y < 25) {
       
  firstframe.Clear();
  
  x = 0;
  while (x < 25) {
  
  firstframe.SetPoint(x, y);

  x++;
  }
  
  firstframe.RefreshAll(50); //Draw frame buffer
//  firstframe.RefreshAllSlow(10); //Draw frame buffer with slow routine
  
 y++;
  
}


  y = 0;   
     while (y < 25) {
       
  firstframe.Clear();
  
  x = 0;
  while (x < 25) {
  
  firstframe.SetPoint(y, x);

  x++;
  }
  
  firstframe.RefreshAll(50); //Draw frame buffer
//  firstframe.RefreshAllSlow(10); //Draw frame buffer with slow routine
 y++;
  
}


 




} // end loop
