// ==== Screen3: Charts ====
class Screen3 extends Screen {
  color btnColor;

  int cancelled = 0, onTime = 0;
  String[] topCities;
  int[] cityCounts;

  String[] allStates, allOrigins, allDests;
  String[] statusOptions = { "All Statuses", "ON TIME", "CANCELLED" };

  String[] chartTypeOptions = { "Cities", "Carriers" };

  int selectedState = 0, selectedStatus = 0, selectedOrigin = 0, selectedDest = 0;
  int selectedChartType = 0;

  int openDropdown  = -1;
  int maxVisible    = 6;
  int[] scrollOffset = { 0, 0, 0, 0, 0 };
  int[] ddX         = { 220, 430, 640, 850, 1060 };
  int ddY = 15, ddW = 200, ddH = 36;

  Screen3(color bgColor, color btnColor) {
    super(bgColor);
    this.btnColor = btnColor;

    buildFilterArrays();
    recompute();
  }

  void buildFilterArrays() {
    java.util.TreeSet<String> stateSet  = new java.util.TreeSet<String>();
    java.util.TreeSet<String> originSet = new java.util.TreeSet<String>();
    java.util.TreeSet<String> destSet   = new java.util.TreeSet<String>();

    for (String s : datareader.originState)        stateSet.add(s);
    for (String s : datareader.originAirport)      originSet.add(s);
    for (String s : datareader.destinationAirport) destSet.add(s);

    allStates  = buildArray("All States",        stateSet);
    allOrigins = buildArray("All Origins",       originSet);
    allDests   = buildArray("All Destinations",  destSet);
  }

  String[] buildArray(String firstItem, java.util.TreeSet<String> set) {
    String[] arr = new String[set.size() + 1];
    arr[0] = firstItem;
    int i = 1;
    for (String s : set) arr[i++] = s;
    return arr;
  }

  void recompute() {
    cancelled = 0;
    onTime    = 0;

    ArrayList<String> names = new ArrayList<String>();
    ArrayList<Integer> counts = new ArrayList<Integer>();

    boolean useOriginCities = (selectedDest > 0);
    boolean useCarriers = (selectedChartType == 1);

    for (int i = 0; i < datareader.cancelled.size(); i++) {
      String state  = datareader.originState.get(i);
      String origin = datareader.originAirport.get(i);
      String dest   = datareader.destinationAirport.get(i);
      String canc   = datareader.cancelled.get(i);

      boolean isCancelled = canc.equals("1") || canc.equals("1.00");
      String status = isCancelled ? "CANCELLED" : "ON TIME";

      // filters
      if (selectedState  > 0 && !state.equals(allStates[selectedState])) continue;
      if (selectedStatus > 0 && !status.equals(statusOptions[selectedStatus])) continue;
      if (selectedOrigin > 0 && !origin.equals(allOrigins[selectedOrigin])) continue;
      if (selectedDest   > 0 && !dest.equals(allDests[selectedDest])) continue;

      if (isCancelled) cancelled++;
      else onTime++;

      String key;

      if (useCarriers) {
        key = datareader.identityCode.get(i);
      } else {
        if (useOriginCities) {
          key = datareader.originCity.get(i);
        } else {
          key = datareader.destinationCity.get(i);
        }
      }

      int idx = names.indexOf(key);
      if (idx == -1) {
        names.add(key);
        counts.add(1);
      } else {
        counts.set(idx, counts.get(idx) + 1);
      }
    }

    String[] tc = names.toArray(new String[0]);
    int[] tn = new int[counts.size()];
    for (int i = 0; i < counts.size(); i++) tn[i] = counts.get(i);

    for (int i = 0; i < tn.length - 1; i++)
      for (int j = 0; j < tn.length - i - 1; j++)
        if (tn[j] < tn[j+1]) {
          int tmp = tn[j]; tn[j] = tn[j+1]; tn[j+1] = tmp;
          String ts = tc[j]; tc[j] = tc[j+1]; tc[j+1] = ts;
        }

    int top = min(8, tc.length);
    topCities  = new String[top];
    cityCounts = new int[top];
    for (int i = 0; i < top; i++) {
      topCities[i] = tc[i];
      cityCounts[i] = tn[i];
    }
  }

