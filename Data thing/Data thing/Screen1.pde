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
    super.draw();

    fill(darkMode ? color(255) : color(58, 140, 110));           
    textSize(60);
    textAlign(CENTER, CENTER);
    text("Welcome to the Dashboard", width/2, 150);
    textSize(30);
    text("Explore maps, data tables and charts", width/2, 200);
  }
}
