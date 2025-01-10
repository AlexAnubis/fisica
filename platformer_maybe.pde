import fisica.*;
FWorld world;

// COLOR PALLETE
color white = #FFFFFF;
color black = #000000;
color green = #00FF00;
color red = #FF0000;
color blue = #0000FF;
color orange = #F0A000;
color brown = #996633;

// FLOOR COLOR
color stoneFloor = #969696;
color invisBarrier = #6f3198;
color grassFloor = #34a834;
color dirtFloor = #9e6a42;
color bridgeFloor = #800080;
color spikeFloor = #ff1493;
color wallRed = #ff0000;
color goombac = #ffa200;

// Teleporter Color
color tps1 = #ff00ff;
color tps1s2 = #00bfff;

// Floor PImages
PImage stone, grass, dirt, spike, bridge, invisiBarrier;

// Map Images
PImage backgr, spawn, stage1, stage2;

// Teleporter PImages
PImage portals1;
PImage S1returnToLobby;

// MAIN CHARACTER ANIMATIONS
PImage[] idle;
PImage[] jump;
PImage[] run;
PImage[] action;

// Zombie Animation
PImage[] goomba;

int gridSize = 32;
float scale = 1.5;

// Key Booleans
boolean wkey, akey, dkey, spaceBar;

FPlayer player;
ArrayList<FGameObject> terrain;
ArrayList<FGameObject> enemies;

void setup() {
  size(600, 600);
  Fisica.init(this);
  backgr = loadImage("background1.png");
  backgr.resize(1100, height);

  // Asset Loader \\
  // Map Textures
  spawn = loadImage("spawn.png");
  stage1 = loadImage("stage1up.png");
  stage2 = loadImage("stage2.png");

  // Terrain Textures
  stone = loadImage("brick.png");
  grass = loadImage("dirt_n.png");
  dirt = loadImage("dirt_center.png");
  spike = loadImage("spike.png");
  bridge = loadImage("bridge_center.png");
  invisiBarrier = loadImage("invisible_barrier.png");

  // Teleporter Asset Loader
  portals1 = loadImage("pipe.png");
  S1returnToLobby = loadImage("pipe.png");

  // CHARACTER IMAGE LOADER
  idle = new PImage[2];
  idle[0] = loadImage("idle0.png");
  idle[1] = loadImage("idle1.png");

  jump = new PImage[2];
  jump[0] = loadImage("yveltal1.png");
  jump[1] = loadImage("yveltal2.png");

  run = new PImage[2];
  run[0] = loadImage("yveltal1.png");
  run[1] = loadImage("yveltal2.png");
  // run[2] = loadImage("runright1.png");


  action = idle;

  // ZOOMBIE IMAGE LOADER
  goomba = new PImage[2];
  goomba[0] = loadImage("goomba0.png");
  goomba[0].resize(gridSize, gridSize);
  goomba[1] = loadImage("goomba1.png");
  goomba[1].resize(gridSize, gridSize);


  //PImage pic = loadImage("goomba0.png");
  //reverseImage(pic).save("goomba1.png");

  terrain = new ArrayList<FGameObject>();
  enemies = new ArrayList<FGameObject>();

  // MAP LOADER
  loadWorld(stage1);

  loadPlayer();
}

