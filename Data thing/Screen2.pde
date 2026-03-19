class Screen2 extends Screen
{
  color btnColor;
  PImage USmap;

  ArrayList<Airport> airports = new ArrayList<Airport>();
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

    for (Airport a : airports)
    {
      a.draw(mapX, mapY);
    }

    fill(darkMode ? color(255) : color(58, 140, 110));
    textSize(60);
    textAlign(CENTER, CENTER);
    text("Map", width/2, 100);
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

  void draw(float mapX, float mapY)
  {
    float size = 8 + sqrt(traffic) * 4;
    float r = map(traffic, 0, 200, 0, 255);
    float g = map(traffic, 0, 200, 180, 50);
    float b = map(traffic, 0, 200, 200, 50);
    noStroke();
    
    fill(r, g, b, 100);
    ellipse(mapX + x, mapY + y, size*1.2, size*1.2);
    
    fill(r, g, b, 220);
    ellipse(mapX + x, mapY + y, size, size);
  }
}
 
void setupAirports()
{

  airports.add(new Airport("JFK", 794, 180));
  airports.add(new Airport("LAX", 90, 330));
  airports.add(new Airport("ORD", 575, 198));
  airports.add(new Airport("DCA", 770, 205));
  airports.add(new Airport("FLL", 741, 475));
  airports.add(new Airport("SEA", 79, 36));
  airports.add(new Airport("HNL", 280, 490));
  airports.add(new Airport("LAS", 135, 292));
  airports.add(new Airport("SFO", 40, 242));
  airports.add(new Airport("PHX", 185, 330));
  airports.add(new Airport("DEN", 298, 250));
  airports.add(new Airport("DFW", 415, 383));
  airports.add(new Airport("IAH", 463, 450));
  airports.add(new Airport("ATL", 665, 360));    // BELOW TO FINE TUNE COORDINATION
  airports.add(new Airport("CLT", 680, 290));  // Charlotte
  airports.add(new Airport("MCO", 720, 420));  // Orlando
  airports.add(new Airport("BOS", 810, 150));  // Boston
  airports.add(new Airport("MSP", 520, 140));  // Minneapolis
  airports.add(new Airport("DTW", 630, 200));  // Detroit
  airports.add(new Airport("PHL", 760, 190));  // Philadelphia
  airports.add(new Airport("SLC", 230, 220));  // Salt Lake City
  airports.add(new Airport("SAN", 90, 360));   // San Diego

}

void calculateTraffic()
{

  for (String originCode : dr.getOriginAirport())
  {
    originCode = originCode.trim().toUpperCase();
    for (Airport a : airports) {
      if (a.code.equals(originCode)) {
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
