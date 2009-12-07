/*

+ PeggyStar - a rotating star - 05 june 2008

+ Credits :  
   - code by Micha�l Zancan & Julien 'v3ga' Gachadoat

+ Websites:
http://www.2roqs.com
http://www.zancan.fr
http://www.v3ga.net

Play, Create & Share !

Slightly modified by Windell H. Oskay, 6/8/2008.

*/

// ------------------------------------------------------------
// inclusion
// ------------------------------------------------------------
//#include <Peggy2.h>
#include <Peggy2Serial.h>


// ------------------------------------------------------------
// Globals
// ------------------------------------------------------------
Peggy2 frame1;
float a=0,angle=0,angleSpeed=PI/20,angleStep;
float radius = 12;
int nbLines = 5;
float starx = 12, stary = 12;

// ------------------------------------------------------------
// setup
// ------------------------------------------------------------
void setup()
{
  frame1.HardwareInit();   // Call this once to init the hardware. 
  angleStep = float(TWO_PI) / float(nbLines);
  
       asm("cli");	// Optional: Disable global interrupts for a smoother display
}

void loop()
{
  angle += angleSpeed;
  if (angle>= TWO_PI)
    angle-=TWO_PI;

  frame1.Clear();
  for (int i=0;i<nbLines;i++)
  {
    a = angle+i*angleStep;
    frame1.Line(starx,stary,int(starx+radius*cos(a)),int(stary+radius*sin(a)));
  }
//  frame1.RefreshAll(50);  // was 120
  frame1.RefreshAllSlow(10);  // was 120
  
}
