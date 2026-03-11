import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.BufferedReader;
import java.io.FileReader;
import java.util.ArrayList;
DataReader datareader;


void setup(){
  datareader = new DataReader();
  datareader.sortData();
  println(datareader.originState);
}


class DataReader{
  // define ArrayLists for all the variables from the file
  ArrayList<String> flightDate = new ArrayList<>();
  ArrayList<String> indentityCode = new ArrayList<>();
  ArrayList<String> flightNumber = new ArrayList<>();
  ArrayList<String> originAirport = new ArrayList<>();
  ArrayList<String> originCity = new ArrayList<>();
  ArrayList<String> originState = new ArrayList<>();
  ArrayList<String> originWorldArea = new ArrayList<>();
  ArrayList<String> destinationAirport = new ArrayList<>();
  ArrayList<String> destinationCity = new ArrayList<>();
  ArrayList<String> destinationState = new ArrayList<>();
  ArrayList<String> destinationWorldArea = new ArrayList<>();
  ArrayList<String> scheduledDepartureTime = new ArrayList<>();
  ArrayList<String> actualDepartureTime = new ArrayList<>();
  ArrayList<String> scheduledArrivalTime = new ArrayList<>();
  ArrayList<String> actualArrivalTime = new ArrayList<>();
  ArrayList<String> cancelled = new ArrayList<>();
  ArrayList<String> diverted = new ArrayList<>();
  ArrayList<String> distance = new ArrayList<>();

  String fileName = "flights.csv";
  String line = "";
  
  void sortData(){
    try{
    BufferedReader bfrRdr = new BufferedReader(new FileReader(dataPath(fileName)));
    
    while((line = bfrRdr.readLine()) != null)
    {
      String[] values = line.split(",");
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
    catch (FileNotFoundException e){
      println("File not found: " + e);
    }
    catch(IOException e){
      println("Error reading file: " + e);
    }
  }
}
