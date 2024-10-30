import fisica.*;

FWorld world;
FCircle ball;
FBox hoopBackboard;
FCircle hoopNet;
boolean isDragging = false;
float dragStartX, dragStartY;
int leftScore = 0, rightScore = 0;
boolean basketOnLeft = false;
boolean ballLaunchedFromLeft = true;

void setup() {
  size(800, 600);
  Fisica.init(this);
  
  world = new FWorld();
  world.setGravity(0, 500);

  ball = new FCircle(20);
  ball.setPosition(200, 300);
  ball.setRestitution(0.6);
  ball.setFriction(0.3);
  ball.setFill(255, 165, 0); // Orange color for basketball
  world.add(ball);

  FBox floor = new FBox(width, 10);
  floor.setPosition(width / 2, height);
  floor.setStatic(true);
  floor.setFill(150, 75, 0); // Brown floor
  world.add(floor);

  createHoop(basketOnLeft);
}

void draw() {
  background(135, 206, 235); // Sky blue
  world.step();
  world.draw();
  checkScore();
  drawScore();
  
  if (isDragging) {
    stroke(255, 0, 0);
    line(dragStartX, dragStartY, mouseX, mouseY); // Visual indicator for drag direction
    noStroke();
  }
}

void mousePressed() {
  float distance = dist(mouseX, mouseY, ball.getX(), ball.getY());

  if (distance < 30 && mouseX < width / 2) {
    isDragging = true;
    dragStartX = mouseX;
    dragStartY = mouseY;
    ballLaunchedFromLeft = true;
  } else if (distance < 30 && mouseX >= width / 2) {
    isDragging = true;
    dragStartX = mouseX;
    dragStartY = mouseY;
    ballLaunchedFromLeft = false;
  }
}

void mouseReleased() {
  if (isDragging) {
    float forceX = (dragStartX - mouseX) * 5;
    float forceY = (dragStartY - mouseY) * 5;

    ball.setVelocity(0, 0);
    ball.addImpulse(forceX, forceY);
    isDragging = false;
  }
}

void checkScore() {
  if (basketOnLeft && ball.getX() > 70 && ball.getX() < 130 && ball.getY() > 390 && ball.getY() < 410) {
    if (ballLaunchedFromLeft) {
      leftScore++;
    } else {
      rightScore++;
    }
    resetBall();
    moveHoop();
  } else if (!basketOnLeft && ball.getX() > 670 && ball.getX() < 730 && ball.getY() > 390 && ball.getY() < 410) {
    if (ballLaunchedFromLeft) {
      leftScore++;
    } else {
      rightScore++;
    }
    resetBall();
    moveHoop();
  }
}

void createHoop(boolean onLeft) {
  if (hoopBackboard != null) {
    world.remove(hoopBackboard);
    world.remove(hoopNet);
  }
  
  if (onLeft) {
    hoopBackboard = new FBox(10, 100);
    hoopBackboard.setPosition(100, 400);
    hoopBackboard.setStatic(true);
    hoopBackboard.setFill(100, 100, 100);
    world.add(hoopBackboard);

    hoopNet = new FCircle(20);
    hoopNet.setPosition(130, 430);
    hoopNet.setStatic(true);
    hoopNet.setFill(255, 0, 0, 0); // Transparent center
    hoopNet.setStroke(255, 0, 0); // Red outline for net
    hoopNet.setStrokeWeight(3);
    world.add(hoopNet);
  } else {
    hoopBackboard = new FBox(10, 100);
    hoopBackboard.setPosition(700, 400);
    hoopBackboard.setStatic(true);
    hoopBackboard.setFill(100, 100, 100);
    world.add(hoopBackboard);

    hoopNet = new FCircle(20);
    hoopNet.setPosition(670, 430);
    hoopNet.setStatic(true);
    hoopNet.setFill(255, 0, 0, 0); // Transparent center
    hoopNet.setStroke(255, 0, 0); // Red outline for net
    hoopNet.setStrokeWeight(3);
    world.add(hoopNet);
  }
}

void resetBall() {
  ball.setPosition(200, 300);
  ball.setVelocity(0, 0);
}

void moveHoop() {
  basketOnLeft = !basketOnLeft;
  createHoop(basketOnLeft);
}

void drawScore() {
  fill(255);
  textSize(32);
  text("Left Score: " + leftScore, 50, 50);
  text("Right Score: " + rightScore, width - 200, 50);
}
