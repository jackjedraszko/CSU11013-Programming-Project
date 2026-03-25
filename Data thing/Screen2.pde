// ==== Screen2: Maps ====
class Screen2 extends Screen
{
  color btnColor;
  PImage USmap;
  float maxTraffic = 1;
  float minBubble = 6;
  float maxBubble = 40;

  ArrayList<Airport> airports = new ArrayList<Airport>();
  Airport hooveredAirport = null;
  DataReader dr;

  Screen2(color bgColor, color btnColor, DataReader dr)
  {
    super(bgColor);
    this.btnColor = btnColor;
    this.dr = dr;

    USmap = loadImage("USmap.png");

    setupAirports();
    calculateTraffic();
    calculateMaxTraffic();

    for (Widget w : widgets)
    {
      w.hoverable = true;
    }
  }

  void draw()
  {
    super.draw();


    float mapX = width/2 - 430;
    float mapY = height/2 - 250;
   

    if (USmap != null)
    {
      image(USmap, mapX, mapY, 900, 540);
    }

    hooveredAirport = null;
    float closestDist = 999999;
    float hooverRadius = 40;
       
    for (Airport a : airports)
    {
      float screenX = mapX + a.x;
      float screenY = mapY + a.y;

      float d = dist(mouseX, mouseY, screenX, screenY);

      if (d < closestDist && d < hooverRadius)
      {
        closestDist = d;
        hooveredAirport = a;
      }
    }
    for (Airport a : airports)
    {
      boolean hoovered = (a == hooveredAirport);
      a.draw(mapX, mapY, hoovered);
    }

    fill(darkMode ? color(255) : color(58, 140, 110));
    textSize(60);
    textAlign(CENTER, CENTER);
    text("Map", width/2, 35);
    
    if (hooveredAirport != null)
    {
      fill(darkMode ? color(255) : color(58,140,110));
      textSize(30);
      textAlign(CENTER, CENTER);

      String associatedFlights = hooveredAirport.code + "  |  Associated flights: " + hooveredAirport.traffic;

      text(associatedFlights, width/2, 100);
    }
  }
  void calculateMaxTraffic()
  {
    maxTraffic = 1;

    for (Airport a : airports)
    {
      if (a.traffic > maxTraffic)
      {
        maxTraffic = a.traffic;
      }
    }
  }
  class Airport
  {
    String code;
    float x, y;
    int traffic;
  
    Airport(String code, float x, float y)
    {
      this.code = code;
      this.x = x;
      this.y = y;
      this.traffic = 0;
    }
  
    void draw(float mapX, float mapY, boolean hovered)
    {
      float normalized = traffic / maxTraffic;
      float baseSize = minBubble + normalized * (maxBubble - minBubble);
      float size = baseSize;
    
      if (hovered)
      {
        size = baseSize * 1.5;
      }
    
      colorMode(HSB, 360, 100, 100, 255);
      float hue = map(normalized, 0, 1, 200, 0);
    
      noStroke();
    
      fill(hue, 90, 100, 80);
      ellipse(mapX + x, mapY + y, size * 1.2, size * 1.2);
    
      fill(hue, 90, 100, 220);
      ellipse(mapX + x, mapY + y, size, size);
    
      colorMode(RGB, 255);
    }
  }
   
  void setupAirports()
  {
    airports.add(new Airport("JFK", 794, 180));
    airports.add(new Airport("LAX", 89, 312));
    airports.add(new Airport("ORD", 575, 198));
    airports.add(new Airport("DCA", 752, 227));
    airports.add(new Airport("FLL", 741, 475));
    airports.add(new Airport("SEA", 79, 36));
    airports.add(new Airport("HNL", 280, 490));
    airports.add(new Airport("LAS", 135, 288));
    airports.add(new Airport("SFO", 40, 242));
    airports.add(new Airport("PHX", 185, 330));
    airports.add(new Airport("DEN", 298, 250));
    airports.add(new Airport("DFW", 415, 383));
    airports.add(new Airport("IAH", 463, 450));
    airports.add(new Airport("ATL", 665, 360));
    airports.add(new Airport("CLT", 722, 313));
    airports.add(new Airport("MCO", 712, 440));
    airports.add(new Airport("BOS", 827, 148));
    airports.add(new Airport("MSP", 492, 134));
    airports.add(new Airport("DTW", 645, 182));
    airports.add(new Airport("PHL", 763, 197));
    airports.add(new Airport("SLC", 212, 215));
    airports.add(new Airport("SAN", 90, 340));
    airports.add(new Airport("ABQ", 275, 329));
    airports.add(new Airport("ALB", 770, 139));
    airports.add(new Airport("ANC", 115, 490));
    airports.add(new Airport("ADQ", 100, 510));
    airports.add(new Airport("AUS", 420, 430));
    airports.add(new Airport("AZA", 200, 350));
    airports.add(new Airport("BDL", 805, 155));
    airports.add(new Airport("BET", 78, 472));
    airports.add(new Airport("BHM", 610, 360));
    
    // NEED TO FINE TUNE THE LOCATION FROM HERE DOWN
    airports.add(new Airport("BNA", 600, 315));
    airports.add(new Airport("BWI", 760, 225));
    airports.add(new Airport("CDV", 160, 60));
    airports.add(new Airport("CHS", 720, 340));
    airports.add(new Airport("CLE", 670, 210));
    airports.add(new Airport("CRP", 430, 480));
    airports.add(new Airport("EWR", 790, 190));
    airports.add(new Airport("GEG", 120, 110));
    airports.add(new Airport("IND", 590, 270));
    airports.add(new Airport("KTN", 130, 120));
    airports.add(new Airport("KOA", 260, 470));
    airports.add(new Airport("LGB", 100, 345));
    airports.add(new Airport("LIH", 250, 460));
    airports.add(new Airport("MYR", 740, 320));
    airports.add(new Airport("OAK", 45, 240));
    airports.add(new Airport("OGG", 300, 480));
    airports.add(new Airport("PBI", 750, 460));
    airports.add(new Airport("PDX", 70, 85));
    airports.add(new Airport("PSG", 115, 115));
    airports.add(new Airport("RDU", 720, 290));
    airports.add(new Airport("SAV", 705, 355));
    airports.add(new Airport("SIT", 105, 105));
    airports.add(new Airport("SJC", 50, 255));
    airports.add(new Airport("SMF", 60, 220));
    airports.add(new Airport("TPA", 690, 445));
    airports.add(new Airport("WRG", 120, 130));
    airports.add(new Airport("YAK", 95, 95));
  }
  
  void calculateTraffic()
  {
    for (String originCode : dr.getOriginAirport())
    {
      originCode = originCode.trim().toUpperCase();
      for (Airport a : airports)
      {
        if (a.code.equals(originCode))
        {
          a.traffic++;
          break;
        }
      }
    }
  
    for (String destCode : dr.getDestinationAirport())
    {
      destCode = destCode.trim().toUpperCase();
      for (Airport a : airports)
      {
        if (a.code.equals(destCode))
        {
          a.traffic++;
          break;
        }
      }
    }
  }
}
