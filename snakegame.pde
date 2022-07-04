import java.util.ArrayDeque;  //<>//
import java.util.Queue;

PFont japaneseFont;

//座標
PVector headOfSnake;
PVector item;
Queue<PVector> snakeData=new ArrayDeque();
float speedX, speedY;
float headX, headY;

//ヘビの状態
float sizeOfRect;
int lengthOfSnake;

//ゲームの状態
Boolean gameFlag;

void setup() {
  size(400, 400);

  initialize();
  frameRate(2);
  japaneseFont = createFont("Yu Gothic UI", 64);

  //メインメニュー
  noLoop();
  gameFlag = false;
  background(0);
  textAlign(CENTER, CENTER);
  textSize(64);
  textFont(japaneseFont);
  text("ヘビゲーム", 200, 150);
  textSize(36);
  text("Press to Start", 200, 250);
}

void draw() {
  if (gameFlag == true) {
    loop();
    if (key == CODED) {
      controller();
    } 

    eatItem();
    checkCollide();
    updateSnakeData();
    renderRect();
  }
}

//ヘビとアイテムを描く
void renderRect() {
  if (gameFlag == true) {
    background(0);
    PVector[] vector=new PVector[snakeData.size()];
    snakeData.toArray(vector);

    for (int i=0; i<vector.length; i++) {
      if (vector[i] != null) {
        rect(vector[i].x, vector[i].y, sizeOfRect, sizeOfRect);
      }
    }

    if (item != null) {
      rect(item.x, item.y, sizeOfRect, sizeOfRect);
    }
  }
}

//ヘビのデータを初期化する
void initialize() {
  snakeData.removeAll(snakeData);

  background(0);

  lengthOfSnake=3;
  sizeOfRect=20.0;
  headX = 0.0;
  headY = 0.0;
  speedX = 1.0;
  speedY = 0.0;

  for (int i=0; i<lengthOfSnake; i++) {
    headX=headX+speedX*sizeOfRect;
    headY=headY+speedY*sizeOfRect;
    headOfSnake = new PVector(headX, headY);
    snakeData.add(headOfSnake);
  }

  createItems();
}

//Queueでヘビのデータを更新する
void updateSnakeData() {
  if (gameFlag == true) {
    headX=headX+speedX*sizeOfRect;
    headY=headY+speedY*sizeOfRect;
    headOfSnake = new PVector(headX, headY);
    snakeData.add(headOfSnake);
    snakeData.poll();
    //println(snakeData);
  }
}

//ヘビの頭の進行方向をコントロールする
void controller() {
  if (speedY != 1.0 && keyCode == UP) {
    speedX = 0.0;
    speedY = -1.0;
  }
  if (speedY != -1.0 && keyCode == DOWN) {
    speedX = 0.0;
    speedY = 1.0;
  }
  if (speedX != -1.0 && keyCode == RIGHT) {
    speedX = 1.0;
    speedY = 0.0;
  }
  if (speedX != 1.0 && keyCode == LEFT) {
    speedX = -1.0;
    speedY = 0.0;
  }
}

//アイテムを作る
void createItems() {
  PVector[] vector=new PVector[snakeData.size()];
  snakeData.toArray(vector);
  if (item == null) {
    //ヘビ以外のところでアイテムを置く
    item = new PVector(round(random(19))*sizeOfRect, round(random(19))*sizeOfRect);
    for (int i=0; i<vector.length; i++) {
      if (vector[i] == item ) {
        createItems();
      }
    }
  }
}

//アイテムを回収する
void eatItem() {
  if (gameFlag == true) {
    //右のアイテムを回収する
    if (item.x - headX == sizeOfRect && item.y - headY == 0.0 && speedX == 1.0) {
      headOfSnake = item;
      snakeData.add(headOfSnake);
      item = null;
      createItems();
      renderRect();
    }

    //左のアイテムを回収する
    if (item.x - headX == -sizeOfRect && item.y - headY == 0.0 && speedX == -1.0) {
      headOfSnake = item;
      snakeData.add(headOfSnake);
      item = null;
      createItems();
      renderRect();
    }

    //下のアイテムを回収する
    if (item.y - headY == sizeOfRect && item.x - headX == 0.0 && speedY == 1.0) {
      headOfSnake = item;
      snakeData.add(headOfSnake);
      item = null;
      createItems();
      renderRect();
    }

    //上のアイテムを回収する
    if (item.y - headY == -sizeOfRect && item.x - headX == 0.0 && speedY == -1.0) {
      headOfSnake = item;
      snakeData.add(headOfSnake);
      item = null;
      createItems();
      renderRect();
    }
  }
}

//ぶつかることを検査する
void checkCollide() {
  if (gameFlag == true) {
    //ヘビの頭が体にぶつかる場合
    PVector[] vector=new PVector[snakeData.size()];
    snakeData.toArray(vector);
    for (int i=0; i<vector.length-1; i++) {
      if (vector[i].x-headX == sizeOfRect && vector[i].y-headY == 0.0 && speedX == 1.0) {
        gameOver();
      }
      if (vector[i].x-headX == -sizeOfRect && vector[i].y-headY == 0.0 && speedX == -1.0) {
        gameOver();
      }      
      if (vector[i].y-headY == sizeOfRect && vector[i].x-headX == 0.0 && speedY == 1.0) {
        gameOver();
      }     
      if (vector[i].y-headY == -sizeOfRect && vector[i].x-headX == 0.0 && speedY == -1.0) {
        gameOver();
      }
    }
  }

  //ヘビの頭が壁にぶつかる場合
  //右の壁にぶつかる
  if (headX-width == -sizeOfRect && speedX == 1.0) {
    gameOver();
  }
  //左の壁にぶつかる
  if (headX == 0.0 && speedX == -1.0) {
    gameOver();
  }
  //下の壁にぶつかる
  if (headY-height == -sizeOfRect && speedY == 1.0) {
    gameOver();
  }
  //上の壁にぶつかる
  if (headY == 0.0 && speedY == -1.0) {
    gameOver();
  }
}

//ゲームをスタート・リスタート
void keyPressed() {
  if (gameFlag == false) {
    gameFlag = true;
    loop();
    initialize();
  }
}

//ゲームオーバーの表示
void gameOver() {
  noLoop();
  gameFlag = false;
  background(0);
  textAlign(CENTER, CENTER);
  textSize(64);
  text("GAME OVER", 200, 150);
  textSize(36);
  text("Press to Restart", 200, 250);
}
