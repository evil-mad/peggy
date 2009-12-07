/*

+ PeggyLine - a simple rotating line - 05 june 2008

+ Credits :  
   - code by Micha�l Zancan & Julien 'v3ga' Gachadoat

+ Websites:
http://www.2roqs.com
http://www.zancan.fr
http://www.v3ga.net

Enjoy !


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
float angle=0,angleSpeed=PI/20;

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
  angle += angleSpeed;
  if (angle>= TWO_PI)
    angle-=TWO_PI;

  frame1.Clear();
  frame1.Line(12,12,int(12+12*cos(angle)),int(12+12*sin(angle)));
  frame1.RefreshAllSlow(10);  
}




