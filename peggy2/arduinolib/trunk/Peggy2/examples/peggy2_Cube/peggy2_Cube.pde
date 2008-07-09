/*

+ PeggyCube - LED rotating wired cube - 05 june 2008

+ Credits :  
   - code by Micha‘l Zancan & Julien 'v3ga' Gachadoat

+ Video : 
http://www.vimeo.com/1125083

+ Websites:
http://www.2roqs.com
http://www.zancan.fr
http://www.v3ga.net

Have fun !

Minor modifications added by Windell H. Oskay, 09 June 2008.

*/

// ------------------------------------------------------------
// inclusion
// ------------------------------------------------------------
#include <Peggy2.h>

// ------------------------------------------------------------
// Globals
// ------------------------------------------------------------
float focal = 30; // Focal of the camera
int cubeWidth = 20; // Cube size
float Angx = 0, AngxSpeed = 0.017; // rotation (angle+speed) around X-axis
float Angy = 0, AngySpeed = 0.022; // rotation (angle+speed) around Y-axis
float Ox=12.5,Oy=12.5; // position (x,y) of the frame center
int zCamera = 110; // distance from cube to the eye of the camera

unsigned short reps = 0; // used for grey scaling
unsigned short repNumber = 1;  //Change scrolling rate-- number of reps at each position.
 

// ------------------------------------------------------------
// Objects
// ------------------------------------------------------------
Peggy2 frame1,frame2; // Drawing surfaces
// The cube is defined before the setup method

// ------------------------------------------------------------
// struct Vertex
// ------------------------------------------------------------
struct Vertex
{
  float x,y,z;	
  Vertex()
  {
    this->set(0,0,0);
  }

  Vertex(float x,float y, float z)
  {
    this->set(x,y,z);
  }

  void set(float x, float y, float z)
  {
    this->x = x;
    this->y = y;
    this->z = z;
  }
};

// ------------------------------------------------------------
// struct EdgePoint
// ------------------------------------------------------------
struct EdgePoint
{
  int x,y;
  boolean visible;

  EdgePoint()
  {
    this->set(0,0);
    this->visible = false;
  }

  void set(int a,int b)
  {
    this->x = a;
    this->y = b;
  }
};

// ------------------------------------------------------------
// struct Point
// ------------------------------------------------------------
struct Point
{	
  float x,y;

  Point()
  {
    set(0,0);
  }

  Point(float x,float y)
  {
    set(x,y);
  }

  void set(float x, float y)
  {
    this->x = x;
    this->y = y;    
  }

};	

// ------------------------------------------------------------
// struct squareFace
// ------------------------------------------------------------
struct squareFace
{	
  int length;
  int sommets[4];
  int ed[4];

  squareFace()
  {
    set(-1,-1,-1,-1);
  }

  squareFace(int a,int b,int c,int d)
  {
    this->length = 4;
    this->sommets[0]=a;
    this->sommets[1]=b;
    this->sommets[2]=c;
    this->sommets[3]=d;
  }

  void set(int a,int b,int c,int d)
  {
    this->length = 4;
    this->sommets[0]=a;
    this->sommets[1]=b;
    this->sommets[2]=c;
    this->sommets[3]=d;
  }

};

// ------------------------------------------------------------
// struct Cube
// ------------------------------------------------------------
struct Cube
{
  // Local vertices
  Vertex  local[8];
  // Camera aligned vertices
  Vertex  aligned[8];
  // On-screen projected vertices
  Point   screen[8];
  // Faces
  squareFace face[6];
  // Edges
  EdgePoint edge[12];
  int nbEdges;
  // ModelView matrix
  float m00,m01,m02,m10,m11,m12,m20,m21,m22;   

  // constructor
  Cube(){}

