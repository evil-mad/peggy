/*

+ MoveToLineTo - Demo easy drawing routines

+ Credits :  
   - Line code by Micha�l Zancan & Julien 'v3ga' Gachadoat

Slightly modified by Windell H. Oskay, 6/8/2008.

*/

// ------------------------------------------------------------
// inclusion
// ------------------------------------------------------------
#include <Peggy2Serial.h>

// ------------------------------------------------------------
// Globals
// ------------------------------------------------------------
Peggy2 frame1; 

// ------------------------------------------------------------
// setup
// ------------------------------------------------------------
void setup()
{
  frame1.HardwareInit(); 
}

// ------------------------------------------------------------
// setup
// ------------------------------------------------------------
void loop()
{
  uint8_t j = 0;
  
   frame1.Clear();
  
  frame1.MoveTo(rand() & 24,rand() & 24);
  
  frame1.LineTo(rand() & 24,rand() & 24);
  frame1.LineTo(rand() & 24,rand() & 24);
  frame1.LineTo(rand() & 24,rand() & 24); 
  frame1.LineTo(rand() & 24,rand() & 24);
  frame1.LineTo(rand() & 24,rand() & 24);
  frame1.LineTo(rand() & 24,rand() & 24); 
  
   
  frame1.RefreshAllSlow(20);  
}




