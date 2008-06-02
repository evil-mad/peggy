/*
  Peggy2.cpp - Peggy 2.0 LED Matrix library for Arduino
    LIBRARY VERSION: 0.2b, DATED 5/30/2008

  
  
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
*/


extern "C" {
  #include <stdlib.h>
  #include <string.h>
  #include <inttypes.h> 
  #include <avr/io.h>
}

//#include "WProgram.h"
#include "Peggy2.h" 
// Constructors ////////////////////////////////////////////////////////////////
Peggy2::Peggy2()
{
  buffer = (uint32_t*)calloc(25, sizeof(uint32_t));
}



 
void Peggy2::SPI_TX(char cData)
{
  SPDR = cData;
  //Wait for transmission complete:
  while (!(SPSR & _BV(SPIF))) ;
} 


void Peggy2::HardwareInit()
{
  //  Hardware Initialization:
  
  PORTD = 0U;
  DDRD = 255U;
  
  ////SET MOSI, SCK Output, all other SPI as input: 
  DDRB |= _BV(5) | _BV(3) | _BV(2) | _BV(1);
  
  //ENABLE SPI, MASTER, CLOCK RATE fck/4:  
  SPCR =  _BV(SPE) |  _BV(MSTR) ;
  
  //  Flush SPI LED drivers::
  SPI_TX(0);
  SPI_TX(0);
  SPI_TX(0);
  SPI_TX(0);

  PORTB |= 2;    //Latch Pulse 
  PORTB &= 253;  
}


void delay()
{
unsigned int delayvar;
	delayvar = 0; 
	while (delayvar <=  6000U)		
		{ 
			asm("nop");  
			delayvar++;
		}
}


void Peggy2::RefreshAll(unsigned int refreshNum)
{
  unsigned int i,k;
  unsigned char j;
  
  union mix_t {
    unsigned long atemp; 
    unsigned char c[4];
  } mix;
  
  
  k = 0;
  
  while (k != refreshNum)   
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
      
	  i = 0;
	  while (i < 50)
	  {
	  asm("nop"); 
	  i++;
	  }
	  
  	  mix.atemp = buffer[j];
	  
      SPI_TX(mix.c[3]);
      SPI_TX(mix.c[2]);
      SPI_TX(mix.c[1]);
	  
      PORTD = 0;  // Turn displays off
 
      SPI_TX(mix.c[0]); 
      PORTB |= 2U;    //Latch Pulse 
      PORTB &= 253U;
      
      j++;
    }
  }
}



void Peggy2::RefreshAllFast(unsigned int refreshNum)
{
  unsigned int k;
  unsigned char j;
  
  union mix_t {
    unsigned long atemp; 
    unsigned char c[4];
  } mix;
  
  
  k = 0;
  
  while (k != refreshNum)   
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
      
	  
  	  mix.atemp = buffer[j];
	  
      SPI_TX(mix.c[3]);
      SPI_TX(mix.c[2]);
      SPI_TX(mix.c[1]);
	  
      PORTD = 0;  // Turn displays off
 
      SPI_TX(mix.c[0]); 
      PORTB |= 2U;    //Latch Pulse 
      PORTB &= 253U;
      
      j++;
    }
  }
}





void Peggy2::Clear() 
{
  memset(buffer, 0, 25*sizeof(uint32_t));
}


void Peggy2::WritePoint(uint8_t xPos, uint8_t yPos, uint8_t Value)
{
  if (Value)
    buffer[yPos] |= (uint32_t) 1 << xPos;
  else
    buffer[yPos] &= ~((uint32_t) 1 << xPos);
}

void Peggy2::WriteRow(uint8_t yPos, uint32_t row)
{
  buffer[yPos] = row;
}

void Peggy2::SetRow(uint8_t yPos, uint32_t row = PEGGY_ROW_ON)
{
  buffer[yPos] |= row;
}

// should ClearRow be implemented? if you only want to clear portions of the row, 
// you'd need to send masks. Might be overly complex to document.

// Turn a pixel on
void Peggy2::SetPoint(uint8_t xPos, uint8_t yPos)
{
  buffer[yPos] |= (uint32_t) 1 << xPos; 
}

// Turn a pixel off
void Peggy2::ClearPoint(uint8_t xPos, uint8_t yPos)
{
  buffer[yPos] &= ~((uint32_t) 1 << xPos);
}










