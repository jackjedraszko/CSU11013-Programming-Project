// ==== Screen1 Main ====
class Screen1 extends Screen {
  color btnColor;
  String[] fileNames  = { "flights2k.csv", "flights10k.csv", "flights100k.csv", "flights_full.csv" };
  String[] fileLabels = { "2k", "10k", "100k", "Full" };
  
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
    
    
// file selector label
    fill(darkMode ? color(255) : color(58, 140, 110));
    textSize(18);
    text("Select dataset:", width/2, height - 130);

    // file buttons
    int btnW = 140, btnH = 50;
    int totalW = fileNames.length * btnW + (fileNames.length - 1) * 20;
    int startX = width/2 - totalW/2;

    color activeBtnColor = darkMode ? color(#3a8c6e) : color(#4a6fa5);

    for (int i = 0; i < fileNames.length; i++) {
      int bx = startX + i * (btnW + 20);
      int by = height - 100;

      // selected file gets hover color
      color c = fileNames[i].equals(datareader.fileName) ? color(#e07b54) : activeBtnColor;

      stroke(0, 30);
      strokeWeight(2);
      fill(c);
      rect(bx, by, btnW, btnH, 12);

      fill(255);
      textSize(16);
      textAlign(CENTER, CENTER);
      text(fileLabels[i], bx + btnW/2, by + btnH/2);
    }
  }

  // check if file button was clicked
  void checkFileButtons(int mx, int my) {
    int btnW = 140, btnH = 50;
    int totalW = fileNames.length * btnW + (fileNames.length - 1) * 20;
    int startX = width/2 - totalW/2;

    for (int i = 0; i < fileNames.length; i++) {
      int bx = startX + i * (btnW + 20);
      int by = height - 100;

      if (mx > bx && mx < bx + btnW && my > by && my < by + btnH) {
        if (!datareader.fileName.equals(fileNames[i])) {
          // reload data
          datareader.fileName = fileNames[i];
          datareader.clearData();
          datareader.sortData();

          // recreate screens that depend on data
          screen2 = new Screen2(color(#f5f0eb), color(#f5f0eb), datareader);
          screen3 = new Screen3(color(#f5f0eb), color(#4a6fa5));
          screen4 = new Screen4(color(#f5f0eb), color(#4a6fa5), datareader);
        }
        return;
      }
    }
  }
}
