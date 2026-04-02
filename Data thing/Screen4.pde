// ==== Screen4: Tables ====
import javax.swing.JFrame;
import javax.swing.JScrollPane;
import javax.swing.JTable;
import javax.swing.RowFilter;
import javax.swing.table.DefaultTableModel;
import javax.swing.table.JTableHeader;
import javax.swing.table.DefaultTableCellRenderer;
import javax.swing.JComboBox;
import javax.swing.JPanel;
import javax.swing.JLabel;
import javax.swing.RowSorter;
import javax.swing.table.TableRowSorter;
import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Font;
import java.awt.Component;
import java.util.List;
import java.util.ArrayList;

class Screen4 extends Screen {
  DataReader dr;
  JFrame frame;
  boolean tableOpen = false;

  Screen4(color bgColor, color btnColor, DataReader dr) {
    super(bgColor);
    this.dr = dr;
    this.btnColor = btnColor;
  }

  String formatTime(String raw) {
    if (raw == null || raw.isEmpty()) return "";
    try {
      int t = Integer.parseInt(raw.trim());
      int hours   = t / 100;
      int minutes = t % 100;
      return String.format("%02d:%02d", hours, minutes);
    } catch (NumberFormatException e) {
      return raw;
    }
  }

  // Returns delay in minutes (positive = late, 0 = on time, -1 = cancelled/no data)
  int computeDelayMinutes(String scheduled, String actual, String cancelled, String diverted) {
    if (cancelled.equals("1") || diverted.equals("1") || cancelled.equals("1.00") || diverted.equals("1.00")) return -1;
    try {
      int sched   = Integer.parseInt(scheduled.trim());
      int act     = Integer.parseInt(actual.trim());

      int schedMins  = (sched / 100) * 60 + (sched % 100);
      int actualMins = (act   / 100) * 60 + (act   % 100);

      int diff = actualMins - schedMins;
      // Handle midnight wrap around (e.g. scheduled 23:50, actual 00:10)
      if (diff < -120) diff += 24 * 60;
      if (diff >  720) diff -= 24 * 60;

      return diff;
    } catch (NumberFormatException e) {
      return -1;
    }
  }

  String formatDelay(int minutes, String cancelled, String diverted) {
    if (cancelled.equals("1") || cancelled.equals("1.00")) return "CANCELLED";
    if (diverted.equals("1") || diverted.equals("1.00"))  return "DIVERTED";
    if (minutes == -1)         return "N/A";
    if (minutes <= 0)          return "On Time (" + Math.abs(minutes) + "m early)";
    int h = minutes / 60;
    int m = minutes % 60;
    if (h > 0) return "+" + h + "h " + m + "m late";
    return "+" + m + "m late";
  }

