/*
  Peggy2.cpp - Peggy 2.0 LED Matrix library for Arduino
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
*/


extern "C" {
  #include <stdlib.h>
//  #include <string.h>
  #include <inttypes.h> 
  #include <avr/io.h>
}

//#include "WProgram.h"
#include "Peggy2.h" 
// Constructors ////////////////////////////////////////////////////////////////

Peggy2::Peggy2()
{
// buffer = (uint32_t*)calloc(25, sizeof(uint32_t));
 buffer = (uint32_t*)calloc(25, 4);
}






void Peggy2::Peggy_SPI_TX(char cData)
{
SPDR = cData;
//Wait for transmission complete:
while (!(SPSR & _BV(SPIF))) ;
}




void Peggy2::Peggy_HardwareInit()
{
 
  //  Hardware Initialization:
  
  PORTD = 0U;
  DDRD = 255U;
  
  ////SET MOSI, SCK Output, all other SPI as input: 
  DDRB |= _BV(5) | _BV(3) | _BV(2) | _BV(1);
  
  //ENABLE SPI, MASTER, CLOCK RATE fck/4:	 
  SPCR =  _BV(SPE) |  _BV(MSTR) ;
  
  //  Flush SPI LED drivers::
Peggy_SPI_TX(0);
Peggy_SPI_TX(0);
Peggy_SPI_TX(0);
Peggy_SPI_TX(0);

PORTB |= _BV(1);		//Latch Pulse 
  PORTB &= ~( _BV(1));
  
  
}



void Peggy2::Peggy_RefreshAll(unsigned int refreshNum)

{

unsigned int j,k;
unsigned char out1,out2,out3,out4;
unsigned long dtemp;  
k = 0;
while (k < refreshNum)		// k must be at least 1

{
k++;
j = 0;

while (j < 25) 
	{

	if (j == 0)
      PORTD = 160;
	else if (j < 16)
	  PORTD = j;
	else
	  PORTD = (j - 15) << 4;  
	  
	dtemp = buffer[j*sizeof(uint32_t)]; 
	
	out4 = dtemp & 255U;
	dtemp >>= 8;
	out3 = dtemp & 255U;
	dtemp >>= 8;
	out2 = dtemp & 255U;	 
	dtemp >>= 8;
	out1 = dtemp & 255U; 	

Peggy_SPI_TX(out1);
Peggy_SPI_TX(out2);
Peggy_SPI_TX(out3); 

PORTD = 0;  // Turn displays off

Peggy_SPI_TX(out4);

PORTB |= _BV(1);		//Latch Pulse 
PORTB &= ~( _BV(1));

j++;

	}
}

}


void Peggy2::Peggy_Clear() 
{
unsigned short j = 0;

while (j < 25) 
	{  
   buffer[j*sizeof(uint32_t)] = 0;
   j++;
	} 
}

// Turn point on or off logically
void Peggy2::Peggy_WritePoint(uint8_t xPos, uint8_t yPos, uint8_t Value)
{

if (Value)
	buffer[yPos*sizeof(uint32_t)] |= (uint32_t) 1 << xPos;
else
	buffer[yPos*sizeof(uint32_t)] &= ~((uint32_t) 1 << xPos);
}



// Turn a pixel on
void Peggy2::Peggy_SetPoint(uint8_t xPos, uint8_t yPos)
{
	buffer[yPos*sizeof(uint32_t)] |= (uint32_t) 1 << xPos; 
}


// Turn a pixel off
void Peggy2::Peggy_ClearPoint(uint8_t xPos, uint8_t yPos)
{
	buffer[yPos*sizeof(uint32_t)] &= ~((uint32_t) 1 << xPos);
}
