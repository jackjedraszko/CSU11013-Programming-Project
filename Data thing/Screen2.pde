// ==== Screen2 Maps ====


class Screen2 extends Screen
{
  color btnColor;
  PImage USmap;
  float maxTraffic = 1;
  float minBubble = 8;
  float maxBubble = 45;
  float tableX = 30;
  float tableY = 100;
  float rowHeight = 30;
  int tableColor = 0;
  int tableDarkColor = 255;
  int tableFontSize = 20;

  ArrayList<Airport> airports = new ArrayList<Airport>();
  Airport hooveredAirport = null;
  DataReader dr;
  boolean showConnections = false;
  ArrayList<Connection> connections = new ArrayList<Connection>();
  float maxConnections = 1;
  ArrayList<Airport> topAirports = new ArrayList<Airport>();
  Widget toggleMapButton;
  Screen2(color bgColor, color btnColor, DataReader dr)
  {
    super(bgColor);
    this.btnColor = btnColor;
    this.dr = dr;

    USmap = loadImage("USmap.png");

    setupAirports();
    calculateTraffic();
    calculateMaxTraffic();
    calculateConnections();
    calculateTopAirports();

    for (Widget w : widgets)
    {
      w.hoverable = true;
    }
    toggleMapButton = new Widget(width - 220, height - 70, 200, 40,
    "Show Connections", btnColor);
    widgets.add(toggleMapButton);
  }

