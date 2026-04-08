// ==== Screen3: Charts ====
class Screen3 extends Screen
{
  color btnColor;
  int cancelled = 0, onTime = 0;
  String[] topCities;
  int[] cityCounts;
  String[] allStates, allOrigins, allDests;
  
  // dropdown options
  String[] statusOptions = {"All Statuses", "ON TIME", "CANCELLED"};
  String[] chartTypeOptions =
  {
    "Cities",
    "Carriers",
    "Dep Time",
    "Arr Time",
    "Distance"
  };
  
  // selected filter values
  int selectedState = 0, selectedStatus = 0, selectedOrigin = 0, selectedDest = 0;
  int selectedChartType = 0;
  int openDropdown  = -1;
  int maxVisible    = 6;
  int[] scrollOffset = {0, 0, 0, 0, 0};
  int[] ddX = {120, 300, 480, 660, 840};
  int ddY = 15, ddW = 160, ddH = 36;

  Screen3(color bgColor, color btnColor)
  {
    super(bgColor);
    this.btnColor = btnColor;
    buildFilterArrays();
    recompute();
  }

  void buildFilterArrays()
  {
    java.util.TreeSet<String> stateSet  = new java.util.TreeSet<String>();
    java.util.TreeSet<String> originSet = new java.util.TreeSet<String>();
    java.util.TreeSet<String> destSet   = new java.util.TreeSet<String>();
    for (String s : datareader.originState)        stateSet.add(s);
    for (String s : datareader.originAirport)      originSet.add(s);
    for (String s : datareader.destinationAirport) destSet.add(s);
    allStates  = buildArray("All States", stateSet);
    allOrigins = buildArray("All Origins", originSet);
    allDests   = buildArray("All Destinations", destSet);
  }

  String[] buildArray(String firstItem, java.util.TreeSet<String> set)
  {
    String[] arr = new String[set.size() + 1];
    arr[0] = firstItem;
    int i = 1;
    for (String s : set) arr[i++] = s;
    return arr;
  }
  
  // group time into buckets
  String getTimeBucket(String time)
  {
    if (time == null || time.length() < 2) return "Unknown";
    try
    {
      int hour = int(time.substring(0, 2));
      if (hour < 4)  return "00-03";
      if (hour < 8)  return "04-07";
      if (hour < 12) return "08-11";
      if (hour < 16) return "12-15";
      if (hour < 20) return "16-19";
      return "20-23";
    }
    catch (Exception e)
    {
      return "Unknown";
    }
  }

  // group distance into ranges
  String getDistanceBucket(String distStr)
  {
    try
    {
      int d = int(float(distStr));
      if (d < 500)   return "0-499";
      if (d < 1000)  return "500-999";
      if (d < 1500)  return "1000-1499";
      if (d < 2000)  return "1500-1999";
      if (d < 3000)  return "2000-2999";
      return "3000+";
    }
    catch (Exception e)
    {
      return "Unknown";
    }
  }

  void recompute()
  {
    cancelled = 0;
    onTime    = 0;
    ArrayList<String> names = new ArrayList<String>();
    ArrayList<Integer> counts = new ArrayList<Integer>();
    for (int i = 0; i < datareader.cancelled.size(); i++)
    {
      String state  = datareader.originState.get(i);
      String origin = datareader.originAirport.get(i);
      String dest   = datareader.destinationAirport.get(i);
      String canc   = datareader.cancelled.get(i);
      boolean isCancelled = canc.equals("1") || canc.equals("1.00");
      String status = isCancelled ? "CANCELLED" : "ON TIME";
      if (selectedState  > 0 && !state.equals(allStates[selectedState])) continue;
      if (selectedStatus > 0 && !status.equals(statusOptions[selectedStatus])) continue;
      if (selectedOrigin > 0 && !origin.equals(allOrigins[selectedOrigin])) continue;
      if (selectedDest   > 0 && !dest.equals(allDests[selectedDest])) continue;

      if (isCancelled)
      {
        cancelled++;
      }
      else
      {
        onTime++;
      }
      
      // determine cateogry for bar chart
      String key;
      switch (selectedChartType)
      {
        case 0:
          if (selectedDest > 0)
            key = datareader.originCity.get(i);
          else
            key = datareader.destinationCity.get(i);
          break;

        case 1:
          key = datareader.identityCode.get(i);
          break;

        case 2:
          key = getTimeBucket(datareader.scheduledDepartureTime.get(i));
          break;

        case 3:
          key = getTimeBucket(datareader.scheduledArrivalTime.get(i));
          break;

        case 4:
          key = getDistanceBucket(datareader.distance.get(i));
          break;

        default:
          key = "Unknown";
      }

      int idx = names.indexOf(key);
      if (idx == -1)
      {
        names.add(key);
        counts.add(1);
      }
      else
      {
        counts.set(idx, counts.get(idx) + 1);
      }
    }
    String[] tc = names.toArray(new String[0]);
    int[] tn = new int[counts.size()];
    for (int i = 0; i < counts.size(); i++) tn[i] = counts.get(i);

    if (selectedChartType == 0 || selectedChartType == 1)
    {
      for (int i = 0; i < tn.length - 1; i++)
        for (int j = 0; j < tn.length - i - 1; j++)
          if (tn[j] < tn[j+1])
          {
            int tmp = tn[j]; tn[j] = tn[j+1]; tn[j+1] = tmp;
            String ts = tc[j]; tc[j] = tc[j+1]; tc[j+1] = ts;
          }
    }
    else
    {
      String[] order;
      if (selectedChartType == 2 || selectedChartType == 3)
      {
        order = new String[]{"00-03","04-07","08-11","12-15","16-19","20-23"};
      }
      else
      {
        order = new String[]{
          "0-499","500-999","1000-1499",
          "1500-1999","2000-2999","3000+"
        };
      }
      ArrayList<String> orderedNames = new ArrayList<String>();
      ArrayList<Integer> orderedCounts = new ArrayList<Integer>();
      for (int k = 0; k < order.length; k++)
      {
        int idx = -1;

        for (int j = 0; j < tc.length; j++)
        {
          if (tc[j].equals(order[k]))
          {
            idx = j;
            break;
          }
        }
        if (idx != -1) {
          orderedNames.add(tc[idx]);
          orderedCounts.add(tn[idx]);
        } else {
          orderedNames.add(order[k]);
          orderedCounts.add(0);
        }
      }
      tc = orderedNames.toArray(new String[0]);
      tn = new int[orderedCounts.size()];
      for (int i = 0; i < orderedCounts.size(); i++)
      {
        tn[i] = orderedCounts.get(i);
      }
    }
    
    // select top 8 results
    int top = min(8, tc.length);
    topCities  = new String[top];
    cityCounts = new int[top];
    for (int i = 0; i < top; i++)
    {
      topCities[i] = tc[i];
      cityCounts[i] = tn[i];
    }
  }

