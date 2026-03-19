class Screen2 extends Screen
{
  color btnColor;
  PImage USmap;

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
      float baseSize = 8 + sqrt(traffic) * 4;
      float size = baseSize;

      if (hovered)
      {
        size = baseSize * 1.5;
      }

      colorMode(HSB, 360, 100, 100, 255);
      float hue = map(traffic, 0, 160, 200, 0);
      noStroke();

      fill(hue, 90, 100, 80);
      ellipse(mapX + x, mapY + y, size*1.2, size*1.2);

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
