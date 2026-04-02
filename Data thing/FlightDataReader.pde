// DataReader Class
class DataReader {

  // data storage - 18 ArrayLists for CSV columns
  ArrayList<String> flightDate             = new ArrayList<>();
  ArrayList<String> identityCode          = new ArrayList<>();
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

  String fileName = "flights2k.csv";    //CONSTANT fileName = "flights2k.csv"
  String line = "";

  void clearData() {                    // Clear all ArrayLists
      flightDate.clear();
      identityCode.clear();
      flightNumber.clear();
      originAirport.clear();
      originCity.clear();
      originState.clear();
      originWorldArea.clear();
      destinationAirport.clear();
      destinationCity.clear();
      destinationState.clear();
      destinationWorldArea.clear();
      scheduledDepartureTime.clear();
      actualDepartureTime.clear();
      scheduledArrivalTime.clear();
      actualArrivalTime.clear();
      cancelled.clear();
      diverted.clear();
      distance.clear();
  }

// Load data from CSV file (misnamed as sortData)
  void sortData() {
    try {
      BufferedReader bfrRdr = new BufferedReader(new FileReader(dataPath(fileName)));  //open BufferedReader for fileName

      bfrRdr.readLine(); // skip header row

      while ((line = bfrRdr.readLine()) != null) {
        String[] values = parseCSVLine(line); // use CSV parser instead of split()

        if (values.length < 18) continue; // skip malformed rows

        //Add each value to corresponding ArrayList
        flightDate.add(values[0]);
        identityCode.add(values[1]);
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
    //catch exceptions
    catch (FileNotFoundException e) {
      println("File not found: " + e);
    }
    catch (IOException e) {
      println("Error reading file: " + e);
    }
  }

 // Getter methods for each ArrayList
  ArrayList<String> getFlightDate()
  {
    return flightDate;
  }
  ArrayList<String> getIdentityCode()
  {
    return identityCode;
  }
  ArrayList<String> getFlightNumber()
  {
    return flightNumber;
  }
  ArrayList<String> getOriginAirport()
  {
    return originAirport;
  }
  ArrayList<String> getOriginCity()
  {
    return originCity;
  }
  ArrayList<String> getOriginState()
  {
    return originState;
  }
  ArrayList<String> getOriginWorldArea()
  {
    return originWorldArea;
  }
  ArrayList<String> getDestinationAirport()
  {
    return destinationAirport;
  }
  ArrayList<String> getDestinationCity()
  {
    return destinationCity;
  }
  ArrayList<String> getDestinationState()
  {
    return destinationState;
  }
  ArrayList<String> getDestinationWorldArea()
  {
    return destinationWorldArea;
  }
  ArrayList<String> getScheduledDepartureTime()
  {
    return scheduledDepartureTime;
  }
  ArrayList<String> getActualDepartureTime()
  {
    return actualDepartureTime;
  }
  ArrayList<String> getScheduledArrivalTime()
  {
    return scheduledArrivalTime;
  }
  ArrayList<String> getActualArrivalTime()
  {
    return actualArrivalTime;
  }
  ArrayList<String> getCancelled()
  {
    return cancelled;
  }
  ArrayList<String> getDiverted()
  {
    return diverted;
  }
  ArrayList<String> getDistance()
  {
    return distance;
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
