import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.BufferedReader;
import java.io.FileReader;

public class DataReader
  {
    public static void main(String[] args)
    {
      String fileName = "flights.csv";
      String line = "";

        try
        {
            BufferedReader bfrRdr = new BufferedReader(new FileReader(fileName));
            while((line = bfrRdr.readLine()) != null)
            {
                String[] values = line.split(",");
                System.out.println("FlightDate: " + values[0]);
            }
        }
        catch (FileNotFoundException e)
        {
            System.out.print(e);
        }
        catch(IOException e)
        {
            System.out.print(e);
        }
    }
  }
