color shipCol = color(255); //default color is white
color mCol = color(255, 0, 0);
int x=250;
int y=250;
int clock=0;
boolean isShooting=false;
boolean[] keys = {false, false, false, false};//w,a,s,d
float aimAngle = 0;

Ship[] ships = new Ship[10]; //create array of players, should be able to take data from SQL
void settings() {//this allows for dynamic sizeing etc
}
void setup() {
  for (int i=0; i<ships.length; i++) {
    ships[i] = new Ship(int(random(0, 500)), int(random(0, 500)), 0, i);//initialize the ships at random locations
  }

  size(500, 500);//set window size
  frameRate(600);//set refresh rate
  background(5);//background color 0=black 255=white
}

void draw() {
  background(5);//without this line, past images of ships would stay on screen
  for (int i=0; i<ships.length; i++) {//for all ships
    ships[i].updateLocation();//move the ships
    stroke(shipCol);
    line(ships[i].x, ships[i].y, ships[i].x+100*cos(ships[i].aim), ships[i].y+100*sin(ships[i].aim));//draws a line from the ship along the aim angle, 100 pixels in length
  }
  fill(mCol);
  ellipse(mouseX, mouseY, 10, 10);//x,y, x radius, y radius.

  clock = clock+1;//increment clock (used for shooting
  shoot();//calls shoot
}

class Ship {
  int shipNum;
  int x;
  int y;
  float aim;
  color initCol;
  color col;
  int bMax =60;
  int bNum=0;
  int bLife = 6000;
  Bullet[] bullets = new Bullet[bMax];//each ship owns some bullits

  Ship(int initX, int initY, int initAim, int num) {//this is used to create new ships
    shipNum = num;
    x = initX;
    y=initY;
    aim=initAim;
    initCol = color(random(0, 255), random(0, 255), random(0, 255));

    for (int i=0; i<bullets.length; i++) {//creating a new ship also gives it blank bullets
      bullets[i] = new Bullet(x, y, aim);
    }
  }
  void updateLocation() {//used to move around
    if (keys[0]) {//w
      y=y-1;
    }
    if (keys[1]) {//a
      x=x-1;
    }
    if (keys[2]) {//s
      y=y+1;
    }
    if (keys[3]) {//d
      x=x+1;
    }

    if (mouseX != x) {//cant devide by 0
      aim =(atan(float(( mouseY-y)/( mouseX-x))));
    } else {
      aim =(atan(float(( mouseY-y)/( mouseX+1-x))));
    }
    if (mouseX < x) {
      aim=aim+PI;//adjust for arcTan range
    }
    this.checkHit();
    this.draw();

    for (int i=0; i<bullets.length; i++) {
      if ((bullets[i].lifespan >=0) && (bullets[i].lifespan < bLife)) {//lets you "delete" bullets by setting lifespan to -1
        bullets[i].lifespan++;//longer lifespan will cause bullets to be on screen longger
        bullets[i].updateLocation();
        bullets[i].draw();
      }
    }
  }
  void shoot() {
    bullets[bNum] = new Bullet(x, y, aim);// x,y, aim make the bullet inherit its path
    bullets[bNum].lifespan =0;//setting to 0 starts the bullet life
    bNum++;//makes the ship not reset the same bullet.
    if (bNum >= bMax) {
      bNum = 0;//end of array loops back
    }
  }
  void checkHit() {
    boolean HIT = false;
    for (int i=0; i<ships.length; i++) {
      if (i!= shipNum) {
        for (int j=0; j<bullets.length; j++) {
          if ((x-15 <= ships[i].bullets[j].currentX) && (x+15 >= ships[i].bullets[j].currentX) && (y-15 <= ships[i].bullets[j].currentY) &&(y+15 >= ships[i].bullets[j].currentY)){
            HIT = true;
          }
        }
      }
    }
    if (HIT){
      col = color(255,0,0);
    }else{
      col = initCol;
    }
      
  }
  void draw() {//drawing the ship *replace with better graphics*
    fill(col);
    ellipse(x, y, 15, 15);
  }
}

class Bullet {
  int originX;
  int originY;
  int currentX;
  int currentY;
  float aim;
  int lifespan;
  Bullet(int x, int y, float angle) {
    originX = x;
    originY = y;
    aim = angle;
    lifespan = -1;
  }
  void updateLocation() {
    currentX = int(originX+lifespan*cos(aim));
    currentY = int(originY+lifespan*sin(aim));
  }
  void draw() {
    ellipse(currentX, currentY, 5, 5);//pew pew
  }
}





void shoot() {
  isShooting=(((clock % 20)==0));//clock makes all the ships shoot together
  if (isShooting) {
    for (int i=0; i<ships.length; i++) {
      ships[i].shoot();
    }
    mCol = color(255, 0, 0);//blinks cursor
  } else {
    mCol = color(0, 0, 255);//blinks cursor
  }
}


void keyPressed() {//as long as a key is pressed, use it in program
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


void keyReleased() {//other case
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