color shipCol = color(10); //default color is black
color mCol = color(255, 0, 0);
int x=250;
int y=250;
int clock=0;
boolean isShooting=false;
boolean[] keys = {false, false, false, false,false};//w,a,s,d, mouseclick
boolean[][] occupied = new boolean[500][500];
float aimAngle = 0;
color tan = color(254,232,198);
color blackbrown = color(75,45,30);
int playerScore = 0;
int npcScore = 0;

Ship[] ships = new Ship[1]; //create array of players, should be able to take data from SQL
Enemy[] enemies = new Enemy[1];
void settings() {//this allows for dynamic sizeing etc
}
void setup() {
  //for (int i=0; i<ships.length; i++) {
    //ships[i] = new Ship(int(random(0, 500)), int(random(0, 500)), 0, i);//initialize the ships at random locations
 // }
  ships[0] = new Ship(int(random(0, 500)), int(random(0, 500)), 0, 0,tan);
  enemies[0] = new Enemy(int(random(0, 500)), int(random(0, 500)), 0, 1,blackbrown);
  size(501, 601);//set window size
  frameRate(600);//set refresh rate
  background(240);//background color 0=black 255=white
}

void draw() {
  background(240);//without this line, past images of ships would stay on screen
  for (int i=0; i<ships.length; i++) {//for all ships
    //fill(0,0,0);
    //rect(0,0,500,500);
    line(0,0,0, 500);
    line(0,0,500,0);
    line(0,500,500,500);
    line(500,0,500,500);
    fill(195,255,195);
    rect(0,500,500,600);
    fill(0,0,0);
    textSize(14);
    text("player's score",60,530);
    text("NPC's score",370,530);
    textSize(20);
    text(playerScore,100,550);
    text(npcScore,400,550);
    ships[i].updateLocation();//move the ships
    enemies[i].updateLocation();
    stroke(shipCol);
    line(ships[i].x, ships[i].y, ships[i].x+100*cos(ships[i].aim), ships[i].y+100*sin(ships[i].aim));//draws a line from the ship along the aim angle, 100 pixels in length
    line(enemies[i].x, enemies[i].y, enemies[i].x+100*cos(enemies[i].aim), enemies[i].y+100*sin(enemies[i].aim));//draws a line from the ship along the aim angle, 100 pixels in length
  }
  fill(mCol);
  //ellipse(mouseX, mouseY, 10, 10);//x,y, x radius, y radius.

  clock = clock+1;//increment clock (used for shooting
  shoot();//calls shoot
}

class Ship {
  int shipNum;
  int x;
  int y;
  float aim;
  float npcAng; //the angle from the player to the NPC
  color initCol;
  color col;
  int bMax =100; //here
  int bNum=0;
  int bLife = 6000;
  int bulletNum = 100;
  int timesHit = 0;
  int bulletsDeadNumer = 0; //the number of bullets that have gone off the screen.
  Bullet[] bullets = new Bullet[bMax];//each ship owns some bullits
  //boolean shipType; // true if ship is players ship, false if it is NPC
  //int unidirectional; //a random angle to  
  
  Ship(){} //implicit constructor, neccesary as this is a parent class

  Ship(int initX, int initY, int initAim, int num, color shipColor) {//this is used to create new ships
    shipNum = num;
    x = initX;
    y=initY;
    aim=initAim;
    //initCol = color(random(0, 255), random(0, 255), random(0, 255));
    initCol = shipColor;
    col = shipColor;
    for (int i=0; i<bullets.length; i++) {//creating a new ship also gives it blank bullets
      bullets[i] = new Bullet(x, y, aim,shipCol);
    }
  }
  void updateLocation() {//used to move around
    if (keys[0] && y >=10) {//w
      y=y-1;
    }
    if (keys[1] && x >=10) {//a
      x=x-1;
    }
    if (keys[2] && y<=491) {//s
      y=y+1;
    }
    if (keys[3] && x<=491) {//d
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
      if ((bullets[i].lifespan >=0) && (bullets[i].lifespan < bLife && bullets[i].currentY < 500)) {//lets you "delete" bullets by setting lifespan to -1
        bullets[i].lifespan++;//longer lifespan will cause bullets to be on screen longger
        bullets[i].updateLocation();
        bullets[i].draw();
      }
    }
  }
  void shoot() {
    bullets[bNum] = new Bullet(x, y, aim,tan);// x,y, aim make the bullet inherit its path
    bullets[bNum].lifespan =0;//setting to 0 starts the bullet life
    bNum++;//makes the ship not reset the same bullet.
    if (bNum >= bMax) {
      bNum = 0;//end of array loops back
    }
  }
  void checkHit() {
    for (int i=x-4; i<x+5; i++) {
      for(int j=y-4;j<y+5;j++){
        if(occupied[i][j] == true) {
          if (col != color(255,0,0)) {
            if(shipNum == 0) {
              npcScore++;
            }
            else{
              playerScore++;
            }
          }
          col = color(255,0,0);
          return;
        }
      }
    } 
    col = initCol;
    //timesHit++;
    //if(timesHit > 4) {
      //shipdestroy();
    //}
    //col = color(255,0,0);
      
  }
  
  void shipDestroy(){
    color c = color(0,255,0);
    fill(c);
    ellipse(x, y, 100, 100);
  }
  void draw() {//drawing the ship *replace with better graphics*
    fill(col);
    ellipse(x, y, 15, 15);
  }
}

class Enemy extends Ship {
  int xmov;  // random directions in which the ship will move
  int ymov;  // 
  
