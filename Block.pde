public class Block {
  Type t;
  Rotate r;
  public int x, y;
  public boolean has_electric;
  PImage tex0 = null, tex1 = null;
  boolean one = false, two = false;
  int lastEnergy = 0, pastEnergy = 0;
  boolean onDisable = false;


  Block(int x, int y, Type t, Rotate r, PImage tex0, PImage tex1) {
    this.x = x;
    this.y = y;
    this.t = t;
    this.r = r;
    this.tex0 = tex0;
    this.tex1 = tex1;
  }

  void tick() {
    if (getTimer4Enable()) {
      has_electric = true;
      setTimer4Disable();
    }
    if (getTimer4Disable()) {
      has_electric = false;
      one = false;
      two = false;
    }
    if (t == Type.WIRE) {
      if (has_electric) {
        addEnergy(false);
      }
    } else if (t == Type.ALL) {
      addEnergy(true);
    } else if (t == Type.AND) {
      if (one && two) {
        addEnergy(false);
      }
    }
  }

  void addEnergy(boolean isAll) {
    if (isAll) {
      addEnergyLow(0, -1);
      addEnergyLow(1, 0);
      addEnergyLow(0, 1);
      addEnergyLow(-1, 0);
    } else {
      if (r == Rotate.UP) {
        addEnergyLow(0, -1);
      } else if (r == Rotate.RIGHT) {
        addEnergyLow(1, 0);
      } else if (r == Rotate.DOWN) {
        addEnergyLow(0, 1);
      } else if (r == Rotate.LEFT) {
        addEnergyLow(-1, 0);
      }
    }
  }

  void addEnergyLow(int x1, int y1) {
    if (hasBlock(x+x1, y+y1)) {
      Block aa = getBlock(x+x1, y+y1);
      if (aa.t == Type.WIRE) {
        aa.setTimer4Enable();
      } else if (aa.t == Type.AND) {
        if (aa.one && !aa.two) {
          aa.two = true;
          setTimer4Disable();
        } else {
          aa.one = true;
          aa.two = false;
          setTimer4Disable();
        }
      }
    }
  }

  void view() {
    if (t == Type.WIRE) {
      image(has_electric ? tex1 : tex0, x * wx + 1, y * wx + 1, wx -1, wx -1);
    } else {
      image(tex0, x*wx+1, y*wx+1, wx-1, wx-1);
    }
  }

  void setTimer4Disable() {
    lastEnergy = millis() + 100;
  }

  boolean getTimer4Disable() {
    return millis() > lastEnergy;
  }

  void setTimer4Enable() {
    pastEnergy = millis() + 100;
    onDisable = true;
  }

  boolean getTimer4Enable() {
    if (millis() > pastEnergy) onDisable = false;
    return millis() > pastEnergy;
  }
}