   void draw()
   {
    super.draw();
  
    float mapX = width/2 - 430;
    float mapY = height/2 - 250;
  
    // ==== Draw map ====
    if (USmap != null) {
      image(USmap, mapX, mapY, 900, 540);
    }
  
    // ==== Detect hovered airport ====
    hooveredAirport = null;
    float closestDist = 999999;
    float hooverRadius = 40;
  
    for (Airport a : airports) {
      float screenX = mapX + a.x;
      float screenY = mapY + a.y;
  
      float d = dist(mouseX, mouseY, screenX, screenY);
  
      if (d < closestDist && d < hooverRadius) {
        closestDist = d;
        hooveredAirport = a;
      }
    }
  
    // ==== Draw connections or heatmap ====
    if (showConnections) {
      int threshold = max(1, (int)(maxConnections * 0.05));
  
      // Draw connections
      for (Connection c : connections) {
        if (c.count > threshold) {
          // Dark mode: white lines; Light mode: darker gray
          stroke(darkMode ? color(255) : color(80));
          float normalized = (float)c.count / maxConnections;
          float thickness = 1 + normalized * 6;
          strokeWeight(thickness);
          line(mapX + c.a1.x, mapY + c.a1.y, mapX + c.a2.x, mapY + c.a2.y);
        }
      }
      
      strokeWeight(1);
      noStroke();

      // Draw airports on top
      for (Airport a : airports) {
        a.draw(mapX, mapY, false);
      }
    } else {
      // Draw heatmap
      for (Airport a : airports) {
        boolean hovered = (a == hooveredAirport);
        a.draw(mapX, mapY, hovered);
      }
    }
  
    // ==== Draw top 10 table ====
    float tableX = 30;
    float tableY = 100;
    float rowHeight = 30;
    fill(darkMode ? color(255) : color(58, 140, 110));
    textSize(20);
    textAlign(LEFT, CENTER);
  
    if (showConnections) {
      ArrayList<Connection> top10 = getTopConnections(10);
      text("Top 10 Airport Pairs:", tableX, tableY - rowHeight + 80);
  
      for (int i = 0; i < top10.size(); i++) {
        Connection c = top10.get(i);
        String label = (i + 1) + ". " + c.a1.code + " - " + c.a2.code + " : " + c.count;
        text(label, tableX, tableY + i * rowHeight + 100);
      }
    } else {
      text("Top 10 Airports:", tableX, tableY - rowHeight + 80);
  
      for (int i = 0; i < topAirports.size(); i++) {
        Airport a = topAirports.get(i);
        String label = (i + 1) + ". " + a.code + "  " + a.traffic + " flights";
        text(label, tableX, tableY + i * rowHeight + 100);
      }
    }
  
    // ==== Draw title ====
    fill(darkMode ? color(255) : color(58, 140, 110));
    textSize(60);
    textAlign(CENTER, CENTER);
  
    String title = showConnections ? "Airport Connections Map" : "Airports Heatmap";
    text(title, width/2, 35);
  
    // ==== Show hovered airport info for heatmap ====
    if (!showConnections && hooveredAirport != null) {
      fill(darkMode ? color(255) : color(58, 140, 110));
      textSize(30);
      textAlign(CENTER, CENTER);
      String info = hooveredAirport.code + "  |  Associated flights: " + hooveredAirport.traffic;
      text(info, width/2, 100);
    }
  }
  ArrayList<Connection> getTopConnections(int n) {
  ArrayList<Connection> sorted = new ArrayList<Connection>(connections);
  sorted.sort((a, b) -> b.count - a.count); // descending by count
  ArrayList<Connection> topN = new ArrayList<Connection>();
  for (int i = 0; i < min(n, sorted.size()); i++) {
    topN.add(sorted.get(i));
  }
  return topN;
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
  void calculateConnections()
  {
    ArrayList<String> origins = dr.originAirport;
    ArrayList<String> dests = dr.destinationAirport;
  
    for (int i = 0; i < origins.size(); i++)
    {
      String o = origins.get(i).trim().toUpperCase();
      String d = dests.get(i).trim().toUpperCase();
  
      Airport originAirport = null;
      Airport destAirport = null;
  
      for (Airport a : airports)
      {
        if (a.code.equals(o)) originAirport = a;
        if (a.code.equals(d)) destAirport = a;
      }
  
      if (originAirport != null && destAirport != null)
      {
        Connection existing = null;
  
        for (Connection c : connections)
        {
          boolean sameDirection =
            (c.a1 == originAirport && c.a2 == destAirport);
  
          boolean oppositeDirection =
            (c.a1 == destAirport && c.a2 == originAirport);
  
          if (sameDirection || oppositeDirection)
          {
            existing = c;
            break;
          }
        }
  
        if (existing != null)
        {
          existing.count++;
        }
        else
        {
          connections.add(new Connection(originAirport, destAirport));
        }
      }
    }
  
    maxConnections = 1;
  
    for (Connection c : connections)
    {
      if (c.count > maxConnections)
        maxConnections = c.count;
    }
  }
  void mousePressed()
  {
    if (mouseX > toggleMapButton.x &&
        mouseX < toggleMapButton.x + toggleMapButton.w &&
        mouseY > toggleMapButton.y &&
        mouseY < toggleMapButton.y + toggleMapButton.h)
    {
      showConnections = !showConnections;
      toggleMapButton.label = showConnections ? "Hide Connections" : "Show Connections";
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
      float normalized = log(traffic + 1) / log(maxTraffic + 1);
      float multiplier = 3.5;
      normalized = pow(normalized, multiplier);
      
      float minBubble = 8;
      float maxBubble = 45;
   
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
    airports.add(new Airport("FLL", 741, 488));
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
    airports.add(new Airport("BNA", 618, 312));
    airports.add(new Airport("BWI", 760, 216));
    airports.add(new Airport("CDV", 144, 488));
    airports.add(new Airport("CHS", 731, 351));
    airports.add(new Airport("CLE", 670, 196));
    airports.add(new Airport("CRP", 430, 480));
    airports.add(new Airport("EWR", 790, 190));
    airports.add(new Airport("GEG", 144, 50));
    airports.add(new Airport("IND", 607, 230));
    airports.add(new Airport("KTN", 180, 520));
    airports.add(new Airport("KOA", 298, 514));
    airports.add(new Airport("LGB", 98, 347));
    airports.add(new Airport("LIH", 238, 467));
    airports.add(new Airport("MYR", 742, 334));
    airports.add(new Airport("OAK", 45, 240));
    airports.add(new Airport("OGG", 265, 480));
    airports.add(new Airport("PBI", 733, 465));
    airports.add(new Airport("PDX", 70, 85));
    airports.add(new Airport("PSG", 170, 510));
    airports.add(new Airport("RDU", 730, 295));
    airports.add(new Airport("SAV", 709, 375));
    airports.add(new Airport("SIT", 160, 500));
    airports.add(new Airport("SJC", 50, 255));
    airports.add(new Airport("SMF", 60, 220));
    airports.add(new Airport("TPA", 698, 455));
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
  void calculateTopAirports()
  {
    ArrayList<Airport> sortedAirports = new ArrayList<Airport>(airports);

    // Sort descending by traffic
    sortedAirports.sort((a, b) -> b.traffic - a.traffic);

    // Take top 10
    topAirports.clear();
    for (int i = 0; i < min(10, sortedAirports.size()); i++) {
        topAirports.add(sortedAirports.get(i));
    }
  }
  class Connection
  {
      Airport a1;
      Airport a2;
      int count;
    
      Connection(Airport a1, Airport a2)
      {
        this.a1 = a1;
        this.a2 = a2;
        this.count = 1;
      }
    
      void draw(float mapX, float mapY)
      {
        float normalized = (float)count / maxConnections;
        float thickness = 1 + normalized * 6;
    
        if (darkMode)
        {
          stroke(255, 160);
        }
        else
        {
          stroke(45, 120);
        }
        
        strokeWeight(thickness);
    
        line(
          mapX + a1.x, mapY + a1.y,
          mapX + a2.x, mapY + a2.y
        );
      }
   }
}
