color shipCol = color(255); //default color is white
color mCol = color(255, 0, 0);
int x=250;
int y=250;
int clock=0;
boolean isShooting=false;
boolean[] keys = {false, false, false, false};//w,a,s,d
float aimAngle = 0;

Ship[] ships = new Ship[3];
void settings() {
}
void setup() {
  for (int i=0; i<ships.length; i++) {
    ships[i] = new Ship(int(random(0,500)),int(random(0,500)), 0);
  }

  size(500, 500);
  frameRate(60);
  background(5);
}

void draw() {
  background(5);
  for (int i=0; i<ships.length; i++) {
    ships[i].updateLocation();
    stroke(shipCol);
    line(ships[i].x, ships[i].y, ships[i].x+100*cos(ships[i].aim), ships[i].y+100*sin(ships[i].aim));
  }
  fill(mCol);
  ellipse(mouseX, mouseY, 10, 10);

  clock = clock+1;
  shoot();
}

class Ship {
  int x;
  int y;
  float aim;
  color col;
  int bMax =60;
  int bNum=0;
  int bLife = 6000;
  Bullet[] bullets = new Bullet[bMax];

  Ship(int initX, int initY, int initAim) {
    x = initX;
    y=initY;
    aim=initAim;
    col = color(random(0, 255), random(0, 255), random(0, 255));

    for (int i=0; i<bullets.length; i++) {
      bullets[i] = new Bullet(x, y, aim);
    }
  }
  void updateLocation() {
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

    if (mouseX != x) {
      aim =(atan(float(( mouseY-y)/( mouseX-x))));
    } else {
      aim =(atan(float(( mouseY-y)/( mouseX+1-x))));
    }
    if (mouseX < x) {
      aim=aim+PI;
    }
    this.draw();

    for (int i=0; i<bullets.length; i++) {
      if ((bullets[i].lifespan >=0) && (bullets[i].lifespan < bLife)) {
        bullets[i].lifespan++;
        bullets[i].draw();
      }
    }
  }
  void shoot(){
    bullets[bNum] = new Bullet(x,y,aim);
    bullets[bNum].lifespan =0;
    bNum++;
    if (bNum >= bMax){
      bNum = 0;
    }
  }
  void draw() {
    fill(col);
    ellipse(x, y, 15, 15);
  }
}

class Bullet {
  int originX;
  int originY;
  float aim;
  int lifespan;
  Bullet(int x, int y, float angle) {
    originX = x;
    originY = y;
    aim = angle;
    lifespan = -1;
  }
  void draw() {
    ellipse(originX+lifespan*cos(aim), originY+lifespan*sin(aim), 5, 5);
  }
}





void shoot() {

  isShooting=(((clock % 20)>=0)&&((clock % 20)<=5));
  if (isShooting) {
    for (int i=0; i<ships.length; i++) {
      ships[i].shoot();
    }
    mCol = color(255, 0, 0);
  } else {
    mCol = color(0, 0, 255);
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