  void draw()
  {
    super.draw();
    
    // determine chart title
    String chartTitle;
    switch (selectedChartType)
    {
      case 0:
        chartTitle = (selectedDest > 0) ? "Top Origin Cities" : "Top Destination Cities";
        break;
      case 1:
        chartTitle = "Top Carriers";
        break;
      case 2:
        chartTitle = "Departure Time Distribution";
        break;
      case 3:
        chartTitle = "Arrival Time Distribution";
        break;
      case 4:
        chartTitle = "Distance Distribution";
        break;
      default:
        chartTitle = "";
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
      new String[]{"Cancelled", "On time"},
      new color[] {color(#e07b54), color(#4a6fa5)},
      new float[] {cancelled, onTime}
    );
    barChart(width/2 + 40, 110, width - 30, height - 70, topCities, cityCounts);
    drawDropdowns();
  }

  void drawDropdowns()
  {
    String[][] options = { allStates, statusOptions, allOrigins, allDests, chartTypeOptions };
    int[] selected = { selectedState, selectedStatus, selectedOrigin, selectedDest, selectedChartType };
    String[] labels = { "State", "Status", "Origin", "Destination", "Bar Chart" };

    for (int d = 0; d < 5; d++)
    {
      int x = ddX[d];
      noStroke();
      fill(darkMode ? color(#3a8c6e) : color(#4a6fa5));
      rect(x, ddY, ddW, ddH, 8);
      fill(255);
      textSize(13);
      textAlign(LEFT, CENTER);
      String label = selected[d] == 0 ? labels[d] : options[d][selected[d]];
      if (label.length() > 16) label = label.substring(0, 14) + "..";
      text(label, x + 8, ddY + ddH/2);
      textAlign(RIGHT, CENTER);
      text(openDropdown == d ? "▲" : "▼", x + ddW - 6, ddY + ddH/2);
      if (openDropdown == d)
      {
        int offset = scrollOffset[d];
        int end = min(offset + maxVisible, options[d].length);
        int listH = (end - offset) * ddH;
        fill(darkMode ? color(30, 35, 60) : color(245));
        rect(x, ddY + ddH, ddW, listH, 0, 0, 8, 8);
        for (int j = offset; j < end; j++)
        {
          int itemY = ddY + ddH + (j - offset) * ddH;
          if (j == selected[d])
          {
            fill(color(#e07b54));
            rect(x, itemY, ddW, ddH);
          }
          fill(darkMode ? color(220) : color(30));
          textSize(12);
          textAlign(LEFT, CENTER);
          String opt = options[d][j];
          if (opt.length() > 18) opt = opt.substring(0, 16) + "..";
          text(opt, x + 8, itemY + ddH/2);
        }
      }
    }
  }

  // handle mouse clicks
  void clicked(int mx, int my)
  {
    String[][] options = { allStates, statusOptions, allOrigins, allDests, chartTypeOptions };
    for (int d = 0; d < 5; d++)
    {
      int x = ddX[d];
      if (mx > x && mx < x + ddW && my > ddY && my < ddY + ddH)
      {
        openDropdown = (openDropdown == d) ? -1 : d;
        return;
      }

      if (openDropdown == d)
      {
        int offset = scrollOffset[d];
        int end = min(offset + maxVisible, options[d].length);
        for (int j = offset; j < end; j++)
        {
          int itemY = ddY + ddH + (j - offset) * ddH;
          if (mx > x && mx < x + ddW && my > itemY && my < itemY + ddH)
          {
            if (d == 0) selectedState = j;
            if (d == 1) selectedStatus = j;
            if (d == 2) selectedOrigin = j;
            if (d == 3) selectedDest = j;
            if (d == 4) selectedChartType = j;
            openDropdown = -1;
            recompute();
            return;
          }
        }
      }
    }
    openDropdown = -1;
  }

  // handle scrolling inside dropdown
  void scrolled(int delta)
  {
    if (openDropdown == -1) return;
    String[][] options = {allStates, statusOptions, allOrigins, allDests, chartTypeOptions};
    int d = openDropdown;
    scrollOffset[d] = constrain(
      scrollOffset[d] + delta,
      0,
      max(0, options[d].length - maxVisible)
    );
  }
}