  void draw() {
    super.draw();

    boolean useOriginCities = (selectedDest > 0);
    boolean useCarriers = (selectedChartType == 1);

    String chartTitle;

    if (useCarriers) {
      chartTitle = "Top Carriers";
    } else {
      chartTitle = useOriginCities ? "Top Origin Cities" : "Top Destination Cities";
    }

    fill(darkMode ? color(255) : color(58, 140, 110));
    textSize(30);
    textAlign(CENTER, CENTER);
    text("Cancellations", width/4, 90);
    text(chartTitle, (width/4)*3, 90);

    stroke(darkMode ? color(80) : color(200));
    line(width/2, 65, width/2, height - 30);

    pieChart(
      width/4, height/2 + 20, 280,
      new String[]{ "Cancelled", "On time" },
      new color[] { color(#e07b54), color(#4a6fa5) },
      new float[] { cancelled, onTime }
    );

    barChart(width/2 + 40, 110, width - 30, height - 70, topCities, cityCounts);

    drawDropdowns();
  }

  void drawDropdowns() {
    String[][] options = { allStates, statusOptions, allOrigins, allDests, chartTypeOptions };
    int[] selected = { selectedState, selectedStatus, selectedOrigin, selectedDest, selectedChartType };
    String[] labels = { "State", "Status", "Origin", "Destination", "Bar Chart" };

    for (int d = 0; d < 5; d++) {
      int x = ddX[d];
      color bg = darkMode ? color(#3a8c6e) : color(#4a6fa5);

      noStroke();
      fill(bg);
      rect(x, ddY, ddW, ddH, 8);

      fill(255);
      textSize(13);
      textAlign(LEFT, CENTER);

      String label = selected[d] == 0 ? labels[d] : options[d][selected[d]];
      if (label.length() > 21) label = label.substring(0, 19) + "..";
      text(label, x + 10, ddY + ddH/2);

      textAlign(RIGHT, CENTER);
      text(openDropdown == d ? "▲" : "▼", x + ddW - 8, ddY + ddH/2);

      if (openDropdown == d) {
        int offset = scrollOffset[d];
        int end = min(offset + maxVisible, options[d].length);
        int listH = (end - offset) * ddH;

        fill(darkMode ? color(30, 35, 60) : color(245));
        rect(x, ddY + ddH, ddW, listH, 0, 0, 8, 8);

        for (int j = offset; j < end; j++) {
          int itemY = ddY + ddH + (j - offset) * ddH;

          if (j == selected[d]) {
            fill(color(#e07b54));
            rect(x, itemY, ddW, ddH);
          }

          fill(darkMode ? color(220) : color(30));
          textSize(12);
          textAlign(LEFT, CENTER);

          String opt = options[d][j];
          if (opt.length() > 23) opt = opt.substring(0, 21) + "..";
          text(opt, x + 10, itemY + ddH/2);
        }
      }
    }
  }

  void clicked(int mx, int my) {
    String[][] options = { allStates, statusOptions, allOrigins, allDests, chartTypeOptions };

    for (int d = 0; d < 5; d++) {
      int x = ddX[d];

      if (mx > x && mx < x + ddW && my > ddY && my < ddY + ddH) {
        openDropdown = (openDropdown == d) ? -1 : d;
        return;
      }

      if (openDropdown == d) {
        int offset = scrollOffset[d];
        int end = min(offset + maxVisible, options[d].length);

        for (int j = offset; j < end; j++) {
          int itemY = ddY + ddH + (j - offset) * ddH;
          if (mx > x && mx < x + ddW && my > itemY && my < itemY + ddH) {

            if (d == 0) selectedState = j;
            if (d == 1) selectedStatus = j;
            if (d == 2) selectedOrigin = j;
            if (d == 3) selectedDest = j;
            if (d == 4) selectedChartType = j; // 👉 NEW

            openDropdown = -1;
            recompute();
            return;
          }
        }
      }
    }

    openDropdown = -1;
  }

  void scrolled(int delta) {
    if (openDropdown == -1) return;
    String[][] options = { allStates, statusOptions, allOrigins, allDests, chartTypeOptions };
    int d = openDropdown;
    scrollOffset[d] = constrain(
      scrollOffset[d] + delta, 0,
      max(0, options[d].length - maxVisible)
    );
  }
}
