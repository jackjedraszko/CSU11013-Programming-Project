import javax.swing.JFrame;
import javax.swing.JScrollPane;
import javax.swing.JTable;
import javax.swing.RowFilter;
import javax.swing.table.DefaultTableModel;
import javax.swing.table.JTableHeader;
import javax.swing.JComboBox;
import javax.swing.JPanel;
import javax.swing.JLabel;
import javax.swing.RowSorter;
import javax.swing.table.TableRowSorter;
import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Font;
import java.awt.Dimension;

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
    return raw; // return as-is if it can't be parsed
  }
}


  void openTable() {
    if (tableOpen) { frame.toFront(); return; }

//table data
    String[] headers = { "Flight", "Date", "Origin City", "Origin State",
                         "Destination City", "Sched Dep", "Act Dep", "Status" };

    int n = dr.flightNumber.size();
    Object[][] data = new Object[n][headers.length];

    for (int i = 0; i < n; i++) {
      String status;
      if(dr.cancelled.get(i).equals("1")) status = "CANCELLED";
      else if(dr.diverted.get(i).equals("1"))  status = "DIVERTED";
      else status = "ON TIME";

      data[i][0] = dr.flightNumber.get(i);
      data[i][1] = dr.flightDate.get(i).replace(" 00:00", "");
      data[i][1] = dr.flightDate.get(i).replace(" 12:00:00 AM", "");
      data[i][2] = dr.originCity.get(i) + " (" + dr.originAirport.get(i) + ")";
      data[i][3] = dr.originState.get(i);
      data[i][4] = dr.destinationCity.get(i) + " (" + dr.destinationAirport.get(i) + ")";
      data[i][5] = formatTime(dr.scheduledDepartureTime.get(i));
      data[i][6] = formatTime(dr.actualDepartureTime.get(i));
      data[i][7] = status;
    }

//table creationn
    DefaultTableModel model = new DefaultTableModel(data, headers) {
      public boolean isCellEditable(int row, int col) { return false; }
    };

    JTable table = new JTable(model);
    table.setBackground(new Color(16, 18, 38));
    table.setForeground(new Color(220, 225, 255));
    table.setFont(new Font("SansSerif", Font.PLAIN, 13));
    table.setRowHeight(28);
    table.setGridColor(new Color(45, 48, 90));
    table.setSelectionBackground(new Color(74, 111, 165));

    //header
    JTableHeader tableHeader = table.getTableHeader();
    tableHeader.setBackground(new Color(25, 28, 55));
    tableHeader.setForeground(new Color(255, 210, 50));
    tableHeader.setFont(new Font("SansSerif", Font.BOLD, 13));

    //sorter
    TableRowSorter<DefaultTableModel> sorter = new TableRowSorter<>(model);
    table.setRowSorter(sorter);

    //filter dropdown
    java.util.TreeSet<String> stateSet = new java.util.TreeSet<>();
    for (String s : dr.originState) stateSet.add(s);
    String[] states = new String[stateSet.size() + 1];
    states[0] = "All States";
    int si = 1;
    for (String s : stateSet) states[si++] = s;

    JComboBox<String> stateFilter  = new JComboBox<>(states);
    JComboBox<String> statusFilter = new JComboBox<>(new String[]{ "All Statuses", "ON TIME", "CANCELLED", "DIVERTED" });

    stateFilter.setBackground(new Color(25, 28, 55));
    stateFilter.setForeground(new Color(255, 210, 50));
    statusFilter.setBackground(new Color(25, 28, 55));
    statusFilter.setForeground(new Color(255, 210, 50));

    //applying filters
    java.awt.event.ActionListener filterAction = e -> {
      String selectedState  = (String) stateFilter.getSelectedItem();
      String selectedStatus = (String) statusFilter.getSelectedItem();

      RowFilter<DefaultTableModel, Object> stateF = selectedState.equals("All States")
        ? null : RowFilter.regexFilter("(?i)^" + selectedState + "$", 3);

      RowFilter<DefaultTableModel, Object> statusF = selectedStatus.equals("All Statuses")
        ? null : RowFilter.regexFilter("(?i)^" + selectedStatus + "$", 7);

      if (stateF == null && statusF == null) {
        sorter.setRowFilter(null);
      } else if (stateF == null) {
        sorter.setRowFilter(statusF);
      } else if (statusF == null) {
        sorter.setRowFilter(stateF);
      } else {
        sorter.setRowFilter(RowFilter.andFilter(
          java.util.Arrays.asList(stateF, statusF)
        ));
      }
    };

    stateFilter.addActionListener(filterAction);
    statusFilter.addActionListener(filterAction);

    //filter bar
    JPanel filterPanel = new JPanel();
    filterPanel.setBackground(new Color(10, 12, 28));
    filterPanel.add(new JLabel("Filter by State:") {{
      setForeground(new Color(255, 210, 50));
    }});
    filterPanel.add(stateFilter);
    filterPanel.add(new JLabel("  Filter by Status:") {{
      setForeground(new Color(255, 210, 50));
    }});
    filterPanel.add(statusFilter);

//frame
    frame = new JFrame("Flight Departures");
    frame.setLayout(new BorderLayout());
    frame.add(filterPanel, BorderLayout.NORTH);
    frame.add(new JScrollPane(table), BorderLayout.CENTER);
    frame.setSize(1100, 700);
    frame.setLocationRelativeTo(null);
    frame.setVisible(true);
    tableOpen = true;

    frame.addWindowListener(new java.awt.event.WindowAdapter() {
      public void windowClosing(java.awt.event.WindowEvent e) {
        tableOpen = false;
      }
    });
  }

  void draw() {
    super.draw();

    fill(darkMode ? color(255) : color(58, 140, 110));
    textSize(36);
    textAlign(CENTER, CENTER);
    text("Flight Departures Table", width/2, height/2 - 60);

    fill(darkMode ? color(200) : color(80));
    textSize(18);
    text("Click the button below to open the flight table", width/2, height/2);

    fill(color(25, 28, 55));
    noStroke();
    rect(width/2 - 100, height/2 + 40, 200, 50, 10);
    fill(color(255, 210, 50));
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
