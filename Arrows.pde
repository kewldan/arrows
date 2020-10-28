public ArrayList<Block> blocks;
public final int wx = 32;
PImage wireUP, wireUP1, wireRIGHT, wireRIGHT1, wireDOWN, wireDOWN1, wireLEFT, wireLEFT1;
PImage not, and, all;
Rotate myRot = Rotate.UP;
Type myType = Type.WIRE;
int mms = 0;
String msm = "";
char waitKey = '.';

void settings() {
  if (min(displayHeight, displayWidth) < 1024) {
    fullScreen(P2D);
  } else {
    size(1024, 1024, P2D);
  }
}
void setup() {
  noFill();
  stroke(0);
  textSize(32);
  textAlign(CENTER, CENTER);
  blocks = new ArrayList<Block>();
  loadTex();
}

void draw() {
  int jf = millis();
  background(255);
  for (int x = 0; x < wx*(max(width, height)/wx); x++) {
    line(x*wx, 0, x*wx, height);
    line(0, x*wx, width, x*wx);
  }

  for (int i = 0; i < blocks.size(); i++) {
    Block a = (Block) blocks.get(i);
    a.tick();
    a.view();
  }
  fill(89, 166, 215);
  text(myType.name, 150, 50);
  text(myRot.name, width-150, 50);
  noFill();
  //text(millis() - jf, width/2, 50);
  if (millis() < mms) {
    if (mms - millis() < 300) {
      fill(89, 166, 215, map(mms - millis(), 0, 300, 0, 255));
    }
    text(msm, width/2, 50);
  }
}

public boolean hasBlock(int x, int y) {
  for (int i = 0; i < blocks.size(); i++) {
    if (blocks.get(i).x == x && blocks.get(i).y == y) {
      return true;
    }
  }
  return false;
}

public Block getBlock(int x, int y) {
  for (int i = 0; i < blocks.size(); i++) {
    if (blocks.get(i).x == x && blocks.get(i).y == y) {
      return blocks.get(i);
    }
  }
  return null;
}

public int getBlockIndex(int x, int y) {
  for (int i = 0; i < blocks.size(); i++) {
    if (blocks.get(i).x == x && blocks.get(i).y == y) {
      return i;
    }
  }
  return 0;
}

void addBlock(Rotate r1, Type t1, int x1, int y1, boolean mouse) {
  if (x1 < 0 || y1 < 0) {
    return;
  }
  if (mouse && mouseButton == RIGHT) {
    if (hasBlock(x1, y1)) {
      blocks.remove(getBlockIndex(x1, y1));
    }
    return;
  }
  if (!hasBlock(x1, y1)) {
    PImage ft = null, st = null;
    if (t1 == Type.WIRE) {
      if (r1 == Rotate.UP) {
        ft = wireUP;
        st = wireUP1;
      } else if (r1 == Rotate.RIGHT) {
        ft = wireRIGHT;
        st = wireRIGHT1;
      } else if (r1 == Rotate.DOWN) {
        ft = wireDOWN;
        st = wireDOWN1;
      } else {
        ft = wireLEFT;
        st = wireLEFT1;
      }
    } else if (t1 == Type.ALL) {
      ft = all;
    } else if (t1 == Type.NOT) {
      ft = not;
    } else if (t1 == Type.AND) {
      ft = and;
    }
    blocks.add(new Block(x1, y1, t1, r1, ft, st));
  }
}

void sendMessage(String msg) {
  mms = millis() + 1500;
  msm = msg;
}

void mousePressed() {
  addBlock(myRot, myType, floor(mouseX/wx), floor(mouseY/wx), true);
}

void mouseDragged() {
  addBlock(myRot, myType, floor(mouseX/wx), floor(mouseY/wx), true);
}

void loadTex() {
  wireUP = loadImage("up.png");
  wireUP1 = loadImage("up1.png");
  wireRIGHT = loadImage("right.png");
  wireRIGHT1 = loadImage("right1.png");
  wireDOWN = loadImage("down.png");
  wireDOWN1 = loadImage("down1.png");
  wireLEFT = loadImage("left.png");
  wireLEFT1 = loadImage("left1.png");
  all = loadImage("all.png");
  not = loadImage("not.png");
  and = loadImage("and.png");
}

void keyPressed() {
  if (waitKey != '.') {
    if (waitKey == 's') {
      saveScheme(key);
    } else {
      loadScheme(key);
    }
    waitKey = '.';
    return;
  }
  //Change type
  if (keyCode == 49 || key == '1') {
    myType = Type.WIRE;
  } else if (keyCode == 50 || key == '2') {
    myType = Type.ALL;
  } else if (keyCode == 51 || key == '3') {
    myType = Type.NOT;
  } else if (keyCode == 52 || key == '4') {
    myType = Type.AND;
  }

  //Rotate
  else if (keyCode == 81 || key == 'q') {
    myRot = Rotate.UP;
  } else if (keyCode == 87 || key == 'w') {
    myRot = Rotate.RIGHT;
  } else if (keyCode == 69 || key == 'e') {
    myRot = Rotate.DOWN;
  } else if (keyCode == 82 || key == 'r') {
    myRot = Rotate.LEFT;
  } else if ((keyCode == 83 || key == 's') && waitKey == '.') {
    waitKey = 's';
    sendMessage("Enter key for save scheme...");
  } else if ((keyCode == 76 || key == 'l') && waitKey == '.') {
    waitKey = 'l';
    sendMessage("Enter key for load scheme...");
  }else if (keyCode == 67 || key == 'c'){
    blocks = new ArrayList<Block>();
    sendMessage("Cleaned...");
  }
}

void saveScheme(char code) {
  JSONArray values = new JSONArray();
  for (int i = 0; i < blocks.size(); i++) {
    Block aht = (Block) blocks.get(i);
    JSONObject bll = new JSONObject();
    bll.setInt("x", aht.x);
    bll.setInt("y", aht.y);
    bll.setInt("lastEnergy", aht.lastEnergy);
    bll.setBoolean("has_electric", aht.has_electric);
    bll.setBoolean("one", aht.one);
    bll.setBoolean("two", aht.two);
    bll.setInt("bid", aht.t.id);
    bll.setInt("rotate", aht.r.id);
    values.setJSONObject(i, bll);
  }
  saveJSONArray(values, "schemes/" + String.valueOf(code) + ".json");
  sendMessage("Scheme saved as " + String.valueOf(code) + ".json");
}

void loadScheme(char code) {
  blocks = new ArrayList<Block>();
  JSONArray values;
  try {
    values = loadJSONArray("schemes/" + String.valueOf(code) + ".json");
  }catch(NullPointerException e){
   sendMessage("Error, file not found");
   return;
  }
  for (int i = 0; i < values.size(); i++) {

    JSONObject b = values.getJSONObject(i); 

    addBlock(Rotate.getByID(b.getInt("rotate")), Type.getByID(b.getInt("bid")), b.getInt("x"), b.getInt("y"), false);
    Block lastBlock = (Block) blocks.get(blocks.size()-1);
    lastBlock.has_electric = b.getBoolean("has_electric");
    lastBlock.one = b.getBoolean("one");
    lastBlock.two = b.getBoolean("two");
  }
  sendMessage("Scheme load (" + String.valueOf(code) + ".json) complete");
}
