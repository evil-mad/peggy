/*
  peggySerialDraw.pde
 
 Example file using the Peggy2Serial library, for Peggy2 and Peggy2LE boards with 
 the hardware serial port modification.
 
 Overlays basic serial communication, to accept communication from the matching
 Processing sketch PeggyRemoteDraw.pde.
  
 To run this program:  First download this code onto Peggy2 as per usual,
 using the FTDI USB-TTL cable.  If it's working properly, you'll see one blinking 
 LED while it waits for a host computer to establish serial communication.  
  
 Next, open up the Processing sketch PeggyRemoteDraw.pde from within the 
 Processing environment.  With the USB-TTL cable still hooked up, press the 
 "Run" button at the upper left hand corner of the Processing window.
 
 When the Processing sketch runs, it will tell the Peggy 2  to draw colored dots
 at different locations.
 
 
 
 Version 1.0 - 12/26/2009
 Copyright (c) 2009 Windell H. Oskay.  All right reserved.
 http://www.evilmadscientist.com/
 
 This library is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 This library is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with this library.  If not, see <http://www.gnu.org/licenses/>.
 	  
 */



#include <Peggy2Serial.h>    // Required code, line 1 of 2.

byte inByte;
unsigned long time;
Peggy2 firstframe;     // Make a first frame buffer object, called firstframe

#define DrawPtTimeout 8192      



void WaitForContact() {
  firstframe.Clear();
     firstframe.SetPoint(12, 12); 
     
  while (Serial.available() <= 0) {



firstframe.RefreshAllSlow(50); //Draw frame buffer

    delay(150);

    if (Serial.available() > 0)
      break;
 
  }
  firstframe.Clear();
}


void getSerialChar(byte &theChar, byte &timedOut){ 
  if (timedOut == 0)
  {
    unsigned int i = 0;
    byte WaitForData = 1;  

    while (WaitForData)   // give up if we don't get data in a certain amount of time
    {
      if (Serial.available() > 0)
      {
        WaitForData = 0; 
        theChar = Serial.read();
      } 
      else if (++i > DrawPtTimeout)
      {
        WaitForData = 0;  
        timedOut = 1;
      }
    }   // end "while (WaitForData)" 
  }
  return; 
}


 

void setup()                    // run once, when the sketch starts
{
byte x,y;

   firstframe.HardwareInit();   // Call this once to init the hardware. 
                                // (Only needed once, even if you've got lots of frames.)
  Serial.begin(115200);
  WaitForContact();  // Establish contact until Processing responds 

firstframe.Clear();
firstframe.RefreshAll(1); //Draw frame buffer


}  // End setup()

void loop()                     // run over and over again
{   
  unsigned int i;
  byte inByte1, inByte2, inByte3;
  byte timeout, SyntaxOK;
  byte WaitForData;

  if (Serial.available() >= 4) {
    inByte = Serial.read();
  
 
  if (inByte == 'h')
  {
    Serial.print(255, BYTE);  //Reply to Hello signal
  }
  else if (inByte == 'd')
  {
    timeout = 0; 

    inByte1 = 255;
    inByte2 = 255;
    inByte3 = 255;

    getSerialChar(inByte1, timeout); 
    getSerialChar(inByte2, timeout); 
    getSerialChar(inByte3, timeout); 
    getSerialChar(inByte, timeout); 
         
    // Now check the 3 numbers for sanity:

    byte SyntaxOK = 1;
    if (inByte1 > 25)
      SyntaxOK = 0;
    if (inByte2 > 25)
      SyntaxOK = 0;      
    if (inByte3 > 2)
      SyntaxOK = 0;     
      
      
     if ( SyntaxOK == 0)
        Serial.print('B', BYTE);     // Report error
    else if (timeout)
            Serial.print('T', BYTE);     // Report error
    else if (inByte == 'D')
          {
            
            if (inByte3)  // i.e., if inByte3 > 0
             firstframe.SetPoint(inByte1, inByte2);
            else
             firstframe.ClearPoint(inByte1, inByte2);
             
          }
        
  }      // End " if (inByte == 'd')"
  else
  {
    // Command received but not understood-- send #2; indicating syntax error.
    Serial.print('X', BYTE);     
  }

  }  // End if (Serial.available() > 0)

 

      //  firstframe.RefreshAll(10); //Draw frame buffer
        firstframe.RefreshAllSlow(1); //Draw frame buffer      
}   // End loop()


 
