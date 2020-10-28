enum Type {
  WIRE(0, "Проводка"), 
  ALL(1, "Активный блок"), 
  AND(2, "Логическое И"), 
  NOT(3, "Логическое НЕ"), 
  XOR(4, "Логический Исключаюшее ИЛИ"), 
  UNKNOWN(5, "Ошибка");

  public String name;
  public int id;

  Type(int id, String name) {
    this.name = name;
    this.id = id;
  }

  public static Type getByID(int id) {
    for (Type t : values()) {
      if (t.id == id) return t;
    }
    return UNKNOWN;
  }
}

enum Rotate {
  UP(0, "Вверх"), 
  RIGHT(1, "Вправо"), 
  DOWN(2, "Вниз"), 
  LEFT(3, "Влево"), 
  UNKNOWN(4, "Ошибка");

  public String name;
  public int id;

  Rotate(int id, String name) {
    this.id = id;
    this.name = name;
  }

  public static Rotate getByID(int id) {
    for (Rotate t : values()) {
      if (t.id == id) return t;
    }
    return UNKNOWN;
  }
}
