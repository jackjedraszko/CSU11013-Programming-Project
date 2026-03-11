import java.io.BufferedReader;
import java.io.FileReader;

public class DataReader
  {
    public static void main(String[] args)
    {
      String fileName = "flights(2k)(1) (1).csv";
      String line = "";

      try
        {
          BufferedReader bfrRdr = new BufferedReader(new FileReader(fileName));
          while((line = bfrRdr.readLine()) != null)
            {
              String[] values = line.split(",");
              System.out.println("FlightDate: " + value[0]);
            }
        }
      catch (exception e)
        {
          System.out.println(e);
        }
    }
  }
