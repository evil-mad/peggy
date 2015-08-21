/*
  Peggy2Serial.h - Peggy 2.0 LED Matrix library for Arduino
  LIBRARY VERSION: 0.40b, DATED 11/25/2009
  
  For Peggy 2le with serial option...
  
  Copyright (c) 2008 Windell H Oskay.  All right reserved.

  This library is free software; you can redistribute it and/or
  modify it under the terms of the GNU Lesser General Public
  License as published by the Free Software Foundation; either
  version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public
  License along with this library; if not, write to the Free Software
  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA

  Modifications by Michael Yin, Copyright (c) 2008. All rights reserved.
  
  Line drawing code by Michaël Zancan & Julien 'v3ga' Gachadoat, Websites:
	http://www.2roqs.com
	http://www.zancan.fr
	http://www.v3ga.net

*/


#ifndef Peggy2Serial_h
#define Peggy2Serial_h

#include <inttypes.h>
 
// some constants
// 2^25-1 (25 bits on)
#define PEGGY_ROW_ON 33554431 
#define PEGGY_ROW_OFF 0
#define Peggy2 Peggy2Serial

class Peggy2
{ 
  public:
    Peggy2Serial(); 
    
    // Onetime hardware initialization, don't need to run it for every frame.
    void HardwareInit();

    // Refresh this frame, refreshNum is how long to wait on each line; normally 
	// use a refresh value of 1-10.
    void RefreshAll(unsigned int refreshNum);
	
	
	// Refresh this frame, refreshNum is the number of times this frame
    // will be refreshed in this call.
	// Uses a fast scan rate, but may possibly cause ghosting or other unforseen effects.
    void RefreshAllFast(unsigned int refreshNum);
	
	// Refresh this frame, refreshNum is the number of times this frame
    // will be refreshed in this call.
	// Uses a slower, "ghostbusting" scan rate, for improved uniformity.
    void RefreshAllSlow(unsigned int refreshNum);
	 
    // Clears out the FrameBuffer (all LEDs set to OFF)
    void Clear(void);

    // Turn point on or off logically 
    // You can send true or false
    // or non-zero and zero
    void WritePoint(uint8_t xPos, uint8_t yPos, uint8_t Value); 

    // Write over the entire row, each bit from position 0,24 represents
    // the LED position in the row.
    // example: WriteRow(0, 32); 
    // would set the 6th LED on the top row (5th position)
    // 1 0 0 0 0 0  <- bit representation of 32
    // 5 4 3 2 1 0  <- power of 2
    // This function is a bit more complex to understand and is useful only 
    // if you think you can set the bits faster than WritePoint would.
    void WriteRow(uint8_t yPos, uint32_t row);

    // Turn a pixel on
    void SetPoint(uint8_t xPos, uint8_t yPos);

    // Same as WriteRow except it will only turn on bits that are 1, instead 
    // of just writing over all bits. This is useful if you want to add new 
    // lights to your frame buffer while keeping previous lights on. 
    // By default, SetRow(yPos) will set the entire row on.
    void SetRow(uint8_t yPos, uint32_t row);

    // Turn a pixel off
    void ClearPoint(uint8_t xPos, uint8_t yPos);

	// Determine if a pixel is on or off
	uint8_t GetPoint(uint8_t xPos, uint8_t yPos); 
		
	//Draw a line from (x1,y1) to (x2,y2)
	void Line(int8_t x1, int8_t y1, int8_t x2, int8_t y2);

	//Set current cursor position to (xPos,yPos)
	void MoveTo(int8_t xPos, int8_t yPos);
	
	//Draw a line from current cursor position to (xPos,yPos)
	void LineTo(int8_t xPos, int8_t yPos);
	 
    
    uint32_t* buffer;
  private:
    void SPI_TX(char);   
    uint8_t _Xcursor;
	uint8_t _Ycursor;
};


#endif

