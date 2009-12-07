/*
*
* Copyright 2009 Windell H. Oskay.  All rights reserved.
*
*    This program is free software: you can redistribute it and/or modify
*    it under the terms of the GNU General Public License as published by
*    the Free Software Foundation, either version 3 of the License, or
*    (at your option) any later version.
*
*    This program is distributed in the hope that it will be useful,
*    but WITHOUT ANY WARRANTY; without even the implied warranty of
*    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*    GNU General Public License for more details.
*
*    You should have received a copy of the GNU General Public License
*    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

/*
 

Credit: This program was written by Jay Clegg and released by him under
the GPL.  I've copied it to Arduino format.

Please see http://planetclegg.com/projects/QC-Peggy.html
 

*/
#include <avr/io.h> 
#include <avr/interrupt.h> 
#include <avr/sleep.h> 
#include <avr/pgmspace.h> 
#include <stdio.h>

////////////////////////////////////////////////////////////////////////////////////////////
// FPS must be high enough to not have obvious flicker, low enough that serial loop has 
// time to process one byte per pass.
// 75-78 seems to be about the absolute max for me (with this code), 
// but compiler differences might make this maximum value larger or smaller. 
// any lower than 60 and flicker becomes apparent.  
// note: further code optimization might allow this number to
// be a bit higher, but only up to a point...  
// it *must* result in a value for OCR0A  in the range of 1-255

#define FPS 70


// 25 rows * 13 bytes per row == 325
#define DISP_BUFFER_SIZE 325
#define MAX_BRIGHTNESS 15

////////////////////////////////////////////////////////////////////////////////////////////

void displayInit(void) 
{

	// set outputs to 0
	PORTC = 0;
	// leave serial pins alone
	PORTD &=  (1<<1) | (1<<0);
	
	// need to set output for SPI clock, MOSI, SS and latch.  Eventhough SS is not connected,
	// it must apparently be set as output for hardware SPI to work.
	DDRB =  (1<<DDB5) | (1<<DDB3) | (1<<DDB2) | (1<<DDB1);
	// SCL/SDA pins set as output
	DDRC =  (1<<DDC5) | (1<<DDC4); 
	// set portd pins as output, but leave RX/TX alone
	DDRD |= (1<<DDD7) | (1<<DDD6) | (1<<DDD5) |(1<<DDD4) | (1<<DDD3) | (1<<DDD2);
	
	// enable hardware SPI, set as master and clock rate of fck/2
	SPCR = (1<<SPE) | (1<<MSTR);
	SPSR = (1<<SPI2X); 

	// setup the interrupt.

	TCCR0A = (1<<WGM01); // clear timer on compare match

	TCCR0B = (1<<CS01); // timer uses main system clock with 1/8 prescale

	OCR0A  = (F_CPU >> 3) / 25 / 15 / FPS; // Frames per second * 15 passes for brightness * 25 rows
	TIMSK0 = (1<<OCIE0A);	// call interrupt on output compare match

	// set to row 0, all pixels off
	//setCurrentRow(0,0,0,0,0);
}


void setCurrentRow(uint8_t row, uint8_t spi1, uint8_t spi2, uint8_t spi3, uint8_t spi4)
{
	uint8_t portD;
	uint8_t portC;

	// precalculate the port values to set the row.
	if (row < 15)
	{
		row ++;
		portC = ((row & 3) << 4);
		portD = (row & (~3));
	}
	else
	{
		row = (row - 14) << 4;
		portC = ((row & 3) << 4);
		portD = (row & (~3));
	}

	// set all rows to off
	PORTD = 0;
	PORTC = 0; 

	// set row values.  Wait for xmit to finish.
	// Note: wasted cycles here, not sure what I could do with them,
	// but it seems a shame to waste 'em.
	SPDR = spi1;
	while (!(SPSR & (1<<SPIF)))  { }
	SPDR = spi2;
	while (!(SPSR & (1<<SPIF)))  { }
	SPDR = spi3;
	while (!(SPSR & (1<<SPIF)))  { }
	SPDR = spi4;
	while (!(SPSR & (1<<SPIF)))  { }

	// Now that the 74HC154 pins are split to two different ports,
	// we want to flip them as quickly as possible.  This is why the
	// port values are pre-calculated


	
	PORTB |= (1<<1); 

	PORTD = portD;
	PORTC = portC;
	
	
	PORTB &= ~((1<<1)); 
}