  // constructs the cube
  void make(int w)
  {
    nbEdges = 0;

    local[0].set(-w,w,w);
    local[1].set(w,w,w);
    local[2].set(w,-w,w);
    local[3].set(-w,-w,w);
    local[4].set(-w,w,-w);
    local[5].set(w,w,-w);
    local[6].set(w,-w,-w);
    local[7].set(-w,-w,-w);  

    face[0].set(1,0,3,2);
    face[1].set(0,4,7,3);
    face[2].set(4,0,1,5);
    face[3].set(4,5,6,7);
    face[4].set(1,2,6,5);
    face[5].set(2,3,7,6);

    int f,i;
    for (f=0;f<6;f++)
    {	
      for (i=0;i<face[f].length;i++)
      {	
        face[f].ed[i]= this->findEdge(face[f].sommets[i],face[f].sommets[i?i-1:face[f].length-1]);
      }
    }

  }

  // finds edges from faces
  int findEdge(int a,int b)
  {	
    int i;
    for (i=0;i<nbEdges;i++)
      if ( (edge[i].x==a && edge[i].y==b) || (edge[i].x==b && edge[i].y==a))
        return i;
    edge[nbEdges++].set(a,b);
    return i;
  }

  // rotates according to angle x&y
  void rotate(float angx, float angy)
  {
    int i,j;
    int a,b,c;
    float cx=cos(angx);
    float sx=sin(angx);
    float cy=cos(angy);
    float sy=sin(angy);

    m00=cy;   
    m01=0;  
    m02=-sy;
    m10=sx*sy;
    m11=cx; 
    m12=sx*cy;
    m20=cx*sy;
    m21=-sx;
    m22=cx*cy;

    for (i=0;i<8;i++)
    {	
      aligned[i].x=m00*local[i].x+m01*local[i].y+m02*local[i].z;
      aligned[i].y=m10*local[i].x+m11*local[i].y+m12*local[i].z;
      aligned[i].z=m20*local[i].x+m21*local[i].y+m22*local[i].z+zCamera;

      screen[i].x = floor((Ox+focal*aligned[i].x/aligned[i].z));
      screen[i].y = floor((Oy-focal*aligned[i].y/aligned[i].z));	
    }		

    for (i=0;i<12;i++) 
      edge[i].visible=false;

    Point *pa,*pb,*pc;
    for (i=0;i<6;i++)
    {	
      pa=screen + face[i].sommets[0];	
      pb=screen + face[i].sommets[1];	
      pc=screen + face[i].sommets[2];	

      boolean back=((pb->x-pa->x)*(pc->y-pa->y)-(pb->y-pa->y)*(pc->x-pa->x))<0;
      if (!back)
      {
        int j;
        for (j=0;j<4;j++)
        {	
          edge[face[i].ed[j]].visible=true;
        }
      }      
    }
  }

  // Draw the cube using the line method !
  void draw()
  {
     int i;

    // Backface
    EdgePoint *e;
    for (i=0;i<12;i++)
    {	
      e = edge+i;
      if (!e->visible)
        frame1.Line(screen[e->x].x,screen[e->x].y,screen[e->y].x,screen[e->y].y);  
    }

    // Frontface
    for (i=0;i<12;i++)
    {	
      e = edge+i;
      if (e->visible)
      {
        frame2.Line(screen[e->x].x,screen[e->x].y,screen[e->y].x,screen[e->y].y);
      }
    }

  }

};





// ------------------------------------------------------------
// setup
// ------------------------------------------------------------
Cube cube;

void setup()
{
  frame1.HardwareInit();   // Call this once to init the hardware. 
  cube.make(cubeWidth);    // Create vertices, edges, faces
}

// ------------------------------------------------------------
// loop
// ------------------------------------------------------------
void loop()
{
  // Update values
  Angx+=AngxSpeed;
  Angy+=AngySpeed;
  if (Angx>=TWO_PI)
    Angx-=TWO_PI;
  if (Angy>=TWO_PI)
    Angy-=TWO_PI;

  cube.rotate(Angx, Angy);

  // Clear frames
  frame1.Clear();
  frame2.Clear();

  // Draw cube
  cube.draw();

  // Flicker !
  for (reps=0; reps< repNumber;reps++)
  {
    frame1.RefreshAll(1); //Draw frame buffer 1 time
    frame2.RefreshAll(10); //Draw frame buffer 10 times
  }

}

