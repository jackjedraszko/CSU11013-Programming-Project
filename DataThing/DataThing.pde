import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.BufferedReader;
import java.io.FileReader;
import java.util.ArrayList;


void setup(){
  
}


class DataReaders{
  ArrayList<String> flightDate = new ArrayList<>();
  String fileName = "flights.csv";
  String line = "";
  
  String[] originCity = null; //values[4]
  String[] destinationCity = null; //values[8]

  void sortData(){
    try{
    BufferedReader bfrRdr = new BufferedReader(new FileReader(dataPath(fileName)));
    
    while((line = bfrRdr.readLine()) != null){
      String[] values = line.split(",");

      
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
