import java.util.Arrays;

color shipCol = color(10); //default color is black
color mCol = color(255, 0, 0);
int x=250;
int y=250;
int clock=0;
boolean isShooting=false;
boolean[] keys = {false, false, false, false,false};//w,a,s,d, mouseclick
int[][] occupied = new int[500][500];
float aimAngle = 0;
color tan = color(254,232,198);
color blackbrown = color(75,45,30);
int playerScore = 0;
int npcScore = 0;
boolean gamestart = true; 
int numberNPC = 1;
boolean shipsset = false;
boolean unittest = false;  //if this is true, unit tests will be conducted
boolean testsPassed = true;
boolean testDone = false;
String[] failureMessage = new String[8];
color startColor1 = color(0,0,0);
color startColor2 = color(221,12,15);
int startColor1Value = 0;
boolean startColor1Change = true;
color userColor = tan;

Ship[] ships = new Ship[1]; //create array of players, should be able to take data from SQL
Enemy[] enemies;// = new Enemy[1];
void settings() {//this allows for dynamic sizeing etc
}
void setup() {
  size(501, 601);//set window size
  frameRate(600);//set refresh rate
  background(240);//background color 0=black 255=white
}

void draw() {
  background(240);//without this line, past images of ships would stay on screen
  if(unittest == true) {
    gamestart = false;
  }
  if(gamestart) { // first promp will ask users how many NPC's they want
    //fill(startColor2);
    //rect(70,30,350,90);
    fill(startColor1);
    textSize(75);
    text("Bullet Hell",80,90);
    textSize(20);
    text("Created by",200,160);
    text("Charles Davies * Zachary Johnson",100,190);
    text("Booker Lightman * John Odom",120,210);
    colorChange();
    fill(0,0,0);
    rect(0,235,500,5);
    textSize(35);
    text("Number of NPCs?",20,305);
    textSize(50);
    fill(255,255,255);
    rect(315,260,40,70);
    rect(390,260,40,70);
    fill(0,0,0);
    text("1",320,315);
    text("2",395,315);
    textSize(35);
    text("Color?",200,385);
    /*color gray = color(155,155,155);
    color green = color(34,177,26);
    color brown = color(185,122,67);
    color orange = color(255,127,39);
    color blue = color(63,72,204);
    color purple = color(163,73,164);
    color yellow = color(255,242,0);
    color lightblue = color(117,193,255);
    color red = color(225,24,23);
    color lightgreen = color(146,255,47);
    color pink = color(255,174,201);*/
    fill(155,155,155);
    rect(30,405,50,50);
    fill(34,177,26);
    rect(90,405,50,50);
    fill(185,122,67);
    rect(150,405,50,50);
    fill(255,127,39);
    rect(210,405,50,50);
    fill(63,72,204);
    rect(270,405,50,50);
    fill(163,73,164);
    rect(330,405,50,50);
    fill(255,242,0);
    rect(390,405,50,50);
    fill(tan);
    rect(90,465,50,50);
    fill(117,193,255);
    rect(150,465,50,50);
    fill(225,24,23);
    rect(210,465,50,50);
    fill(146,255,47);
    rect(270,465,50,50);
    fill(255,174,201);
    rect(330,465,50,50);
    fill(255,255,255);
    rect(150,525,150,50,10);
    fill(34,177,26);
    textSize(20);
    text("Start Game",170,560);
    /*if(unittest) {
      String message = unitTests();
      if(!message.equals("0")) {
        fill(255,0,0);
        textSize(30);
        text(message,400,400);
      }
      text("passed",400,400);
    }*/
  }
  else if(shipsset == false) {    // creates the ships and the enemy ships, however many there are, will only excecute once
    ships[0] = new Ship(int(random(0, 500)), int(random(0, 500)), 0, 0,userColor);
    enemies = new Enemy[numberNPC];
    for(int i = 1; i < numberNPC + 1; i++) {
      enemies[i-1] = new Enemy(int(random(0, 500)), int(random(0, 500)), 0, i,blackbrown);
    }
    shipsset = true;
  }
  else if(unittest == true) {
    if (testDone == false) {
      failureMessage = unitTests();//testMovement();//unitTests();
      testDone = true;
    }
    else {
      if (testsPassed) {
        fill(10,160,10);
      }
      else {
        fill(255,0,0);
      }
      textSize(30);
      text("Unit Testing",100,200);
      textSize(20);
      String nat = "";//Arrays.toString(failureMessage);
      for(int i=0; i<8;i++) {
        nat = failureMessage[i];
        text(nat,20,300 + 30*i);
      }
      //text(nat,100,400);
    }
  }
  else {
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
    ships[0].updateLocation();//move the ships
    line(ships[0].x, ships[0].y, ships[0].x+100*cos(ships[0].aim), ships[0].y+100*sin(ships[0].aim));//draws a line from the ship along the aim angle, 100 pixels in length
    stroke(shipCol);
    for (int i=0; i<enemies.length; i++) {
      enemies[i].updateLocation();
      line(enemies[i].x, enemies[i].y, enemies[i].x+100*cos(enemies[i].aim), enemies[i].y+100*sin(enemies[i].aim));//draws a line from the ship along the aim angle, 100 pixels in length
    }
    fill(mCol);
  //ellipse(mouseX, mouseY, 10, 10);  // this follows the mouse, I commented it out
    clock = clock+1;//increment clock (used for shooting
    shoot(); 
  } //calls shoot
}

