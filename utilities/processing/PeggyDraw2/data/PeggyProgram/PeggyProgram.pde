/* Example code for Peggy 2.0, using the Peggy2 library
 
 Designed to be automatically generated!
 
 Copyright (c) 2011 Windell H Oskay.  All right reserved.
 
 This example wrapper is free software; you can redistribute it and/or
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
#include <avr/pgmspace.h>


Peggy2 frame;     // Make a frame buffer object, called frame 
unsigned long timeLast;
int frameNumber;
unsigned int ai;  // array Index
unsigned int frameDuration;

uint8_t salt = 0;
int8_t refreshSalt[] = {
  0,-1,2,0,1,-2};
  
unsigned int frames = 1;

prog_uint32_t datastore[] PROGMEM  = {
 0 , 0 , 0 , 0 , 0 , 0 , 76288 , 262144 , 1573120 , 0 , 
 1048704 , 65536 , 665600 , 131712 , 65664 , 82304 , 75264 , 0 , 40960 , 16384 , 
 65536 , 262144 , 524288 , 0 , 0
};
prog_uint16_t timestore[] PROGMEM  = {
100
};



void setup()                    // run once, when the sketch starts
{

//  Serial.begin(9600);    // For Optional time reporting

  frame.HardwareInit();   // Call this once to init the hardware. 
  // (Only needed once, even if you've got lots of frames.)

  timeLast = 0;
  frameNumber = -1;
  ai = 0;
  frameDuration = 0;
}
  
void loop()                     // run over and over again
{  

  if (( millis() -  timeLast) > frameDuration)
  {
    timeLast = timeLast + frameDuration ;
    frameNumber++;    // Go to next frame 

    if (frameNumber == frames)
    {
      frameNumber = 0;
      ai = 0;
    }
    frameDuration =  pgm_read_word(&timestore[frameNumber]); // Find new duration

    uint8_t y = 0;

    while (y < 25) {
      frame.WriteRow( y,  pgm_read_dword(&datastore[ai]));     
      y++;
      ai++;
    }

  }


//  unsigned long timetemp = millis();  // Optional time reporting

  frame.RefreshAll(12 + refreshSalt[salt]); //Draw frame buffer n times

//  Serial.println(millis() - timetemp); // Optional time reporting

  salt++;
  if (salt > 5)
    salt = 0; 

  //  Typical refresh timing:  100 cycles: 84 ms  
  //  Typical refresh timing:  23 cycles: 19-21 ms    
  //  Typical refresh timing:  20 cycles: 16-18 ms    
  //  Typical refresh timing:  12 cycles: 10 ms  

}