void loadWorld(PImage img) {
  world = new FWorld(-20000, -20000, 20000, 20000);
  world.setGravity(0, 900);

  //spawn
  for (int y = 0; y < img.height; y++) {
    for (int x = 0; x < img.width; x++) {
      color c = img.get(x, y);
      FBox b = new FBox(gridSize, gridSize);
      b.setPosition(x*gridSize, y*gridSize);
      b.setStatic(true);
      b.setGrabbable(false);

      // STONE FLOOR
      if (c == stoneFloor || c == black) {
        b.attachImage(stone);
        b.setName("stone");
        b.setFriction(4);
        world.add(b);
      }

      if (c == grassFloor) {
        b.attachImage(grass);
        b.setName("grass");
        b.setFriction(4);
        world.add(b);
      }

      if (c == invisBarrier) {
        b.attachImage(invisiBarrier);
        b.setName("invisBarrier");
        b.setFriction(4);
        world.add(b);
      }

      if (c == dirtFloor) {
        b.attachImage(dirt);
        b.setName("dirt");
        b.setFriction(4);
        world.add(b);
      }

      if (c == wallRed) {
        b.attachImage(grass);
        b.setName("wall");
        world.add(b);
      }
      if (c == spikeFloor) {
        b.attachImage(spike);
        b.setName("spike");
        b.setFriction(4);
        world.add(b);
      }

      // ZOMBIES
      if (c == goombac) {
        FGoomba gmb = new FGoomba(x*gridSize, y*gridSize);
        enemies.add(gmb);
        world.add(gmb);
      }
    }
  }

  //stage1
  //for (int y = 0; y < stage1.height; y++) {
  //  for (int x = 0; x < stage1.width; x++) {
  //    color c = img.get(x, y);
  //    FBox b = new FBox(gridSize, gridSize);
  //    b.setPosition(x*gridSize, y*gridSize);
  //    b.setStatic(true);
  //    b.setGrabbable(false);

  //    if (c == grassFloor) {
  //      b.attachImage(grass);
  //      b.setName("grass");
  //      b.setFriction(4);
  //      world.add(b);
  //    }

  //    if (c == stoneFloor) {
  //      b.attachImage(stone);
  //      b.setName("stone");
  //      b.setFriction(4);
  //      world.add(b);
  //    }

  //    if (c == dirtFloor) {
  //      b.attachImage(dirt);
  //      b.setName("dirt");
  //      b.setFriction(4);
  //      world.add(b);
  //    }

  //    if (c == tps1) {
  //      b.attachImage(portals1);
  //      b.setName("teleportToStage1");
  //      b.setFriction(4);
  //      world.add(b);
  //    }
  //    if (c == goombac) {
  //      FGoomba gmb = new FGoomba(x*gridSize, y*gridSize);
  //      enemies.add(gmb);
  //      world.add(gmb);
  //    }
  //  }
  //}

  //// GAME MAP 1 ===================================================
  //for (int y = 0; y < stage2.height; y++) {
  //  for (int x = 0; x < stage2.width; x++) {
  //    color c = img.get(x, y);
  //    FBox b = new FBox(gridSize, gridSize);
  //    b.setPosition(x*gridSize, y*gridSize);
  //    b.setStatic(true);
  //    b.setGrabbable(false);

  //    if (c == spikeFloor) {
  //      b.attachImage(spike);
  //      b.setName("spike");
  //      b.setFriction(4);
  //      world.add(b);
  //    }

  //    if (c == bridgeFloor) {
  //      FBridge br = new FBridge(x*gridSize, y*gridSize);
  //      terrain.add(br);
  //      world.add(br);
  //    }

  //    if (c == tps1) {
  //      b.attachImage(S1returnToLobby);
  //      b.setName("S1returnToLobby");
  //      b.setFriction(4);
  //      world.add(b);
  //    }

  //    // Wall
  //    if (c == wallRed) {
  //      b.attachImage(grass);
  //      b.setName("wall");
  //      world.add(b);
  //    }
  //  }
  //}
}

void loadPlayer() {
  player = new FPlayer();
  player.setPosition(180, 60);
  world.add(player);
}

void draw() {
  background(120, 167, 255);
  image(backgr, 0, 0);
  drawWorld();
  actWorld();
}

void actWorld() {
  player.act();
  for (int i = 0; i < terrain.size(); i++) {
    FGameObject t = terrain.get(i);
    t.act();
  }
  for (int i = 0; i < enemies.size(); i++) {
    FGameObject e = enemies.get(i);
    e.act();
  }
}

void drawWorld() {

  pushMatrix();
  translate(-player.getX()*scale+width/2, -player.getY()*scale+height/2);
  scale(scale);
  world.step();
  world.draw();
  popMatrix();
}
