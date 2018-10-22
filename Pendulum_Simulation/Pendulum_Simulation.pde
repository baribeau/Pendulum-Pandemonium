// importing libraries used for GUI and camera controls
import g4p_controls.*;
import peasy.PeasyCam;

// defining global variables
PeasyCam cam;
String mode;
int j;
int beamLength, beamHeight;
int defaultLen = 250;
float defaultAngle = 45;
IntList defLens;
FloatList defAngles;
float grav;
ArrayList<Pendulum> pends;
boolean visible = true;

void setup() {
  size(600, 600, P3D);

  // setting initial values for the sketch
  cam = new PeasyCam(this, 300, 300, 0, 600);
  createGUI();
  mode = "still";
  j = 0;
  grav = 0.45;
  beamLength = 380;
  beamHeight = 300;
  pends = new ArrayList<Pendulum>();
  defLens = new IntList();
  defAngles = new FloatList();
  for(int i=0; i<12; i++){
    defLens.append(defaultLen);
    defAngles.append(defaultAngle);
  }  
  
}

void draw() {

  // setting the scene for the simulation
  background(209, 232, 266);
  lights();
  directionalLight(128, 128, 128, 0, 0, 1);
  
  // construction of the base block
  noStroke();
  if(visible) // ghost mode off
    fill(217,176,140);
  else
    noFill();
  pushMatrix();
  translate(300,500,0);
  box(560,60,400);
  popMatrix();
  
  // construction of the supporting beam
  if(visible)
    fill(64,73,69);
  else
    noFill();
  pushMatrix();
  translate(width-100, beamHeight, 0);
  box(20,400,20);
  popMatrix();
  
  if(!visible) // only draw outline if ghost mode is on
    stroke(255,255,255);
  pushMatrix();
  translate(width/2, 100, 0);
  box(beamLength+40,20,20);
  popMatrix();  
  
  noStroke();
  pushMatrix();
  translate(100, beamHeight, 0);
  box(20,400,20);
  popMatrix();

  // calling the procedure for drawing the pendulums
  drawSimple();
   
}

// procedure for drawing simple pendulum: point mass on end of massless rod
void drawSimple(){
  
    float spacing = float(beamLength+10)/(pends.size()+1);
    for(int i=0; i<pends.size(); i++){
      
      if(mode == "moving" || j ==0){ // pendulums only move when simulation is running ("go" button)
        j ++;
        pends.get(i).update();
      }
    
    // determining the x, y, and z coordinates for the pendulum mass
    float curX = 100 + spacing*(i+1);
    float curY = 110 + pends.get(i).len * cos(pends.get(i).angle);
    float curZ = pends.get(i).len * sin(pends.get(i).angle);
    
    // drawing the rod
    stroke(0);
    line(100+spacing*(i+1),110,0, curX,curY,curZ);
      
    // drawing the pendulum mass
    noStroke();  
    pushMatrix();
    fill(37,120,122);
    translate(curX, curY, curZ);
    sphere(15);
    popMatrix();
    
  } 
}

// procedure for reading a file
void readFile(int fileNum){
  String[] lines = loadStrings("file"+fileNum+".txt");
  int n = parseInt(lines[0]);
  int[] l = int(split(lines[1], ","));
  float[] a = float(split(lines[2], ","));
  IntList L = new IntList(250,250,250,250,250,250,250,250,250,250,250,250);
  FloatList A = new FloatList(45,45,45,45,45,45,45,45,45,45,45,45);
  for(int i=0; i<n; i++){
    L.set(i,l[i]);
    A.set(i,a[i]);
  }
  presets(n, L, A); // after reading a file, automatically sets the values in the simulation
}

// procedure for setting predetermined values
void presets(int nP, IntList lens, FloatList angs){
  for(int i=0; i<nP; i++){
    defLens.set(i, lens.get(i));
    defAngles.set(i, angs.get(i));
  
  }
  numP.setText(""+nP);
  numP_changed(numP, GEvent.CHANGED);
}