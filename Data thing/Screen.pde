// Kira introduced Screen Base Class 19.03.26 9 am
class Screen {
  ArrayList<Widget> widgets;  // List of buttons on this screen
  color bgColor;
  color btnColor;

  Screen(color bgColor) {
    this.widgets = new ArrayList<Widget>();
    this.bgColor = bgColor;
   
  }

  void addWidget(Widget w) {
    widgets.add(w);  // Add button to screen
  }

  Widget getEvent(int mx, int my) {
    // Find which button was clicked (returns first one found)
    for (Widget w : widgets) {
      if (w.clicked(mx, my)) return w;
    }
    return null;  // No button clicked
  }

  void moved(int mx, int my) {
    // Update hover state for all buttons
    for (Widget w : widgets) {
      w.moved(mx, my);
    }
  }

  void draw() {
    
// Kira introduced theme changer, change if dark mode 25.03.26 10 am
    if (darkMode){
      bgColor = color(#1a1f2e);
      btnColor = color(#3a8c6e);
    }else{
      bgColor = color(#f5f0eb);
      btnColor = color(#4a6fa5);
    }
   // Apply button color to all widgets EXCEPT "Theme" button
    for (Widget w : widgets) {
      if (!w.label.equals("Theme")) {
        w.btnColor = btnColor;
      }
    }
    
// drawing widgets  
    background(bgColor);
    for (Widget w : widgets) {  // Draw each button
      w.draw();
    }
    
//logo   
    if (logo != null) image(logo, 20, 10, 50, 50);
    
    drawToggle();  //draw theme toggle switch
  }
  
  //Toggle
  void drawToggle(){
    // Colors for the toggle
    color trackColor = darkMode ? color(74, 111, 165) : color(200);
    color knobColor  = color(255);
    int tx = width - 100;
    int ty = 30;
  
//Text label
    fill(darkMode ? color(200) : color(80));
    textSize(15);
    textAlign(RIGHT, CENTER);
    text(darkMode ? "Light mode" : "Dark mode", tx - 10, ty + 10);
  
//Track
    noStroke();
    fill(trackColor);
    rect(tx, ty, 46, 22, 11);
  
//circle
    fill(knobColor);
    float knobX = darkMode ? tx + 27 : tx + 3;   // Right if dark mode, left if light
    circle(knobX + 8, ty + 11, 18);
  }
  
}


// Kira added Widget Class 19.03.26 11 am
class Widget {
  int x, y, w, h;    //position and size
  String label;     //button next
  color btnColor;
  boolean hovered;
  boolean hoverable = false;

  Widget(int x, int y, int w, int h, String label, color btnColor) {   //Stores button position, size, text, and color
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.label = label;
    this.btnColor = btnColor;

  }

void draw() {
  //draw border
  stroke(hovered ? color(255) : color(0, 30));
  strokeWeight(2);
  
  //fill color depending if it is hovered or not
  fill(hovered && hoverable ? color(#e07b54) : btnColor);
  rect(x, y, w, h, 12);   //rounded rectangle

 //draw label text
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(25);
  text(label, x + w/2, y + h/2);
}

  boolean clicked(int mx, int my) {
     // Check if mouse coordinates are inside button rectangle
    return mx > x && mx < x + w && my > y && my < y + h;
  }

  boolean moved(int mx, int my) {
    // Update hovered state based on mouse position
    hovered = mx > x && mx < x + w && my > y && my < y + h;
    return hovered;
  }
}
