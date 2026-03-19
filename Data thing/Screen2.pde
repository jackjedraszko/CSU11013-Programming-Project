// ==== Screen2: Maps ====
class Screen2 extends Screen {
  color btnColor;
  PImage USmap;
  
  Screen2(color bgColor, color btnColor) {
    super(bgColor);
    this.btnColor = btnColor;
    USmap = loadImage("USmap.png");
    
    for (Widget w : widgets) {
      w.hoverable = true;
    }
  }
  
  void draw() {
    super.draw();
    
    float mapX = width/2 - 430;
    float mapY = height/2 -250;

    if (USmap != null)
    {
      image(USmap, mapX, mapY, 900, 540);
    }
    fill(255,80,80);
    noStroke();
    ellipse(mapX + 794, mapY + 180, 15, 15); // JFK
    ellipse(mapX + 90, mapY + 330, 15, 15); // LAX
    ellipse(mapX + 575, mapY + 198, 15, 15); // ORD
    ellipse(mapX + 770, mapY + 205, 15, 15); // DCA
    ellipse(mapX + 741, mapY + 475, 15, 15); // FLL
    ellipse(mapX + 79,  mapY + 36, 15, 15); // SEA
    ellipse(mapX + 280,  mapY + 490, 15, 15); // HNL
    ellipse(mapX + 135, mapY + 292, 15, 15); // LAS
 
    fill(darkMode ? color(255) : color(58, 140, 110));               
    textSize(60);
    textAlign(CENTER, CENTER);
    text("Map", width/2, 100);
  }
}

class Airport
{
  ArrayList<Airport> airports = new ArrayList<Airport>();
  String code;
  float x, y;
  int traffic;
  float size = 10 + min(traffic, 50) * 2;

  Airport(String code, float x, float y)
  {
    this.code = code;
    this.x = x;
    this.y = y;
    this.traffic = 0;
  }
  
  void draw()
  {
    float size = 10 + traffic * 2;
    fill(255, 80, 80, 180);
    noStroke();
    ellipse(mapX + x, mapY + y, size, size);
  }
  
void setupAirports() {

  airports.add(new Airport("JFK", 794, 180));
  airports.add(new Airport("LAX", 90, 330));
  airports.add(new Airport("ORD", 575, 198));
  airports.add(new Airport("DCA", 770, 205));
  airports.add(new Airport("FLL", 741, 475));
  airports.add(new Airport("SEA", 79, 36));
  airports.add(new Airport("HNL", 280, 490));
  airports.add(new Airport("LAS", 135, 292));

}

void calculateTraffic() {

  for (Airport a : airports) {

    for (String o : origins) {
      if (o.equals(a.code)) {
        a.traffic++;
      }
    }

    for (String d : destinations) {
      if (d.equals(a.code)) {
        a.traffic++;
      }
    }

  }
}

for (Airport a : airports) {
  a.draw();
}


}
