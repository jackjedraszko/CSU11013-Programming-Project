// ==== Screen4: Tables ====
class Screen4 extends Screen {
  color btnColor;
  
  Screen4(color bgColor, color btnColor) {
    super(bgColor);
    this.btnColor = btnColor;
    
    for (Widget w : widgets) {
      w.hoverable = true;
    }
    
    addWidget(new Widget(width/2 - 150 , height/2, 300, 150, "Flight numbers", color(255, 0, 0)));
  }
  
  void draw() {
    super.draw();

    fill(darkMode ? color(255) : color(58, 140, 110));               
    textSize(60);
    textAlign(CENTER, CENTER);
    text("Tables", width/2, height/3);
  }
}
