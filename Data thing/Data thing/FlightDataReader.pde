// ==== DataReader Class ====
class DataReader {

  // ArrayLists for each column in the CSV
  ArrayList<String> flightDate             = new ArrayList<>();
  ArrayList<String> indentityCode          = new ArrayList<>();
  ArrayList<String> flightNumber           = new ArrayList<>();
  ArrayList<String> originAirport          = new ArrayList<>();
  ArrayList<String> originCity             = new ArrayList<>();
  ArrayList<String> originState            = new ArrayList<>();
  ArrayList<String> originWorldArea        = new ArrayList<>();
  ArrayList<String> destinationAirport     = new ArrayList<>();
  ArrayList<String> destinationCity        = new ArrayList<>();
  ArrayList<String> destinationState       = new ArrayList<>();
  ArrayList<String> destinationWorldArea   = new ArrayList<>();
  ArrayList<String> scheduledDepartureTime = new ArrayList<>();
  ArrayList<String> actualDepartureTime    = new ArrayList<>();
  ArrayList<String> scheduledArrivalTime   = new ArrayList<>();
  ArrayList<String> actualArrivalTime      = new ArrayList<>();
  ArrayList<String> cancelled              = new ArrayList<>();
  ArrayList<String> diverted               = new ArrayList<>();
  ArrayList<String> distance               = new ArrayList<>();

  String fileName = "flights.csv";
  String line = "";

  void sortData() {
    try {
      BufferedReader bfrRdr = new BufferedReader(new FileReader(dataPath(fileName)));

      bfrRdr.readLine(); // skip header row

      while ((line = bfrRdr.readLine()) != null) {
        String[] values = parseCSVLine(line); // use CSV parser instead of split()

        if (values.length < 18) continue; // skip malformed rows

        flightDate.add(values[0]);
        indentityCode.add(values[1]);
        flightNumber.add(values[2]);
        originAirport.add(values[3]);
        originCity.add(values[4]);
        originState.add(values[5]);
        originWorldArea.add(values[6]);
        destinationAirport.add(values[7]);
        destinationCity.add(values[8]);
        destinationState.add(values[9]);
        destinationWorldArea.add(values[10]);
        scheduledDepartureTime.add(values[11]);
        actualDepartureTime.add(values[12]);
        scheduledArrivalTime.add(values[13]);
        actualArrivalTime.add(values[14]);
        cancelled.add(values[15]);
        diverted.add(values[16]);
        distance.add(values[17]);
      }

      bfrRdr.close();
    }
    catch (FileNotFoundException e) {
      println("File not found: " + e);
    }
    catch (IOException e) {
      println("Error reading file: " + e);
    }
  }

  // Parses a single CSV line, correctly handling commas inside quoted fields
  // e.g. "New York, NY",NY,... is read as one field, not two
  String[] parseCSVLine(String line) {
    ArrayList<String> result = new ArrayList<String>();
    boolean inQuotes = false;
    StringBuilder current = new StringBuilder();

    for (int i = 0; i < line.length(); i++) {
      char c = line.charAt(i);

      if (c == '"') {
        inQuotes = !inQuotes; // toggle in/out of quoted field
      } else if (c == ',' && !inQuotes) {
        result.add(current.toString().trim()); // end of field
        current = new StringBuilder();
      } else {
        current.append(c); // add character to current field
      }
    }

    result.add(current.toString().trim()); // add last field
    return result.toArray(new String[0]);
  }
}
