// ==== Screen1 Main ====
class Screen1 extends Screen {
  color btnColor;
  
  Screen1(color bgColor, color btnColor) {
    super(bgColor);
    this.btnColor = btnColor;
    
    addWidget(new Widget(100, height/2, 300, 150, "Maps",   btnColor));
    addWidget(new Widget(width/2-150, height/2, 300, 150, "Charts", btnColor));
    addWidget(new Widget(width-400,   height/2, 300, 150, "Tables", btnColor));
    
      for (Widget w : widgets) {
        w.hoverable = true;
      }
  }
  void draw() {
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
 
    super.draw();

    // Toggle
    color trackColor = darkMode ? color(74, 111, 165) : color(200);
    color knobColor  = color(255);
    int tx = width - 100;
    int ty = 30;
  
    // Text
    fill(darkMode ? color(200) : color(80));
    textSize(15);
    textAlign(RIGHT, CENTER);
    text(darkMode ? "Light mode" : "Dark mode", tx - 10, ty + 10);
  
    // Track
    noStroke();
    fill(trackColor);
    rect(tx, ty, 46, 22, 11);
  
    // Circle
    fill(knobColor);
    float knobX = darkMode ? tx + 27 : tx + 3;
    circle(knobX + 8, ty + 11, 18);

    
    fill(darkMode ? color(91, 142, 125) : color(58, 140, 110));           
    textSize(60);
    textAlign(CENTER, CENTER);
    text("Welcome to the Dashboard", width/2, 150);
    textSize(30);
    text("Explore maps, data tables and charts", width/2, 200);
  }
}