void colorChange() {
  if(startColor1Value == 255) {
    startColor1Change = false;
  }
  if(startColor1Value == 0) {
    startColor1Change = true;
  }
  if(startColor1Change) {
    startColor1Value++;
  }
  else {
    startColor1Value--;
  }
  startColor1 = color(startColor1Value,0,0);//startColor1Value,startColor1Value);
}
    

class Ship {
  int shipNum;
  int x;
  int y;
  float aim;
  float npcAng; //the angle from the player to the NPC
  color initCol;
  color col;
  color bulletCol;
  int bMax =100; //here
  int bNum=0;
  int bLife = 6000;
  int bulletNum = 100;
  int timesHit = 0;
  int circle[] = new int[20];       //this is used to store the id values of bullets it has been hit by so that they are not double counted
  int circleInt = 0;     
  Bullet[] bullets = new Bullet[bMax];//each ship owns some bullets
  
  Ship(){} //implicit constructor, neccesary as this is a parent class

  Ship(int initX, int initY, int initAim, int num, color shipColor) {//this is used to create new ships
    shipNum = num;
    x = initX;
    y=initY;
    aim=initAim;
    initCol = shipColor;
    col = shipColor;
    bulletCol = shipColor;

    for (int i=0; i<bullets.length; i++) {//creating a new ship also gives it blank bullets
      bullets[i] = new Bullet(x, y, aim,shipCol,shipNum);
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
      if (bullets[i].lifespan >=0 && bullets[i].lifespan < bLife && bullets[i].currentY < 500) {
        bullets[i].lifespan++;//longer lifespan will cause bullets to be on screen longger
        bullets[i].updateLocation();
        bullets[i].draw();
      }
    }
  }
  void shoot() {
    bullets[bNum] = new Bullet(x, y, aim,bulletCol,shipNum);// x,y, aim make the bullet inherit its path
    bullets[bNum].lifespan =0;//setting to 0 starts the bullet life
    bNum++;//makes the ship not reset the same bullet.
    if (bNum >= bMax) {
      bNum = 0;//end of array loops back
    }
  }
  void checkHit() {
    for (int i=x-4; i<x+5; i++) {
      for(int j=y-4;j<y+5;j++){
        if(bulletValueRange(occupied[i][j])) {                       // if there is a bullet there, applicable to craft
          if(searchValue(occupied[i][j]) == false) {    // and the bullet hasn't been counted yet
            if(shipNum == 0) {
              npcScore++;
            }
            else {
              playerScore++;
            }
            if(circleInt == 19) {                       //circle has 20 spaces, continually replaces the older additions
              circleInt = 0;
            }
            else {
              circleInt++;
            }
            circle[circleInt] = occupied[i][j]; 
          }
          col = color(255,0,0);
          return;
        }
      }
    } 
    col = initCol;
  }
  boolean bulletValueRange(int value) {
    if(shipNum == 0 && value < 0) {
      return true;
    }
    if (shipNum > 0 && value > 1) {
      return true;
    }
    return false;
  }
  boolean searchValue(int value) { //searches through the 20 saved bullets that the player has been hit by
    for(int i = 0; i < circle.length; i++) {
      if(circle[i] == value) {
        return true;
      }
    }
    return false;
  }
  
  /*void shipDestroy(){
    color c = color(0,255,0);
    fill(c);
    ellipse(x, y, 100, 100);
  }*/
  void draw() {//drawing the ship *replace with better graphics*
    fill(col);
    ellipse(x, y, 15, 15);
  }
}

class Enemy extends Ship { //the NPC
  int xmov;  // random directions in which the ship will move
  int ymov;  // 
  color bulletCol = shipCol;
  
