/* Simple example code for Peggy 2.0, using the Peggy2 library, version 0.2.
 
This example lights only ONE pixel at a time.  
No multiplexing, very bright.


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

Peggy2 displayArea;     // Make a first frame buffer object, called displayArea

void setup()                    // run once, when the sketch starts
{
  displayArea.HardwareInit();   // Call this once to init the hardware. 
  // (Only needed once, even if you've got lots of frames.)
 
}  // End void setup()  

 
 
 
void SPI_TX(char cData)
{
  SPDR = cData;
  //Wait for transmission complete:
  while (!(SPSR & _BV(SPIF))) ;
} 


void DrawOneDot(byte x, byte y, byte value){
byte pc, pd;

byte j = y + 1;
 
union mix_t {
    unsigned long atemp; 
    unsigned char c[4];
  } mix;

		if (j < 16){
			pd = j;
			pc = ((pd & 3) << 4) | (PORTC & 15);
			pd = pd & 252; 
		}
		else{
			pd = (j - 15) << 4;  
			pc  = PORTC & 15; 
		}

if (value)
  mix.atemp = (uint32_t) 1 << x;
  else
    mix.atemp = 0;
    
    	
        PORTC = PORTC & 15;
        PORTD = 0;  // Turn row off once columns are off.


	        SPI_TX(mix.c[3]);
		SPI_TX(mix.c[2]);
		SPI_TX(mix.c[1]);
		SPI_TX(mix.c[0]); 

		PORTB |= 2U;    //Latch Pulse turns on columns
		PORTB &= 253U;	// End latch pulse

		PORTD = pd;		// Turn row on
		PORTC = pc;		// (Continued...)
		 

}
 
 
 
void loop()                     // run over and over again
{ 
  byte i,j;

  i = 0;
  while (i < 25)
  {
    j = 0;
    while (j < 25)
    {
      
      DrawOneDot(j, i, 1);
      delay(20);

     // displayArea.SetPoint(j, i);    
     // displayArea.RefreshAll(50); //Draw frame buffer 50 times 
     // displayArea.ClearPoint(j, i);

      j++; 
    }

    i++;
  }

}