uint8_t frameBuffer[DISP_BUFFER_SIZE];
uint8_t * rowPtr;
uint8_t currentRow=26;
uint8_t currentBrightness=20;
uint8_t currentBrightnessShifted=20;


SIGNAL(TIMER0_COMPA_vect)
{	

	
	// there are 15 passes through this interrupt for each row per frame.
	// ( 15 * 25) = 375 times per frame.
	// during those 15 passes, a led can be on or off.
	// if it is off the entire time, the perceived brightness is 0/15
	// if it is on the entire time, the perceived brightness is 15/15
	// giving a total of 16 average brightness levels from fully on to fully off.
	// currentBrightness is a comparison variable, used to determine if a certain
	// pixel is on or off during one of those 15 cycles.   currentBrightnessShifted
	// is the same value left shifted 4 bits:  This is just an optimization for
	// comparing the high-order bytes.
	
	currentBrightnessShifted+=16; // equal to currentBrightness << 4
	
	if (++currentBrightness >= MAX_BRIGHTNESS)  
	{
		currentBrightnessShifted=0;
		currentBrightness=0;
		if (++currentRow > 24)
		{
			currentRow =0;
			rowPtr = frameBuffer;
		}
		else
		{
			rowPtr += 13;
		}
	}
	
	// rather than shifting in a loop I manually unrolled this operation
	// because I couldnt seem to coax gcc to do the unrolling it for me.
	// (if much more time is taken up in this interrupt, the serial service routine
	// will start to miss bytes)
	// This code could be optimized considerably further...
	
	uint8_t * ptr = rowPtr;
	uint8_t p, a,b,c,d;
	
	a=b=c=d=0;
	
	// pixel order is, from left to right on the display:
	//  low order bits, followed by high order bits
	p = *ptr++;
	if ((p & 0x0f) > currentBrightness)  		a|=1;
	if ((p & 0xf0) > currentBrightnessShifted)	a|=2;
	p = *ptr++;
	if ((p & 0x0f) > currentBrightness)  		a|=4;
	if ((p & 0xf0) > currentBrightnessShifted)	a|=8;
	p = *ptr++;
	if ((p & 0x0f) > currentBrightness)  		a|=16;
	if ((p & 0xf0) > currentBrightnessShifted)	a|=32;
	p = *ptr++;
	if ((p & 0x0f) > currentBrightness)  		a|=64;
	if ((p & 0xf0) > currentBrightnessShifted)	a|=128;
	p = *ptr++;
	if ((p & 0x0f) > currentBrightness)  		b|=1;
	if ((p & 0xf0) > currentBrightnessShifted)	b|=2;
	p = *ptr++;
	if ((p & 0x0f) > currentBrightness)  		b|=4;
	if ((p & 0xf0) > currentBrightnessShifted)	b|=8;
	p = *ptr++;
	if ((p & 0x0f) > currentBrightness)  		b|=16;
	if ((p & 0xf0) > currentBrightnessShifted)	b|=32;
	p = *ptr++;
	if ((p & 0x0f) > currentBrightness)  		b|=64;
	if ((p & 0xf0) > currentBrightnessShifted)	b|=128;
	p = *ptr++;
	if ((p & 0x0f) > currentBrightness)  		c|=1;
	if ((p & 0xf0) > currentBrightnessShifted)	c|=2;
	p = *ptr++;
	if ((p & 0x0f) > currentBrightness)  		c|=4;
	if ((p & 0xf0) > currentBrightnessShifted)	c|=8;
	p = *ptr++;
	if ((p & 0x0f) > currentBrightness)  		c|=16;
	if ((p & 0xf0) > currentBrightnessShifted)	c|=32;
	p = *ptr++;
	if ((p & 0x0f) > currentBrightness)  		c|=64;
	if ((p & 0xf0) > currentBrightnessShifted)	c|=128;
	p = *ptr++;
	if ((p & 0x0f) > currentBrightness)  		d|=1;
	//if ((p & 0xf0) > currentBrightnessShifted)  d|=2;
	
	setCurrentRow(currentRow, d,c,b,a);
}