  Enemy (int initX, int initY, int initAim, int num, color shipColor) {//this is used to create new ships
    shipNum = num;
    x = initX;
    y=initY;
    aim=initAim;
    initCol = shipColor;
    col = shipColor;
    for (int i=0; i<bullets.length; i++) {//creating a new ship also gives it blank bullets
      bullets[i] = new Bullet(x, y, aim,shipCol,shipNum);
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
    this.checkHit();
    this.draw();
    
    for (int i=0; i<bullets.length; i++) {
      if ((bullets[i].lifespan >=0) && bullets[i].lifespan < bLife && bullets[i].currentY < 500) {//lets you "delete" bullets by setting lifespan to -1
        bullets[i].lifespan++;//longer lifespan will cause bullets to be on screen longger
        bullets[i].updateLocation();
        bullets[i].draw();
      }
    }
  }
  void moveRandom() {
    int xRand = (int)random(0,1500); //will typically keep moving as it's moving, but occasionally will randomly change direction
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
  /*void shipDestroy() {
    color c = color(255,255,255);
    col = c;
    bulletNum = 0;
  }*/
  Vector checkRange(int x, int y) { //this checks whether there are any bullets within 30 spaces of the range x,y
    for (int i=x-15; i<x+16; i++) { //this doesn't currently work
      for(int j=y-15; j<x+16; j++){
        if(occupied[i][j] != 0) {
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
  //boolean dead; //when the bullet goes out of range or hits someone, it's 'dead' and will be deleted
  color bulletColor;
  int bulletID;
  boolean enemy;
  Bullet(int x, int y, float angle, color bulletColor, int shipNum) {
    int number;
    if(shipNum > 0) {
      number = -1;
    }
    else {
      number = 1;
    }
    bulletID = int(random(number,10000*number)); //gives the bullet an ID which is, with high probability, unique compared to nearby bullets
    aim = angle;
    originX = (int)(x + 35*cos(aim));
    originY = (int)(y + 35*sin(aim));
    lifespan = -1;
    this.bulletColor = bulletColor;
    this.enemy = enemy;
  }
  void updateLocation() {
    if(currentX > 0 && currentX < 500 && currentY > 0 && currentY < 500) {
      occupied[currentX][currentY] = 0;     // as the bullet is about to leave this location, it is no longer occupied
    }
    currentX = int(originX+lifespan*cos(aim));
    currentY = int(originY+lifespan*sin(aim));
    if(currentX > 0 && currentX < 500 && currentY > 0 && currentY < 500) {
      occupied[currentX][currentY] = bulletID;      // a bullet is in this location, a ship here will be hit
    }    
  }
  void draw() {
    fill(bulletColor);
    ellipse(currentX, currentY, 5, 5);//pew pew
  }
}

void shoot() {
  isShooting=(((clock % 60)==0));//clock makes all the ships shoot together I set it to make the NPC slow enough to allow the player to evade it's bullets. 
  if (isShooting) {                                                // it might be different on a different computer
    for (int i=0; i<enemies.length; i++) {
      enemies[i].shoot();
    }
    mCol = color(255, 0, 0);//blinks cursor
  } else {
    mCol = color(0, 0, 255);//blinks cursor
  }
}

void mouseClicked() {
  if(gamestart) {
    if(mouseX <= 355 && mouseX >= 315 && mouseY >= 260 && mouseY <= 330) {  //if you clicked on 1
      numberNPC = 1;

    }
    else if(mouseX <= 430 && mouseX >= 390 && mouseY >= 260 && mouseY <= 330) {   // if you clicked on 2
      numberNPC = 2;
    }
    else if(mouseX > 30 && mouseX < 440 && mouseY > 405 && mouseY < 495) {
      color thisColor = get(mouseX,mouseY);
      if(thisColor != color(240) && thisColor != color(0)) {
        userColor = thisColor;
      }
    }
    else if(mouseX > 150 && mouseX < 300 && mouseY > 525 && mouseY < 575) {
      gamestart = false;
    }
  }
  else {
    ships[0].shoot();    //player's ship shoots
  }
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

String[] unitTests() { 
  return testMovement();
}

String[] testMovement() {
  String[] testsResult = {"Y Minus test passed","Y Plus test passed","X Minus test passed","X Plus test passed","Diagnol X minus and Y minus test passed",
                "Diagnol X plus and Y minus test passed","Diagnol X minus and Y plus test passed","Diagnol X plus and Y plus test passed"};
  for(int i = 0; i < 5000; i++) {
    int firstRand = int(random(1,9));
    if(firstRand == 1) {
      int randNum = int(random(1,25));
      if(!testYminus(randNum)) {
        testsResult[0] = "failed Y minus test";
        testsPassed = false;
      }
    }
    else if(firstRand == 2) {
      int randNum = int(random(1,25));
      if(!testYplus(randNum)) {
        testsResult[1] = "failed Y plus test";
        testsPassed = false;
      }
    }
    else if(firstRand == 3) {
      int randNum = int(random(1,25));
      if(!testXminus(randNum)) {
        testsResult[2] = "failed X minus test";
        testsPassed = false;
      }
    }
    else if(firstRand == 4) {
      int randNum = int(random(1,25));
      if(!testXplus(randNum)) {
        testsResult[3] = "failed X plus test";
        testsPassed = false;
      }
    }
    else if(firstRand == 5) {
      int randNum = int(random(1,25));
      if(!testDiagxMyM(randNum)) {
        testsResult[4] = "failed Diagnol X minus and Y minus test";
        testsPassed = false;
      }
    }
    else if(firstRand == 6) {
      int randNum = int(random(1,25));
      if(!testDiagxPyM(randNum)) {
        testsResult[5] = "failed Diagnol X plus and Y minus test";
        testsPassed = false;
      }
    }
    else if(firstRand == 7) {
      int randNum = int(random(1,25));
      if(!testDiagxMyP(randNum)) {
        testsResult[6] = "failed Diagnol X minus and Y plus test";
        testsPassed = false;
      }
    }
    else if(firstRand == 8) {
      int randNum = int(random(1,25));
      if(!testDiagxPyP(randNum)) {
        testsResult[7] = "failed Diagnol X plus and Y plus test";
        testsPassed = false;
      }
    }
  }
  return testsResult;
}

boolean testYminus(int times) {
  for(int i = 0; i < times; i++) {
    int init = ships[0].y;
    keys[0] = true;
    ships[0].updateLocation();
    keys[0] = false;
    if(ships[0].y >= init && init > 10) { //if it moved in the wrong direction or did not move
      return false;
    }
  }
  return true;
}

boolean testYplus(int times) {
  for(int i = 0; i < times; i++) {
    int init = ships[0].y;
    keys[2] = true;
    ships[0].updateLocation();
    keys[2] = false;
    if(ships[0].y <= init && init < 490) { //if it moved in the wrong direction or did not move
      return false;
    }
  }
  return true;
}

boolean testXminus(int times) {
  for(int i = 0; i < times; i++) {
    int init = ships[0].x;
    keys[1] = true;
    ships[0].updateLocation();
    keys[1] = false;
    if(ships[0].x >= init && init > 10) { //if it moved in the wrong direction or did not move
      return false;
    }
  }
  return true;
}

boolean testXplus(int times) {
  for(int i = 0; i < times; i++) {
    int init = ships[0].x;
    keys[3] = true;
    ships[0].updateLocation();
    keys[3] = false;
    if(ships[0].x <= init && init < 490) { //if it moved in the wrong direction or did not move
      return false;
    }
  }
  return true;
}

boolean testDiagxMyM(int times) {   //simulates pressing two keys at once
  for(int i = 0; i < times; i++) {
    int initX = ships[0].x;
    int initY = ships[0].y;
    keys[0] = true;
    keys[1] = true;
    ships[0].updateLocation();
    keys[0] = false;
    keys[1] = false;
    if((ships[0].x >= initX && initX > 10) || (ships[0].y >= initY && initY > 10)) { //if it moved in the wrong direction or did not move
      return false;
    }
  }
  return true;
}

boolean testDiagxPyM(int times) {   //simulates pressing two keys at once
  for(int i = 0; i < times; i++) {
    int initX = ships[0].x;
    int initY = ships[0].y;
    keys[0] = true;
    keys[3] = true;
    ships[0].updateLocation();
    keys[0] = false;
    keys[3] = false;
    if((ships[0].x <= initX && initX < 490) || (ships[0].y >= initY && initY > 10)) { //if it moved in the wrong direction or did not move
      return false;
    }
  }
  return true;
}

boolean testDiagxMyP(int times) {   //simulates pressing two keys at once
  for(int i = 0; i < times; i++) {
    int initX = ships[0].x;
    int initY = ships[0].y;
    keys[2] = true;
    keys[1] = true;
    ships[0].updateLocation();
    keys[2] = false;
    keys[1] = false;
    if((ships[0].x >= initX && initX > 10) || (ships[0].y <= initY && initY < 490)) { //if it moved in the wrong direction or did not move
      return false;
    }
  }
  return true;
}

boolean testDiagxPyP(int times) {   //simulates pressing two keys at once
  for(int i = 0; i < times; i++) {
    int initX = ships[0].x;
    int initY = ships[0].y;
    keys[2] = true;
    keys[3] = true;
    ships[0].updateLocation();
    keys[2] = false;
    keys[3] = false;
    if((ships[0].x <= initX && initX < 490) || (ships[0].y <= initY && initY < 490)) { //if it moved in the wrong direction or did not move
      return false;
    }
  }
  return true;
}
