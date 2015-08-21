/* SlideShow
   Displays a series of pre-defined picdata for variable lengths of time
   Version 2: Modified to store picture data in program memory, not RAM
   
   Copyright (c) 2010 Mark Delp.  All right reserved.

   This example is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   This software is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with this software; if not, see http://www.gnu.org/licenses.
*/


#include <Peggy2.h>
#include <avr/pgmspace.h>

#define PICS    3                              // number of unique pictures
#define SLIDES  4                              // number of slides (each picture can be shown more than once)
#define FRAMES  4                              // number of frames per picture (1, 2, 3 or 4)
int slideorder[SLIDES] = { 0,  2,  1,  2};     // the slide numbers in order
int slidetime[SLIDES] = {200,100,200,100};     // length of time to show each slide
uint32_t picdata[PICS][FRAMES][25] PROGMEM = { // declare picture data (created using BMP2PEG)
 {{0x00000000, 0x000F0780, 0x00090C80, 0x0009E880, 0x000838F8, 0x00080008, 0x00880008, 0x0088C318, 0x00898190, 0x01EB00D0, 0x00C8E710, 0x00C8E710, 0x00D80010, 0x00F0001E, 0x00F0FF0E, 0x0010810B, 0x0010FF0B, 0x0010000B, 0x0010000B, 0x00100008, 0x001FFFF8, 0x0000AA00, 0x0007ABC0, 0x00042840, 0x0007EFC0},
  {0x00000000, 0x000F0780, 0x00090C80, 0x0009E880, 0x000838F8, 0x00080008, 0x00880008, 0x0088C318, 0x00898190, 0x01EB00D0, 0x00C8E710, 0x00C8E710, 0x00D80010, 0x00F0001E, 0x00F0FF0E, 0x0010810B, 0x0010FF0B, 0x0010000B, 0x0010000B, 0x00100008, 0x001FFFF8, 0x0000AA00, 0x0007ABC0, 0x00042840, 0x0007EFC0},
  {0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00800000, 0x0080C300, 0x00818180, 0x01E300C0, 0x00C0E700, 0x00C0E700, 0x00C00000, 0x00E00006, 0x00E0FF06, 0x00008103, 0x0000FF03, 0x00000003, 0x00000003, 0x00000000, 0x00000000, 0x0000AA00, 0x0007ABC0, 0x00042840, 0x0007EFC0},
  {0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00800000, 0x0080C300, 0x00818180, 0x01E300C0, 0x00C0E700, 0x00C0E700, 0x00C00000, 0x00E00006, 0x00E0FF06, 0x00008103, 0x0000FF03, 0x00000003, 0x00000003, 0x00000000, 0x00000000, 0x0000AA00, 0x0007ABC0, 0x00042840, 0x0007EFC0}}
,{{0x00000000, 0x0001F000, 0x00011000, 0x00011000, 0x00011FF8, 0x00810008, 0x00810008, 0x00810008, 0x01EF0008, 0x00C86068, 0x00C830C8, 0x00C81988, 0x00F8606E, 0x00F8606E, 0x0008606B, 0x0008000B, 0x00083FCB, 0x00082048, 0x00083FC8, 0x00080008, 0x000FFFF8, 0x0000AA00, 0x0007ABC0, 0x00042840, 0x0007EFC0},
  {0x00000000, 0x0001F000, 0x00011000, 0x00011000, 0x00011FF8, 0x00810008, 0x00810008, 0x00810008, 0x01EF0008, 0x00C86068, 0x00C830C8, 0x00C81988, 0x00F8606E, 0x00F8606E, 0x0008606B, 0x0008000B, 0x00083FCB, 0x00082048, 0x00083FC8, 0x00080008, 0x000FFFF8, 0x0000AA00, 0x0007ABC0, 0x00042840, 0x0007EFC0},
  {0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00800000, 0x00800000, 0x00800000, 0x01E00000, 0x00C06060, 0x00C030C0, 0x00C01980, 0x00F06066, 0x00F06066, 0x00006063, 0x00000003, 0x00003FC3, 0x00002040, 0x00003FC0, 0x00000000, 0x00000000, 0x0000AA00, 0x0007ABC0, 0x00042840, 0x0007EFC0},
  {0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00800000, 0x00800000, 0x00800000, 0x01E00000, 0x00C06060, 0x00C030C0, 0x00C01980, 0x00F06066, 0x00F06066, 0x00006063, 0x00000003, 0x00003FC3, 0x00002040, 0x00003FC0, 0x00000000, 0x00000000, 0x0000AA00, 0x0007ABC0, 0x00042840, 0x0007EFC0}}
,{{0x00000000, 0x00000000, 0x00EE1B86, 0x008A1204, 0x008A9324, 0x008A1204, 0x008E3B8E, 0x00000000, 0x00000000, 0x00000000, 0x003BAB48, 0x0028A958, 0x0039AB68, 0x0018A948, 0x002B9348, 0x00000000, 0x00000000, 0x00000000, 0x00EE6EEE, 0x00422AA2, 0x0046EEA6, 0x0042A6A2, 0x004EEAE2, 0x00000000, 0x00000000},
  {0x00000000, 0x00000000, 0x00EE1B86, 0x008A1204, 0x008A9324, 0x008A1204, 0x008E3B8E, 0x00000000, 0x00000000, 0x00000000, 0x003BAB48, 0x0028A958, 0x0039AB68, 0x0018A948, 0x002B9348, 0x00000000, 0x00000000, 0x00000000, 0x00EE6EEE, 0x00422AA2, 0x0046EEA6, 0x0042A6A2, 0x004EEAE2, 0x00000000, 0x00000000},
  {0x00000000, 0x00000000, 0x00EE1B86, 0x008A1204, 0x008A9324, 0x008A1204, 0x008E3B8E, 0x00000000, 0x00000000, 0x00000000, 0x003BAB48, 0x0028A958, 0x0039AB68, 0x0018A948, 0x002B9348, 0x00000000, 0x00000000, 0x00000000, 0x00EE6EEE, 0x00422AA2, 0x0046EEA6, 0x0042A6A2, 0x004EEAE2, 0x00000000, 0x00000000},
  {0x00000000, 0x00000000, 0x00EE1B86, 0x008A1204, 0x008A9324, 0x008A1204, 0x008E3B8E, 0x00000000, 0x00000000, 0x00000000, 0x003BAB48, 0x0028A958, 0x0039AB68, 0x0018A948, 0x002B9348, 0x00000000, 0x00000000, 0x00000000, 0x00EE6EEE, 0x00422AA2, 0x0046EEA6, 0x0042A6A2, 0x004EEAE2, 0x00000000, 0x00000000}}
};

Peggy2 buffers[FRAMES];           // declare frame buffers
int refreshcycles[4] = {1,2,4,8}; // declare number of refresh cycles for each frame


void setup()                      // run once, when the sketch starts
{
 buffers[0].HardwareInit();       // Call this once to init the hardware. 
                                  // (Only needed once, even if you've got lots of buffers.)
}


void loop()                       // run over and over again
{
 int slide;
 int frame;
 int row;
 int pause;
 
 // loop through each slide
 for (slide = 0; slide < SLIDES; slide++)
 {
  // load each row of picture data into frame buffers
  for (frame = 0; frame < FRAMES; frame++)
  {
   for (row = 0; row < 25; row++)
   {
    buffers[frame].WriteRow(row, pgm_read_dword(&(picdata[slideorder[slide]][frame][row])));
   }
  }
  // repeatedly show current picture for length of pause
  for (pause = 0; pause < slidetime[slide]; pause++)
  {
   // display each frame for appropriate number of cycles
   for (frame = 0; frame < FRAMES; frame++)
   {
     buffers[frame].RefreshAll(refreshcycles[frame]);
   }
  }
 }
}

