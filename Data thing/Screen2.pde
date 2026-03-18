// ==== Screen2: Maps ====
class Screen2 extends Screen {
  color btnColor;
  
  Screen2(color bgColor, color btnColor) {
    super(bgColor);
    this.btnColor = btnColor;
    
    for (Widget w : widgets) {
      w.hoverable = true;
    }
  }
  
  void draw() {
    super.draw();

    if (USmap != null) image(USmap, width/2 - 430, height/2- 250, 900, 540);
    
    fill(darkMode ? color(255) : color(58, 140, 110));               
    textSize(60);
    textAlign(CENTER, CENTER);
    text("Map", width/2, 100);
  }
}
