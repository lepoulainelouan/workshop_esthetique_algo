int gridSize = 20;
int cols, rows;

ArrayList<PVector> snake;
ArrayList<Fourmi> fourmies;

float segLength = 18;
float speed = 4;

PVector apple;
PVector powerUp;
boolean gameOver = false;

int niveau = 1;

boolean bonusActive = false;
int bonusTimer = 0;
int bonusDuration = 300; // 5s à 60fps

int powerUpTimer = 20; // timer avant réapparition du bonus
int powerUpCooldown = 600; 

int margin; 
void setup() {
  pixelDensity(1);
  size(1600, 800);
  strokeWeight(9);
  noFill();

  margin = gridSize; 

  cols = width / gridSize;
  rows = height / gridSize;

  snake = new ArrayList<PVector>();
  snake.add(new PVector(width/2, height/2));

  fourmies = new ArrayList<Fourmi>();
  fourmies.add(new Fourmi(niveau));

  spawnApple();
  spawnPowerUp();
}

void draw() {
  background(0);

  if (gameOver) {
    drawGameOver();
    return;
  }

  moveHead();
  followSegments();
  drawSnake();

  //update fourmies
  for (int i = fourmies.size()-1; i>=0; i--) {
    Fourmi f = fourmies.get(i);
    f.update();
    f.display();

    if (bonusActive) {
      boolean killed = false;
      for (PVector seg : snake) {
        if (PVector.dist(seg, f.body.get(0)) < segLength*0.6) {
          fourmies.remove(i);
          killed = true;
          break;
        }
      }
      if (killed) continue;
    } else {
      if (f.checkCollision(snake.get(0))) gameOver = true;
    }
  }

  drawApple();
  checkApple();

  drawPowerUp();
  checkPowerUp();

  // timer bonus
  if (bonusActive) {
    bonusTimer--;
    if (bonusTimer <= 0) bonusActive = false;
  }

  // timer bonus cooldown
  if (powerUp == null) {
    powerUpTimer--;
    if (powerUpTimer <= 0) spawnPowerUp();
  }

  drawHUD();
}

// SERPENT
void moveHead() {
  PVector head = snake.get(0);
  PVector target = new PVector(mouseX, mouseY);
  PVector dir = PVector.sub(target, head);
  if (dir.mag() > speed) dir.setMag(speed);
  head.add(dir);
}

void followSegments() {
  for (int i = 1; i < snake.size(); i++) {
    PVector prev = snake.get(i - 1);
    PVector cur = snake.get(i);
    PVector d = PVector.sub(prev, cur);
    float dist = d.mag();
    if (dist > segLength) {
      d.setMag(dist - segLength);
      cur.add(d);
    }
  }
}

