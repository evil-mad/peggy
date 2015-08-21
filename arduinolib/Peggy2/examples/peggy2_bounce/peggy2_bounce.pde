/* Simple example code for Peggy 2.0, using the Peggy2 library, version 0.2.

Bounces the bouncy ball.  

Press the "OFF/SELECT" button to nudge the ball a bit.

Copyright (c) 2008 Windell H Oskay.  All right reserved.

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

#include <Peggy2.h>
#include <math.h> 

#define g 0.1   //gravitational acceleration (should be positive.)
#define ts 0.01 // TimeStep

Peggy2 frame1;     // Make a frame buffer object, called frame1 

float xOld; // a few x & y position values
float yOld; // a few x & y position values

float VxOld; //  x & y velocity values 
float VyOld; //  x & y velocity values 
unsigned int pause = 0;
uint8_t NewBall = 101;
uint8_t  debounce = 0;

void setup()                    // run once, when the sketch starts
{
     frame1.HardwareInit();   // Call this once to init the hardware. 
                                        // (Only needed once, even if you've got lots of frames.)

DDRB = 254;		//All outputs except B0, the "OFF/SELECT" button.
PORTB |= 1;            // Turn on PortB Pin 0 pull up!

yOld = 0;
VyOld = 0;

}  // End void setup()  

void loop()                     // run over and over again
{ 
   
float Xnew, Ynew, VxNew, VyNew;
  
uint8_t xp, yp;      
  
if ( NewBall > 20 ) // IF ball has run out of energy, make a new ball!
  { 
    frame1.Clear();
    
      NewBall = 0;
    
  //Clear history: 
  xOld = -2;
  yOld = -2; 
  
  xOld = ((float)rand() / ((float)RAND_MAX + 1) * 25) ;   // Initial position: up to 24.
  yOld = (float) 25;
  
  //Random initial x-velocity:
  
  VxOld = ((float)rand() / ((float)RAND_MAX + 1) * 2*g) - g;   // Initial velocity: up to +/- g.
  
  //Zero initial y velocity:
  VyOld = 0; 
  } 
  
  /* Physics time!
  x' = x + v*t + at*t/2
  v' = v + a*t
  
  Horizontal (X) axis: No acceleration; a = 0.
  Vertical (Y) axis: a = -g
  */
  
// float Xnew,Ynew,VxNew,VyNew;
  
  Xnew = xOld + VxOld;
  Ynew = yOld + VyOld - 0.5*g*ts*ts;
  
  VyNew = VyOld - g*ts;
  VxNew = VxOld;
  
  // Bounce at walls
  
  if (Xnew < 0)
  {
    VxNew *= -1;
    Xnew = 0;
  }
  
 if (Xnew >= 24)
  {
    VxNew *= -1;
    Xnew = 24;
  }
   
  if (Ynew <= 0) {
    Ynew = 0;
    
    if (VyNew*VyNew < 0.1)  
    NewBall++;   
      
   if (VyNew < 0)
     VyNew *= -0.85;  
    
  }
  
    if (Ynew >= 25) {
    Ynew = 25; 
     
     if (VyNew > 0)  
     VyNew *= -0.85;  
    
  }
  
  if ( debounce && ((PINB & 1) == 0))
 {   
   if  (VyNew < 0)
     VyNew = -0.85*VyNew +  g*ts;
   else
       VyNew +=  g*ts;
   
   frame1.SetPoint(0, 0);
 }
   
if ((PINB & 1) == 0)
   { // "Off/select" button pressed
   debounce = 1;
   }
else
   debounce = 0;
   
   
//   *** Draw buffer matrix ***

//First, clear old frame buffer
//Note: Comment out the following line to leave trails after the ball!
frame1.Clear();

//Next, figure out which point we're going to draw. 

xp =      (uint8_t) round(Xnew);
yp = 24 - (uint8_t) round(Ynew);

// Write the point to the buffer
frame1.SetPoint(xp, yp);

// Display the frame buffer
frame1.RefreshAll(4); //Draw frame buffer some number of times

//Age variables for the next iteration
  VxOld = VxNew;
  VyOld = VyNew;
   
  xOld = Xnew;
  yOld = Ynew; 
 
}