  Enemy (int initX, int initY, int initAim, int num, color shipColor) {//this is used to create new ships
    shipNum = num;
    x = initX;
    y=initY;
    aim=initAim;
    //initCol = color(random(0, 255), random(0, 255), random(0, 255));
    initCol = shipColor;
    col = shipColor;
    for (int i=0; i<bullets.length; i++) {//creating a new ship also gives it blank bullets
      bullets[i] = new Bullet(x, y, aim,shipCol);
    }
  }
 
  void updateLocation() {
    if (ships[0].x != x) {//cant devide by 0
      npcAng =(atan(float(( ships[0].y-y)/( ships[0].x-x)))); //the angle from the player to the NPC
    } else {
      npcAng =(atan(float(( ships[0].y-y)/( ships[0].x+1-x))));
    }
    if (ships[0].x < x) {
      npcAng=npcAng+PI;  //adjust for arcTan range
    }
    /*Vector localRange = checkRange(x,y);
    if(localRange.x != -1) {    // This should tell the NPC to start moving if there is a bullet nearby, but it causes the game to freeze
      if(xmov == 0 && ymov == 0) {
        int xRand = (int)random(0,2);
        xmov = xRand - 1;
        int yRand = (int)random(0,2);
        ymov = yRand - 1;
      }
    }*/
    moveRandom();
    aim = npcAng;
    //aim(npcAng);
    this.checkHit();
    this.draw();
    
    for (int i=0; i<bullets.length; i++) {
      if ((bullets[i].lifespan >=0) && (bullets[i].lifespan < bLife && bullets[i].currentY < 500)) {//lets you "delete" bullets by setting lifespan to -1
        bullets[i].lifespan++;//longer lifespan will cause bullets to be on screen longger
        bullets[i].updateLocation();
        bullets[i].draw();
      }
    }
  }
  void moveRandom() {
    int xRand = (int)random(0,1500);
    if(xRand <= 3) {
      xmov = xRand-1;
    }
    int yRand = (int)random(0,1500);
    if(yRand <= 3){
      ymov = yRand-1;
    }
    if(x<10) {
      xmov = 1;
    }
    else if(x>=490) {
      xmov = -1;
    }
    if(y<10) {
      ymov = 1;
    }
    else if(y>=490) {
      ymov = -1;
    }
    move();
  }
  void move() {
    if(xmov == 1) {
      x++;
    }
    else if(xmov == -1) {
      x--;
    }
    if(ymov == 1) {
      y++;
    }
    else if(ymov == -1) {
      y--;
    }
  }
  void shoot() {
    bullets[bNum] = new Bullet(x, y, aim,shipCol);// x,y, aim make the bullet inherit its path
    bullets[bNum].lifespan =0;//setting to 0 starts the bullet life
    bNum++;//makes the ship not reset the same bullet.
    if (bNum >= bMax) {
      bNum = 0;//end of array loops back
    }
  }
  void shipDestroy() {
    color c = color(255,255,255);
    col = c;
    bulletNum = 0;
  }
  Vector checkRange(int x, int y) { //this checks whether there are any bullets within 30 spaces of the range x,y
    for (int i=x-15; i<x+16; i++) {
      for(int j=y-15; j<x+16; j++){
        if(occupied[i][j] == true) {
          return new Vector(i,j);
        }
      }
    }
    return new Vector(-1,-1);
  }
}

class Vector {
  int x;
  int y;
  Vector(int x, int y) {
    this.x = x;
    this.y = y;
  }
}

class Bullet {
  int originX;
  int originY;
  int currentX;
  int currentY;
  float aim;
  int lifespan;
  boolean dead; //when the bullet goes out of range or hits someone, it's 'dead' and will be deleted
  color bulletColor;
  Bullet(int x, int y, float angle, color bulletColor) {
    aim = angle;
    originX = (int)(x + 35*cos(aim));
    originY = (int)(y + 35*sin(aim));
    lifespan = -1;
    this.bulletColor = bulletColor;
  }
  void updateLocation() {
    if(currentX > 0 && currentX < 500 && currentY > 0 && currentY < 500) {
      occupied[currentX][currentY] = false;
    }
    currentX = int(originX+lifespan*cos(aim));
    currentY = int(originY+lifespan*sin(aim));
    if(currentX > 0 && currentX < 500 && currentY > 0 && currentY < 500) {
      occupied[currentX][currentY] = true;
    }    
  }
  void draw() {
    fill(bulletColor);
    ellipse(currentX, currentY, 5, 5);//pew pew
  }
}

void shoot() {
  isShooting=(((clock % 60)==0));//clock makes all the ships shoot together
  if (isShooting) {
    for (int i=0; i<enemies.length; i++) {
      enemies[i].shoot();
    }
    mCol = color(255, 0, 0);//blinks cursor
  } else {
    mCol = color(0, 0, 255);//blinks cursor
  }
}

void mouseClicked() {
  ships[0].shoot();
}

void keyPressed() {//as long as a key is pressed, use it in program
  if (key=='w' || key == 'W') { //in case caps lock is accidentally pressed, it also works when capitalized
    keys[0]=true;
  }
  if (key=='a' || key == 'A') {
    keys[1]=true;
  }
  if (key=='s' || key == 'S') {
    keys[2]=true;
  }
  if (key=='d' || key == 'D') {
    keys[3]=true;
  }
}


void keyReleased() {//other case
  if (key=='w' || key == 'W') {
    keys[0]=false;
  }
  if (key=='a' || key == 'A') {
    keys[1]=false;
  }
  if (key=='s' || key == 'S') {
    keys[2]=false;
  }
  if (key=='d' || key == 'D') {
    keys[3]=false;
  }
}
