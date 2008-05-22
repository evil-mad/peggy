/*
  Peggy2.h - Peggy 2.0 LED Matrix library for Arduino
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


#ifndef Peggy2_h
#define Peggy2_h

#include <inttypes.h>
 

class Peggy2
{ 
  public:
    Peggy2(); 
	void Peggy_HardwareInit();
	void Peggy_RefreshAll(unsigned int refreshNum);
	void Peggy_Clear(void);
	void Peggy_WritePoint(uint8_t xPos, uint8_t yPos, uint8_t Value); 
	void Peggy_SetPoint(uint8_t xPos, uint8_t yPos);
	void Peggy_ClearPoint(uint8_t xPos, uint8_t yPos);
	//void Peggy_RefreshNextRow(unsigned int refreshNum); // Not yet written. ;)
	//uint8_t Peggy_GetPoint(uint8_t xPos, uint8_t yPos); // Not yet written. ;)
	
	uint32_t* buffer;
  private:
	void Peggy_SPI_TX(char);	
	 uint8_t _RowNum;
};


#endif

