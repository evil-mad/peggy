//PeggyRemoteDraw
/** 
 * Adapted from Serial Call-Response 
 * by Tom Igoe. 
 *  
 */

import processing.serial.*;
color bgColor;
   
boolean SerialEnabled;
boolean  ComEstablished = false;

Serial myPort;                       // The serial port 
byte xpos, ypos, colorNum;	     
int   inByte;

void setup() {
   bgColor = color(70, 70, 200);
   
  size(200, 200);
  smooth();   
    
  textFont(loadFont("Ziggurat.vlw"), 20); 
  

  background(bgColor);
 fill(255);  
 text("Click to Stop", 25, 100); 
 
  // Print a list of the serial ports, for debugging purposes:
  println(Serial.list());

  // I know that the first port in the serial list on my mac
  // is always my  FTDI adaptor, so I open Serial.list()[0].
  // On Windows machines, this generally opens COM1.
  // Open whatever port is the one you're using.

  String portName = Serial.list()[0];
  myPort = new Serial(this, portName, 115200);
  myPort.clear();
  SerialEnabled = true;
    
  serialSendHello(myPort);  
    
}


 
void draw() { 
    
 xpos = byte(floor(random(25)));
 ypos = byte(floor(random(25)));
 colorNum = byte(floor(random(2)));     // 1 or 0, for back or white
 
 delay(5);
 serialDrawPixel(myPort,xpos,ypos,colorNum); 
  

  // Exit gracefully, at the end of the loop function, once the button has been pushed.
  if (SerialEnabled == false)
    exit(); 
}
 

boolean serialDrawPixel(Serial myPort, byte x, byte y, byte colorNumber)
{  
  if (SerialEnabled)
  {  
    myPort.write('d');  
    myPort.write(x);   
    myPort.write(y);  
    myPort.write(colorNumber);  
    myPort.write('D'); 
       
    return true; 
  }
  else
    return false;
} // end serialDrawPixel


  

boolean serialDisplaySlate(Serial myPort)
{  
  if (SerialEnabled)
  {  
    myPort.write('s'); 
      return true; 
  }
  else
    return false;
} // end serialDisplaySlate
 
 
 
void serialSendHello(Serial myPort)
{  
  if (SerialEnabled)
  {
    println("PeggyCom: \tSending Hello to Peggy 2.");  
    myPort.clear(); 
    myPort.write('h');
  }
    return;
} // end serialSendHello

 
 
 
 


void mousePressed()
{ 
   
    SerialEnabled  = false;
    myPort.clear();
    myPort.stop();
    exit(); 
}

 






void serialEvent(Serial myPort) {
  // read a byte from the serial port:
  int inByte = myPort.read();
  // if this is the first byte received, and it's an A,
  // clear the serial buffer and note that you've
  // had first contact from the microcontroller. 
  // Otherwise, add the incoming byte to the array:
  if (ComEstablished == false) {
    
  //  if (inByte == 255) { // Proper response to Hello char
      myPort.clear();          // clear the serial port buffer
       ComEstablished = true; 
       println("\tPeggy says to say hi to you. :)");
  //  } 
    
  } 
  else {
    
   if (inByte == 'X')
      println("\tPeggy reports: command not understood.");
  else if (inByte == 'B')
      println("\tPeggy  reports: Bad input values.");
  else if (inByte == 'T')
      println("\tPeggy reports: Timeout error.");
 
  }
}

 
 
 
  boolean overRect(int x, int y, int width, int height) 
  {
    if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height) {
      return true;
    } 
    else {
      return false;
    }
  }