  void openTable() {
    if (tableOpen) { frame.toFront(); return; }

    // Col index: 0=Flight, 1=Date, 2=Origin, 3=OriginState,
    //            4=Destination, 5=DestState, 6=SchedDep, 7=ActDep,
    //            8=Status, 9=Delay(display), 10=Delay(minutes, hidden sorter)
    String[] headers = {
      "Flight", "Date", "Origin City", "Origin State",
      "Destination City", "Destination State",
      "Sched Dep", "Act Dep", "Status", "Delay", "_sort"
    };

    int n = dr.flightNumber.size();
    Object[][] data = new Object[n][headers.length];

    for (int i = 0; i < n; i++) {
      String canc  = dr.cancelled.get(i);
      String div   = dr.diverted.get(i);
      String sched = dr.scheduledDepartureTime.get(i);
      String act   = dr.actualDepartureTime.get(i);

      int delayMins = computeDelayMinutes(sched, act, canc, div);

      String status;
      if (canc.equals("1") || canc.equals("1.00"))     status = "CANCELLED";
      else if (div.equals("1") || div.equals("1.00")) status = "DIVERTED";
      else if (delayMins > 0)   status = "DELAYED";
      else                      status = "ON TIME";

      data[i][0]  = dr.flightNumber.get(i);
      data[i][1]  = dr.flightDate.get(i).replace(" 00:00", "").replace(" 12:00:00 AM", "");
      data[i][2]  = dr.originCity.get(i) + " (" + dr.originAirport.get(i) + ")";
      data[i][3]  = dr.originState.get(i);
      data[i][4]  = dr.destinationCity.get(i) + " (" + dr.destinationAirport.get(i) + ")";
      data[i][5]  = dr.destinationState.get(i);
      data[i][6]  = formatTime(sched);
      data[i][7]  = formatTime(act);
      data[i][8]  = status;
      data[i][9]  = formatDelay(delayMins, canc, div);
      data[i][10] = delayMins; // hidden integer for numeric sorting
    }

    // MODEL 
    DefaultTableModel model = new DefaultTableModel(data, headers) {
      public boolean isCellEditable(int r, int c) { return false; }
      public Class getColumnClass(int c) {
        if (c == 10) return Integer.class;
        return String.class;
      }
    };

    JTable table = new JTable(model);
    table.setBackground(new Color(16, 18, 38));
    table.setForeground(new Color(220, 225, 255));
    table.setFont(new Font("SansSerif", Font.PLAIN, 13));
    table.setRowHeight(28);
    table.setGridColor(new Color(45, 48, 90));
    table.setSelectionBackground(new Color(74, 111, 165));

    // Hide the minutes column from the view
    table.getColumnModel().getColumn(10).setMinWidth(0);
    table.getColumnModel().getColumn(10).setMaxWidth(0);
    table.getColumnModel().getColumn(10).setWidth(0);

    // HEADER
    JTableHeader tableHeader = table.getTableHeader();
    tableHeader.setBackground(new Color(25, 28, 55));
    tableHeader.setForeground(new Color(255, 210, 50));
    tableHeader.setFont(new Font("SansSerif", Font.BOLD, 13));

    // Sorter default: sort by delay ascending
    final TableRowSorter<DefaultTableModel> sorter = new TableRowSorter<DefaultTableModel>(model);
    table.setRowSorter(sorter);

    List<RowSorter.SortKey> sortKeys = new ArrayList<RowSorter.SortKey>();
    sortKeys.add(new RowSorter.SortKey(10, javax.swing.SortOrder.ASCENDING));
    sorter.setSortKeys(sortKeys);
    sorter.sort();

    // Color-coded Delay  
    table.getColumnModel().getColumn(9).setCellRenderer(new DefaultTableCellRenderer() {
      public Component getTableCellRendererComponent(JTable t, Object value, boolean isSelected, boolean hasFocus, int row, int col) {
        
        super.getTableCellRendererComponent(t, value, isSelected, hasFocus, row, col);
        String txt = value == null ? "" : value.toString();
        int modelRow = t.convertRowIndexToModel(row);
        Object rawDelay = t.getModel().getValueAt(modelRow, 10);
        int mins = (rawDelay instanceof Integer) ? (Integer) rawDelay : -1;

        if (!isSelected) {
          if (txt.equals("CANCELLED") || txt.equals("DIVERTED")) {
            setBackground(new Color(80, 20, 20));
            setForeground(new Color(255, 100, 100));
          } else if (mins > 120) {
            setBackground(new Color(80, 30, 10));
            setForeground(new Color(255, 120, 40));  // severe
          } else if (mins > 30) {
            setBackground(new Color(70, 55, 10));
            setForeground(new Color(255, 200, 50));  // moderate
          } else if (mins > 0) {
            setBackground(new Color(40, 50, 20));
            setForeground(new Color(180, 230, 80));  // minor
          } else {
            setBackground(new Color(16, 40, 30));
            setForeground(new Color(80, 210, 130));  // on time / early
          }
        }
        setText(txt);
        return this;
      }
    });

    // FILTERS
    java.util.TreeSet<String> oStateSet = new java.util.TreeSet<String>();
    for (String s : dr.originState) oStateSet.add(s);
    String[] oStates = new String[oStateSet.size() + 1];
    oStates[0] = "All Origins";
    int si = 1;
    for (String s : oStateSet) oStates[si++] = s;

    java.util.TreeSet<String> dStateSet = new java.util.TreeSet<String>();
    for (String s : dr.destinationState) dStateSet.add(s);
    String[] dStates = new String[dStateSet.size() + 1];
    dStates[0] = "All Destinations";
    int di = 1;
    for (String s : dStateSet) dStates[di++] = s;

    java.util.TreeSet<String> dateSet = new java.util.TreeSet<>();
    for (String s : dr.flightDate) dateSet.add(s);
    String[] date = new String[dateSet.size() + 1];
    date[0] = "All Dates";
    int sp = 1;
    for (String s : dateSet) date[sp++] = s.replace(" 00:00", "").replace(" 12:00:00 AM", "");

    JComboBox<String> dateFilter  = new JComboBox<>(date);
    final JComboBox oStateFilter = new JComboBox(oStates);
    final JComboBox dStateFilter = new JComboBox(dStates);
    final JComboBox statusFilter = new JComboBox(new String[]{
      "All Statuses", "ON TIME", "DELAYED", "CANCELLED", "DIVERTED"
    });
    final JComboBox delayFilter = new JComboBox(new String[]{
      "Any Delay", "Early / On Time", ">15 min late", ">30 min late", ">60 min late", ">120 min late"
    });

    Color dropBg = new Color(25, 28, 55);
    Color dropFg = new Color(255, 210, 50);
    oStateFilter.setBackground(dropBg);  oStateFilter.setForeground(dropFg);
    dStateFilter.setBackground(dropBg);  dStateFilter.setForeground(dropFg);
    statusFilter.setBackground(dropBg);  statusFilter.setForeground(dropFg);
    delayFilter.setBackground(dropBg);   delayFilter.setForeground(dropFg);
    dateFilter.setBackground(new Color(25, 28, 55));
    dateFilter.setForeground(new Color(255, 210, 50));

    // Filter action
    java.awt.event.ActionListener filterAction = new java.awt.event.ActionListener() {
      public void actionPerformed(java.awt.event.ActionEvent e) {
        String selOState = (String) oStateFilter.getSelectedItem();
        String selDState = (String) dStateFilter.getSelectedItem();
        String selStatus = (String) statusFilter.getSelectedItem();
        String selDate = (String) dateFilter.getSelectedItem();
        String selDelay  = (String) delayFilter.getSelectedItem();

        List<RowFilter<DefaultTableModel, Object>> filters =
          new ArrayList<RowFilter<DefaultTableModel, Object>>();

        if (!selDate.equals("All Dates"))
          filters.add(RowFilter.regexFilter("(?i)^" + selDate + "$", 1));
        if (!selOState.equals("All Origins"))
          filters.add(RowFilter.regexFilter("(?i)^" + selOState + "$", 3));
        if (!selDState.equals("All Destinations"))
          filters.add(RowFilter.regexFilter("(?i)^" + selDState + "$", 5));
        if (!selStatus.equals("All Statuses"))
          filters.add(RowFilter.regexFilter("(?i)^" + selStatus + "$", 8));

        if (!selDelay.equals("Any Delay")) {
          int threshold;
          boolean earlyOnly = false;
          if (selDelay.equals("Early / On Time"))    { threshold = 0;   earlyOnly = true; }
          else if (selDelay.equals(">15 min late"))  { threshold = 15; }
          else if (selDelay.equals(">30 min late"))  { threshold = 30; }
          else if (selDelay.equals(">60 min late"))  { threshold = 60; }
          else if (selDelay.equals(">120 min late")) { threshold = 120; }
          else                                       { threshold = 0; }

          final int t2 = threshold;
          final boolean eo = earlyOnly;

          filters.add(new RowFilter<DefaultTableModel, Object>() {
            public boolean include(RowFilter.Entry<? extends DefaultTableModel, ? extends Object> entry) {
              Object val = entry.getValue(10);
              if (!(val instanceof Integer)) return false;
              int mins = (Integer) val;
              if (eo) return mins <= 0;
              return mins > t2;
            }
          });
        }

        if (filters.isEmpty()) {
          sorter.setRowFilter(null);
        } else {
          sorter.setRowFilter(RowFilter.andFilter(filters));
        }
      }
    };

    oStateFilter.addActionListener(filterAction);
    dStateFilter.addActionListener(filterAction);
    statusFilter.addActionListener(filterAction);
    delayFilter.addActionListener(filterAction);
    dateFilter.addActionListener(filterAction);

    // FILTER BAR
    JPanel filterPanel = new JPanel();
    filterPanel.setBackground(new Color(10, 12, 28));

    JLabel oLabel = new JLabel("Origin:");
    oLabel.setForeground(dropFg);
    filterPanel.add(oLabel);
    filterPanel.add(oStateFilter);

    JLabel dLabel = new JLabel("  Destination:");
    dLabel.setForeground(dropFg);
    filterPanel.add(dLabel);
    filterPanel.add(dStateFilter);

    JLabel sLabel = new JLabel("  Status:");
    sLabel.setForeground(dropFg);
    filterPanel.add(sLabel);
    filterPanel.add(statusFilter);

    filterPanel.add(new JLabel("  Filter by Date:") {{
      setForeground(new Color(255, 210, 50));
    }});
    filterPanel.add(dateFilter);

    JLabel delLabel = new JLabel("  Delay:");
    delLabel.setForeground(dropFg);
    filterPanel.add(delLabel);
    filterPanel.add(delayFilter);

    // LEGEND
    JPanel legendPanel = new JPanel();
    legendPanel.setBackground(new Color(10, 12, 28));
    legendPanel.add(makeChip("On Time / Early",      new Color(80,  210, 130)));
    legendPanel.add(makeChip("Minor (<30m)",          new Color(180, 230, 80)));
    legendPanel.add(makeChip("Moderate (30-120m)",    new Color(255, 200, 50)));
    legendPanel.add(makeChip("Severe (>120m)",        new Color(255, 120, 40)));
    legendPanel.add(makeChip("Cancelled / Diverted",  new Color(255, 100, 100)));

    JPanel topPanel = new JPanel(new BorderLayout());
    topPanel.setBackground(new Color(10, 12, 28));
    topPanel.add(filterPanel,  BorderLayout.NORTH);
    topPanel.add(legendPanel,  BorderLayout.SOUTH);

    // FRAME
    frame = new JFrame("Flight Departures - Sorted by Lateness");
    frame.setLayout(new BorderLayout());
    frame.add(topPanel,               BorderLayout.NORTH);
    frame.add(new JScrollPane(table), BorderLayout.CENTER);
    frame.setSize(1200, 720);
    frame.setLocationRelativeTo(null);
    frame.setVisible(true);
    tableOpen = true;

    frame.addWindowListener(new java.awt.event.WindowAdapter() {
      public void windowClosing(java.awt.event.WindowEvent e) {
        tableOpen = false;
      }
    });
  }

  JLabel makeChip(String text, Color fg) {
    JLabel l = new JLabel(text);
    l.setForeground(fg);
    l.setFont(new Font("SansSerif", Font.BOLD, 12));
    return l;
  }

  void draw() {
    super.draw();

    fill(darkMode ? color(255) : color(58, 140, 110));
    textSize(36);
    textAlign(CENTER, CENTER);
    text("Flight Departures - Lateness View", width/2, height/2 - 60);

    fill(darkMode ? color(200) : color(80));
    textSize(18);
    text("Click the button below to open the flight table", width/2, height/2);

    fill(darkMode ? color(#3a8c6e) : color(#4a6fa5));
    noStroke();
    rect(width/2 - 100, height/2 + 40, 200, 50, 10);
    fill(color(255));
    textSize(16);
    text("Open Table", width/2, height/2 + 65);
  }

  void clicked(int mx, int my) {
    if (mx > width/2 - 100 && mx < width/2 + 100 &&
        my > height/2 + 40 && my < height/2 + 90) {
      openTable();
    }
  }
}