void drawSnake() {
  if (bonusActive) stroke(200, 255, 50);
  else stroke(#3A6F43);

  for (int i = 0; i < snake.size() - 1; i++) {
    PVector a = snake.get(i);
    PVector b = snake.get(i + 1);
    line(a.x, a.y, b.x, b.y);
  }

  drawSnakeEyes();
}

void drawSnakeEyes() {
  PVector head = snake.get(0);
  PVector forward = PVector.sub(new PVector(mouseX, mouseY), head).normalize();
  PVector side = new PVector(-forward.y, forward.x);

  float eyeOffset = 6;
  float eyeSize = 8;

  PVector leftEye = PVector.add(head, PVector.add(forward.copy().mult(4), side.copy().mult(-eyeOffset)));
  PVector rightEye = PVector.add(head, PVector.add(forward.copy().mult(4), side.copy().mult(eyeOffset)));

  fill(255);
  noStroke();
  ellipse(leftEye.x, leftEye.y, eyeSize, eyeSize);
  ellipse(rightEye.x, rightEye.y, eyeSize, eyeSize);

  fill(0);
  ellipse(leftEye.x + forward.x*2, leftEye.y + forward.y*2, 4, 4);
  ellipse(rightEye.x + forward.x*2, rightEye.y + forward.y*2, 4, 4);
}

// POMME
void spawnApple() {
  int x = int(random(margin, width - margin));
  int y = int(random(margin, height - margin));
  apple = new PVector(x, y);
}

void drawApple() {
  fill(255, 50, 50);
  noStroke();
  ellipse(apple.x, apple.y, gridSize * 0.8, gridSize * 0.8);
  noFill();
}

void checkApple() {
  if (PVector.dist(snake.get(0), apple) < gridSize) {
    growSnake();
    levelUp();
    spawnApple();
  }
}

void growSnake() {
  snake.add(snake.get(snake.size() - 1).copy());
}

// BONUS PUISSANCE
void spawnPowerUp() {
  int x = int(random(margin, width - margin));
  int y = int(random(margin, height - margin));
  powerUp = new PVector(x, y);
  powerUpTimer = powerUpCooldown;
}

void drawPowerUp() {
  if (powerUp == null) return;
  noStroke();
  fill(color(random(255), random(255), random(255)));
  ellipse(powerUp.x, powerUp.y, gridSize * 0.8, gridSize * 0.8);
  noFill();
}

void checkPowerUp() {
  if (powerUp != null && PVector.dist(snake.get(0), powerUp) < gridSize) {
    bonusActive = true;
    bonusTimer = bonusDuration;
    powerUp = null;
  }
}

// LVL
void levelUp() {
  niveau++;
  if (niveau % 3 == 0) fourmies.add(new Fourmi(niveau));
  for (Fourmi f : fourmies) f.upgrade(niveau);
}

// FOURMIES
enum FourmiType { ERRANTE, CHASSEUSE }

class Fourmi {
  ArrayList<PVector> body;
  PVector dir;
  float speed;
  FourmiType type;
  float baseSpeed;
  float chaseRadius;

  Fourmi(int lvl) {
    body = new ArrayList<PVector>();
    PVector start = new PVector(random(margin, width - margin), random(margin, height - margin));
    body.add(start);

    int length = 5 + lvl * 2;
    for (int i = 1; i < length; i++) body.add(start.copy());

    dir = PVector.random2D();

    if (random(1) < 0.5) type = FourmiType.ERRANTE;
    else type = FourmiType.CHASSEUSE;

    if (type == FourmiType.CHASSEUSE) {
      baseSpeed = 0.7;
      chaseRadius = gridSize * 20; // 20 cases
    } else baseSpeed = 1.5 + lvl * 0.3;

    speed = baseSpeed;
  }

  void upgrade(int lvl) {
    if (type != FourmiType.CHASSEUSE) baseSpeed = 1.5 + lvl * 0.3;
    else baseSpeed += 0.05;
    speed = baseSpeed;

    while (body.size() < 5 + lvl * 2) body.add(body.get(body.size() - 1).copy());
  }

  void update() {
    PVector head = body.get(0);

    if (type == FourmiType.ERRANTE) {
      dir.rotate(random(-0.15, 0.15));
    } else if (type == FourmiType.CHASSEUSE) {
      float distToSnake = PVector.dist(head, snake.get(0));
      if (distToSnake < chaseRadius) {
        dir = PVector.sub(snake.get(0), head).normalize();
      } else {
        dir.rotate(random(-0.15, 0.15)); // comportement comme une jaune
      }
    }

    dir.setMag(speed);
    head.add(dir);

    if (head.x < margin) { head.x = margin; dir.x = abs(dir.x); }
    if (head.x > width - margin) { head.x = width - margin; dir.x = -abs(dir.x); }
    if (head.y < margin) { head.y = margin; dir.y = abs(dir.y); }
    if (head.y > height - margin) { head.y = height - margin; dir.y = -abs(dir.y); }

    for (int i = 1; i < body.size(); i++) {
      PVector prev = body.get(i - 1);
      PVector cur = body.get(i);
      PVector d = PVector.sub(prev, cur);
      if (d.mag() > segLength) {
        d.setMag(d.mag() - segLength);
        cur.add(d);
      }
    }
  }

  void display() {
    if (type == FourmiType.ERRANTE) stroke(255, 200, 50);
    if (type == FourmiType.CHASSEUSE) stroke(255, 60, 60);

    for (int i = 0; i < body.size() - 1; i++) {
      PVector a = body.get(i);
      PVector b = body.get(i + 1);
      line(a.x, a.y, b.x, b.y);
    }
    drawEyes();
  }

  void drawEyes() {
    PVector h = body.get(0);
    PVector forward = dir.copy().normalize();
    PVector side = new PVector(-forward.y, forward.x);

    float eyeOffset = 6;
    float eyeSize = 6;

    PVector leftEye = PVector.add(h, PVector.add(forward.copy().mult(4), side.copy().mult(-eyeOffset)));
    PVector rightEye = PVector.add(h, PVector.add(forward.copy().mult(4), side.copy().mult(eyeOffset)));

    fill(255);
    noStroke();
    ellipse(leftEye.x, leftEye.y, eyeSize, eyeSize);
    ellipse(rightEye.x, rightEye.y, eyeSize, eyeSize);

    fill(0);
    ellipse(leftEye.x + forward.x*2, leftEye.y + forward.y*2, 3, 3);
    ellipse(rightEye.x + forward.x*2, rightEye.y + forward.y*2, 3, 3);
  }

  boolean checkCollision(PVector head) {
    for (PVector p : body) {
      if (PVector.dist(head, p) < segLength * 0.6) return true;
    }
    return false;
  }
}

// HUD
void drawHUD() {
  fill(255);
  textSize(14);
  text("Niveau : " + niveau, 10, 20);
  text("Fourmies : " + fourmies.size(), 10, 40);
  if (bonusActive) text("Bonus actif !", 10, 60);
  noFill();
}

// GAME OVER
void drawGameOver() {
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(32);
  text("GAME OVER", width/2, height/2);
  textSize(16);
  text("Niveau atteint : " + niveau, width/2, height/2 + 40);
}
