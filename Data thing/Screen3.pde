// ==== Screen3: Charts ====
class Screen3 extends Screen {
  color btnColor;
  int cancelled = 0, onTime = 0;
  String[] topCities;
  int[] cityCounts;
  
  
  Screen3(color bgColor, color btnColor) {
    super(bgColor);
    this.btnColor = btnColor;

    for (Widget w : widgets) {
      w.hoverable = true;
    }
    //addWidget(new Widget(200, 20, 300, 50, "Destination city", btnColor));


    // count data once in constructor
    for (String s : datareader.cancelled) {
      if (s.trim().equals("1") || s.trim().equals("1.00")) cancelled++;
      else onTime++;
    }
    
    analyzeDestinationCities();
  }

  void draw() {
    super.draw();

// === headline ===
    fill(darkMode ? color(255) : color(58, 140, 110));
    textSize(32);
    textAlign(CENTER, CENTER);
    text("Flight Cancellations", width/4, 150);

// === draw chart first === 
    pieChart(
      width/4, height/2 + 20, 360,
      new String[] { "Cancelled", "On time" },
      new color[]  { color(#e07b54), color(#4a6fa5) },
      new float[]  { cancelled, onTime }
    );

    float midX = width / 2.0;
    

    // ── Right half: bar chart ──
    textSize(32);
    textAlign(CENTER, CENTER);
    text("Top Destination Cities", (width/4)*3, 80);

    barChart(
      midX + 40,  // chartLeft
      120,        // chartTop
      width - 40, // chartRight
      height - 80,// chartBottom
      topCities,
      cityCounts
    );
  }
  
  
  void analyzeDestinationCities() {
    ArrayList<String> cityNames      = new ArrayList<String>();
    ArrayList<Integer> cityCountsList = new ArrayList<Integer>();
  
    // this loop should only count cities
    for (String city : datareader.destinationCity) {
      int idx = cityNames.indexOf(city);
      if (idx == -1) {
        cityNames.add(city);
        cityCountsList.add(1);
      } else {
        cityCountsList.set(idx, cityCountsList.get(idx) + 1);
      }
    } // ← loop ends here
  
    // everything below runs ONCE after the loop
    String[] tempCities = cityNames.toArray(new String[0]);
    int[] tempCounts    = new int[cityCountsList.size()];
    for (int i = 0; i < cityCountsList.size(); i++) {
      tempCounts[i] = cityCountsList.get(i);
    }
  
    // bubble sort
    for (int i = 0; i < tempCounts.length - 1; i++) {
      for (int j = 0; j < tempCounts.length - i - 1; j++) {
        if (tempCounts[j] < tempCounts[j+1]) {
          int tc = tempCounts[j]; tempCounts[j] = tempCounts[j+1]; tempCounts[j+1] = tc;
          String ts = tempCities[j]; tempCities[j] = tempCities[j+1]; tempCities[j+1] = ts;
        }
      }
    }
  
    int top = min(8, tempCities.length);
    topCities  = new String[top];
    cityCounts = new int[top];
    for (int i = 0; i < top; i++) {
      topCities[i]  = tempCities[i];
      cityCounts[i] = tempCounts[i];
    }
  }
}