////////////////////////////////////////////////////////////////////////////////////////////
// Serial IO routines
////////////////////////////////////////////////////////////////////////////////////////////


// must be 1 or zero. U2X gets set to this.

#define USART_DOUBLESPEED   1 
#define _USART_MULT  (USART_DOUBLESPEED ? 8L : 16L )

#define CALC_UBBR(baudRate, xtalFreq) (  (xtalFreq / (baudRate * _USART_MULT))  - 1 )



void uartInit(unsigned int ubbrValue)

{

	// set baud rate	
	UBRR0H = (unsigned char)(ubbrValue>>8);

    UBRR0L = (unsigned char)ubbrValue;

	// Enable 2x speed

	if (USART_DOUBLESPEED )

		UCSR0A = (1<<U2X0);



	// Async. mode, 8N1

    UCSR0C = /* (1<<URSEL0)| */(0<<UMSEL00)|(0<<UPM00)|(0<<USBS0)|(3<<UCSZ00)|(0<<UCPOL0);



 	UCSR0B = (1<<RXEN0)|(1<<TXEN0)|(0<<RXCIE0)|(0<<UDRIE0);


	//sei();

}



// send a byte thru the USART

void uartTx(char data)

{

	// wait for port to get free

	while (!(UCSR0A & (1<<UDRE0))) { }

    UDR0 = data;

}





// get one byte from usart (will wait until a byte is in buffer)

uint8_t uartRxGetByte(void)

{

    while (!(UCSR0A & (1<<RXC0))) { } // wait for char

    return UDR0;

}



// check to see if byte is ready to be read with uartRx

uint8_t uartRxHasChar(void)

{
	return  (UCSR0A & (1<<RXC0)) ? 1 : 0;
}


////////////////////////////////////////////////////////////////////////////////////////////
// MAIN LOOP: service the serial port and stuff bytes into the framebuffer
////////////////////////////////////////////////////////////////////////////////////////////

void serviceSerial(void)
{
	uint8_t *ptr = frameBuffer;
	int state = 0; 
	int counter = 0;
	while (1)
	{   
		uint8_t c = uartRxGetByte();
		
		// very simple state machine to look for 6 byte start of frame
		// marker and copy bytes that follow into buffer
		if (state < 6) 
		{

			// must wait for 0xdeadbeef to start frame.
			// note, I look for two more bytes after that, but
			// they are reserved for future use. 

			if (state == 0 && c == 0xde) state++;
			else if (state ==1 && c == 0xad) state++;
			else if (state ==2 && c == 0xbe) state++;
			else if (state ==3 && c == 0xef) state++;
			else if (state ==4 && c == 0x01) state++;
			else if (state ==5)  // dont care what 6th byte is 
			{
				state++;
				counter = 0;
				ptr = frameBuffer;
			}
			else state = 0; // error: reset to look for start of frame
		}
		else 
		{
			// inside of a frame, so save each byte to buffer
			*ptr++ = c;
			counter++;
			if (counter >= DISP_BUFFER_SIZE)
			{
				// buffer filled, so reset everything to wait for next frame
				//counter = 0;
				//ptr = frameBuffer;
				state = 0;
			}
		}
	}
}

void setup()                    // run once, when the sketch starts
{
	// Enable pullups for buttons
	PORTB |= (1<<0); 
	PORTC |= (1<<3) | (1<<2) | (1<<1) | (1<<0);
	
	uartInit(CALC_UBBR(115200, F_CPU));

	displayInit(); 
	
 	sei( );

	// clear display and set to test pattern
	// pattern should look just like the "gray test pattern"
	//  from EMS
	int i = 0;
	uint8_t v = 0;
	uint8_t *ptr = frameBuffer;

	for (i =0; i < DISP_BUFFER_SIZE; i++)
	{
		v = (v+2) % 16;
	    // set to 0 for blank startup display
		// low order bits on the left, high order bits on the right
			*ptr++ = v + ((v+1)<<4);  
		//	 *ptr++=0;
	}
	
	serviceSerial();  // never returns


}


void loop()                     // run over and over again
{



}
