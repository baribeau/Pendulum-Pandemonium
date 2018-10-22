// class for a simple pendulum
class Pendulum {
  
  // declaring fields 
  int len;
  float angle;
  float aVeloc;
  float aAccel;
  
  // constructor
  Pendulum(int l, float a) {
    this.len = l;
    this.angle = a;
    this.aVeloc = 0;
    this.aAccel = 0;
    
    pends.add(this);
  }
  
  // method to update the position of the pendulum
  void update(){
    this.aAccel = -grav/this.len * sin(this.angle);
    this.aVeloc += this.aAccel;
    this.angle += this.aVeloc;
  }
  
  // change the length of the pendulum
  void setLength(int l){
    this.len = l;
  }
  
  // change the starting angle
  void setAngle(float a){
    this.angle = a;
  }
  
  // change the angular velocity
  void setAVeloc(float v){
    this.aVeloc = v;
  }
  
  // change the angular acceleration
  void setAAccel(float a){
    this.aAccel = a;
  }
}