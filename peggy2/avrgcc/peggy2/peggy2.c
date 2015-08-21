 /*
Title:		peggy2.c 
Date Created:   3/11/08
Last Modified:  3/11/08
Target:		Atmel ATmega168 
Environment:	AVR-GCC
Purpose: Drive 25x25 LED array uniformly



Written by Windell Oskay, http://www.evilmadscientist.com/

Copyright 2008 Windell H. Oskay
Distributed under the terms of the GNU General Public License, please see below.

Additional license terms may be available; please contact us for more information.



More information about this project is at 
http://www.evilmadscientist.com/article.php/peggy



-------------------------------------------------
USAGE: How to compile and install



A makefile is provided to compile and install this program using AVR-GCC and avrdude.

To use it, follow these steps:
1. Update the header of the makefile as needed to reflect the type of AVR programmer that you use.
2. Open a terminal window and move into the directory with this file and the makefile.  
3. At the terminal enter
		make clean   <return>
		make all     <return>
		make program <return>
4. Make sure that avrdude does not report any errors.  If all goes well, the last few lines output by avrdude
should look something like this:

avrdude: verifying ...
avrdude: XXXX bytes of flash verified

avrdude: safemode: lfuse reads as E2
avrdude: safemode: hfuse reads as D9
avrdude: safemode: efuse reads as FF
avrdude: safemode: Fuses OK

avrdude done.  Thank you.


If you a different programming environment, make sure that you copy over 
the fuse settings from the makefile.


-------------------------------------------------

This code should be relatively straightforward, so not much documentation is provided.  If you'd like to ask 
questions, suggest improvements, or report success, please use the evilmadscientist forum:
http://www.evilmadscientist.com/forum/

-------------------------------------------------


Revision hitory:

3/11/2008  Initial version
   Derived (partially) from peggy.c

-------------------------------------------------


 This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA


*/


 
#include <avr/io.h> 
#include <avr/interrupt.h>

 
volatile unsigned int mode; 
 

void SPI_TX (char cData)
{
//Start Transmission
SPDR = cData;
//Wait for transmission complete:
while (!(SPSR & _BV(SPIF)))
	;
	
}




SIGNAL(SIG_PIN_CHANGE0)
{ // Sleep with the "OFF" Button

mode++;  

//Note: Each button press+release will generate TWO interrupts
// So, to have the thing turn off after n cycles, you need to
// wait for mode == 2n.

if (mode == 4){
PORTD = 0;		

SPI_TX(0);
SPI_TX(0);
SPI_TX(0);
SPI_TX(0);

PORTB |= _BV(1);		//Latch Pulse 
PORTB &= ~( _BV(1));
 
SMCR = 5U; // Select power-down mode  
asm("sleep");		//Go to sleep!
}
}




void delayLong()
{
unsigned int delayvar;
	delayvar = 0; 
	while (delayvar <=  10U)		
		{ 
			asm("nop");  
			delayvar++;
		} 
}





int main (void)
{ 
asm("cli");		// DISABLE global interrupts

 
unsigned int j, k;		// General purpose indexing dummy variables
unsigned int countup;

unsigned char a,b,c,d;

//unsigned long d[26];
//unsigned long dtemp;

unsigned int f[25];
unsigned int g[25];

unsigned int eTemp;

unsigned short colnum;

mode = 0;

PORTD = 0U;
DDRD = 255U;
	

// General Hardware Initialization:

//MCUCR |= (1 << 4); // Disable pull-ups

PORTB = 1;
PORTC = 0;

DDRB = 254U;
DDRC = 255U;

countup = 0;

////SET MOSI, SCK Output, all other SPI as input:
DDRB = ( 1 << 3 ) | (1 << 5) | (1 << 2) | (1 << 1);

//ENABLE SPI, MASTER, CLOCK RATE fck/4:	
SPCR = (1 << SPE) | ( 1 << MSTR );

SPI_TX(0);
SPI_TX(0);
SPI_TX(0);
SPI_TX(0);

PORTB |= _BV(1);		//Latch Pulse 
PORTB &= ~( _BV(1));
 

countup = 0;

	j = 0;
	
	while (j < 25)
	{
	f[j]=65535U;		// Set up initial mode-- all LEDs on.
	g[j]=65535U;		// To display something else, *change* f[] and g[]!
	
	
		
			j++;
	}		
	
 
 
PCICR = 1; // Enable pin change interrupt on PCINT 0-7
PCMSK0 = 1; // Look only for change on pin B0, PCINT0.
asm("sei");		// ENABLE global interrupts
 
 
 



for (;;)  // main loop										
{
//PORTD = 255;


if (mode > 0) {
//Horizontal Sweeps (Low power mode)
countup++;
if (countup > 0)
{
countup = 0;

k = PORTD;
PORTD = 0;

colnum++;
if (colnum > 24)
	colnum = 0;

j = 0;
 

if (colnum < 25)	
{
	while (j < 25)
	{

if (colnum < 16){
	f[j]= 1 << colnum;
	g[j] = 0;}
else
	{
	g[j] = 1 << (colnum - 16);	 
	f[j] = 0;
	}
	j++;
	}	

}// end if (colnum < 25)	

PORTD = k; // Restore

} 
}



j = 0;

while (j < 25) 
	{
	
	 
			
a = g[j] >> 8;
b = g[j] & 255U;
c = f[j] >> 8;
d = f[j] & 255U;
			 
SPI_TX(a);
SPI_TX(b);
SPI_TX(c);
SPI_TX(d);
 

PORTD = 0;  // Turn displays off

PORTB |= _BV(1);		//Latch Pulse 
PORTB &= ~( _BV(1));

if (j < 15)
	PORTD =  j+1;
else
	PORTD = (j - 14) << 4; 
	
delayLong(); // Delay with new data

j++;
		
	}
	 
}	//End main loop.
	return 0;
}
