// ==== Screen Base Class ====
class Screen {
  ArrayList<Widget> widgets;
  color bgColor;
  color btnColor;

  Screen(color bgColor) {
    this.widgets = new ArrayList<Widget>();
    this.bgColor = bgColor;
   
  }

  void addWidget(Widget w) {
    widgets.add(w);
  }

  Widget getEvent(int mx, int my) {
    for (Widget w : widgets) {
      if (w.clicked(mx, my)) return w;
    }
    return null;
  }

  void moved(int mx, int my) {
    for (Widget w : widgets) {
      w.moved(mx, my);
    }
  }

  void draw() {
    
// ====  Theme changer ===
    if (darkMode){
      bgColor = color(#1a1f2e);
      btnColor = color(#3a8c6e);
    }else{
      bgColor = color(#f5f0eb);
      btnColor = color(#4a6fa5);
    }
 
    for (Widget w : widgets) {
      if (!w.label.equals("Theme")) {
        w.btnColor = btnColor;
      }
    }
    
// === drawing widgets ===    
    background(bgColor);
    for (Widget w : widgets) {
      w.draw();
    }
    
// === logo ===    
    if (logo != null) image(logo, 20, 10, 50, 50);
    
    drawToggle();
  }
  
  void drawToggle(){
// === Toggle ===
    color trackColor = darkMode ? color(74, 111, 165) : color(200);
    color knobColor  = color(255);
    int tx = width - 100;
    int ty = 30;
  
// === Text === 
    fill(darkMode ? color(200) : color(80));
    textSize(15);
    textAlign(RIGHT, CENTER);
    text(darkMode ? "Light mode" : "Dark mode", tx - 10, ty + 10);
  
// === Track ===
    noStroke();
    fill(trackColor);
    rect(tx, ty, 46, 22, 11);
  
// === Circle ===
    fill(knobColor);
    float knobX = darkMode ? tx + 27 : tx + 3;
    circle(knobX + 8, ty + 11, 18);
  }
  
}


// ==== Widget Class ====
class Widget {
  int x, y, w, h;
  String label;
  color btnColor;
  boolean hovered;
  boolean hoverable = false;

  Widget(int x, int y, int w, int h, String label, color btnColor) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.label = label;
    this.btnColor = btnColor;

  }

void draw() {
  stroke(hovered ? color(255) : color(0, 30));
  strokeWeight(2);
  fill(hovered && hoverable ? color(#e07b54) : btnColor);
  rect(x, y, w, h, 12);

  fill(255);
  textAlign(CENTER, CENTER);
  textSize(25);
  text(label, x + w/2, y + h/2);
}

  boolean clicked(int mx, int my) {
    return mx > x && mx < x + w && my > y && my < y + h;
  }

  boolean moved(int mx, int my) {
    hovered = mx > x && mx < x + w && my > y && my < y + h;
    return hovered;
  }
}
