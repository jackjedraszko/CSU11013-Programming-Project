// ==== Screen3: Charts with Filters
import javax.swing.*;
import java.awt.*;
import java.awt.event.*;
import java.util.ArrayList;

class Screen3 extends Screen {
  color btnColor;

  int cancelled = 0, onTime = 0;
  String[] topCities;
  int[] cityCounts;

  JFrame controlFrame;
  JComboBox<String> stateFilter;
  JComboBox<String> statusFilter;
  boolean filtersOpen = false;

  // BUTTON POSITION (top center)
  float bx, by, bw = 180, bh = 45;

  Screen3(color bgColor, color btnColor) {
    super(bgColor);
    this.btnColor = btnColor;

    setupFilters();

    computeCancellationStatsFiltered();
    analyzeDestinationCitiesFiltered();
  }

  void setupFilters() {
    java.util.TreeSet<String> stateSet = new java.util.TreeSet<String>();
    for (String s : datareader.originState) stateSet.add(s);

    String[] states = new String[stateSet.size() + 1];
    states[0] = "All States";
    int i = 1;
    for (String s : stateSet) states[i++] = s;

    stateFilter = new JComboBox<>(states);

    statusFilter = new JComboBox<>(new String[]{
      "All Statuses", "ON TIME", "CANCELLED"
    });

    ActionListener filterAction = new ActionListener() {
      public void actionPerformed(ActionEvent e) {
        computeCancellationStatsFiltered();
        analyzeDestinationCitiesFiltered();
      }
    };

    stateFilter.addActionListener(filterAction);
    statusFilter.addActionListener(filterAction);
  }

  void openChartControls() {
    println("Button clicked!");

    if (filtersOpen) {
      controlFrame.toFront();
      return;
    }

    controlFrame = new JFrame("Chart Filters");

    JPanel panel = new JPanel(new GridLayout(2, 2, 10, 10));
    panel.setBorder(BorderFactory.createEmptyBorder(10, 10, 10, 10));

    panel.add(new JLabel("State:"));
    panel.add(stateFilter);

    panel.add(new JLabel("Status:"));
    panel.add(statusFilter);

    controlFrame.add(panel);

    controlFrame.setSize(320, 150);
    controlFrame.setLocationRelativeTo(null);
    controlFrame.setVisible(true);

    filtersOpen = true;

    controlFrame.addWindowListener(new WindowAdapter() {
      public void windowClosing(WindowEvent e) {
        filtersOpen = false;
      }
    });
  }

  void computeCancellationStatsFiltered() {
    cancelled = 0;
    onTime = 0;

    String selectedState = (String) stateFilter.getSelectedItem();
    String selectedStatus = (String) statusFilter.getSelectedItem();

    for (int i = 0; i < datareader.cancelled.size(); i++) {
      String state = datareader.originState.get(i);
      String canc = datareader.cancelled.get(i);

      String status = (canc.equals("1") || canc.equals("1.00")) ? "CANCELLED" : "ON TIME";

      if (!selectedState.equals("All States") && !state.equals(selectedState)) continue;
      if (!selectedStatus.equals("All Statuses") && !status.equals(selectedStatus)) continue;

      if (status.equals("CANCELLED")) cancelled++;
      else onTime++;
    }
  }

  void analyzeDestinationCitiesFiltered() {
    String selectedState = (String) stateFilter.getSelectedItem();
    String selectedStatus = (String) statusFilter.getSelectedItem();

    ArrayList<String> cityNames = new ArrayList<String>();
    ArrayList<Integer> cityCountsList = new ArrayList<Integer>();

    for (int i = 0; i < datareader.destinationCity.size(); i++) {
      String state = datareader.originState.get(i);
      String canc = datareader.cancelled.get(i);
      String status = (canc.equals("1") || canc.equals("1.00")) ? "CANCELLED" : "ON TIME";

      if (!selectedState.equals("All States") && !state.equals(selectedState)) continue;
      if (!selectedStatus.equals("All Statuses") && !status.equals(selectedStatus)) continue;

      String city = datareader.destinationCity.get(i);
      int idx = cityNames.indexOf(city);

      if (idx == -1) {
        cityNames.add(city);
        cityCountsList.add(1);
      } else {
        cityCountsList.set(idx, cityCountsList.get(idx) + 1);
      }
    }

    String[] tempCities = cityNames.toArray(new String[0]);
    int[] tempCounts = new int[cityCountsList.size()];
    for (int i = 0; i < cityCountsList.size(); i++) {
      tempCounts[i] = cityCountsList.get(i);
    }

    // sort descending
    for (int i = 0; i < tempCounts.length - 1; i++) {
      for (int j = 0; j < tempCounts.length - i - 1; j++) {
        if (tempCounts[j] < tempCounts[j + 1]) {
          int tc = tempCounts[j];
          tempCounts[j] = tempCounts[j + 1];
          tempCounts[j + 1] = tc;

          String ts = tempCities[j];
          tempCities[j] = tempCities[j + 1];
          tempCities[j + 1] = ts;
        }
      }
    }

    int top = min(8, tempCities.length);
    topCities = new String[top];
    cityCounts = new int[top];

    for (int i = 0; i < top; i++) {
      topCities[i] = tempCities[i];
      cityCounts[i] = tempCounts[i];
    }
  }

  void draw() {
    super.draw();

    // button position (TOP CENTER)
    bx = width/2 - bw/2;
    by = 30;

    // titles
    fill(darkMode ? color(255) : color(58, 140, 110));
    textSize(32);
    textAlign(CENTER, CENTER);
    text("Flight Cancellations", width/4, 150);

    pieChart(
      width/4, height/2 + 20, 360,
      new String[] { "Cancelled", "On time" },
      new color[]  { color(#e07b54), color(#4a6fa5) },
      new float[]  { cancelled, onTime }
    );

    text("Top Destination Cities", (width/4)*3, 80);

    barChart(
      width/2 + 40,
      120,
      width - 40,
      height - 80,
      topCities,
      cityCounts
    );

    drawFilterButton();
  }

  void drawFilterButton() {
    fill(color(25, 28, 55));
    rect(bx, by, bw, bh, 12);

    fill(color(255, 210, 50));
    textAlign(CENTER, CENTER);
    textSize(16);
    text("Open Filters", bx + bw/2, by + bh/2);
  }

  void clicked(int mx, int my) {
    if (mx > bx && mx < bx + bw && my > by && my < by + bh) {
      openChartControls();
    }
  }
}
