color shipCol = color(255); //default color is white
color mCol = color(255,0,0);
int x=0;
int y=250;
int clock=0;
boolean isShooting=false;
boolean[] keys = {false, false, false, false};//w,a,s,d
void settings() {

  
}
void setup() {
  size(500, 500);
  frameRate(60);
  background(5);
}

void draw() {  
  background(5);
  updateLocation();
  fill(shipCol);
  ellipse(x,y,15,15);
  
  fill(mCol);
  ellipse(mouseX, mouseY, 10,10);
  clock = clock+1;
  shoot();
}


void updateLocation(){
  if (keys[0]){//w
    y=y-1;
  }
  if (keys[1]){//a
    x=x-1;
  }
  if (keys[2]){//s
    y=y+1;
  }
  if (keys[3]){//d
    x=x+1;
  }
}


void shoot(){
  isShooting=(((clock % 20)>=0)&&((clock % 20)<=5));
  if (isShooting){
    mCol = color(255,0,0);
  }else{
    mCol = color(0,0,255);
  }

}


void keyPressed() {
  if (key=='w') {
    keys[0]=true;
  }
  if (key=='a') {
    keys[1]=true;
  }
  if (key=='s') {
    keys[2]=true;
  }
  if (key=='d') {
    keys[3]=true;
  }
}


void keyReleased() {
  if (key=='w') {
    keys[0]=false;
  }
  if (key=='a') {
    keys[1]=false;
  }
  if (key=='s') {
    keys[2]=false;
  }
  if (key=='d') {
    keys[3]=false;
  }
}