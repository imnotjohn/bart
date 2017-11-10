/**
 *
 *
 * Iteration 1: Displays dot-matrix / LED content like BART station signs
 * Iteration 2: Turn "on" when inText == True: "off " when inText == False
 * Iteration 3: Add ControlP5 GUI -- REMOVED FOR NOW
 * Iteration 4: Add BART API
 *
 */
 
 import controlP5.*;
 
 int dotSize = 6;  // Size of Cells
 int birthRate = 25; // Probability of birth ON/OFF
 color dotOn = color(255, 20, 20);
 color dotOff = color(20, 20, 20);
 color PGRAPHICS_COLOR = color(255, 255, 255); // font color that pgraphics reacts to
 
 PGraphics pg;
 ControlP5 cp5;
 
 String baseurl = "http://api.bart.gov/api/etd.aspx?";
 String apikey = "key=JRZZ-B7D9-I97Q-UX5Y&";
 String apifunction = "cmd=etd&";
 String origin = "orig=ASHB&";
 String direction = "dir=";
 String json = "json=y";

 PFont f;

 String dest1;
 String dest1times;
 String dest2;
 String dest2times;
 
 int[][] dotsArray;  // Array of Cells
 int[][] dotsBuffer;  // Buffer to record state of the dots
 
 int w; //screen width variable
 int h; //screen height variable
 int gridHorizontal;
 int gridVertical;
 
 void setup() {
   size(960, 540);
   
   w = width - 30;
   h = height - 30;
 
   gridHorizontal = w/dotSize;
   gridVertical = h/dotSize;
   
   dotsArray = new int[w/dotSize][h/dotSize];
   dotsBuffer = new int[w/dotSize][h/dotSize]; 
   
   noSmooth();
   loadData();
   
   // Initialization of Dots
   for (int x = 0; x < gridHorizontal; x++) {
     for (int y = 0; y < gridVertical; y++) {
       float state = random(100);
       if (state > birthRate) {
         state = 0;  
       } else {
         state = 1;  
       }
       
       // Save state of each dot to the dotsArray
       dotsArray[x][y] = int(state); 
     }
   }
   background(20,20,40); // sets bg color
   
   pg = createGraphics(width, height, JAVA2D);
   pg.beginDraw();
   pg.textSize(125);
   pg.textAlign(CENTER, CENTER);
   pg.fill(PGRAPHICS_COLOR);
   pg.text(dest1, pg.width/6.28 + 90, pg.height/3.14 - 90);
   pg.textSize(81);
   pg.text(dest1times, pg.width/3.14, pg.height/3.14);
   pg.textSize(125);
   pg.text(dest2, pg.width/6.28 + 90, pg.height/3.14 + 180);
   pg.textSize(81);
   pg.text(dest2times, pg.width/3.14, pg.height/3.14 + 270);
   pg.endDraw();
   
   imageMode(CENTER);
   
   //cp5 = new ControlP5(this);
   //Group location = cp5.addGroup("location")
   //                    .setPosition(800,100)
   //                    .setBackgroundHeight(150)
   //                    .setBackgroundColor(color(255, 50))
   //                    ;
   //cp5.addBang("San Francisco")
   //   .setPosition(800,20)
   //   .setSize(45,20)
   //   .setGroup(location)
   //   ;
   //cp5.addBang("Oakland")
   //   .setPosition(800,20)
   //   .setSize(45,20)
   //   .setGroup(location)
   //   ;
 }
 
 void draw() {
   // Draw Grid
   float test_w = float(width)/gridHorizontal;
   float test_h = float(height)/gridVertical;
   
   for (int x=0; x < gridHorizontal; x++) {
     for (int y=0; y < gridVertical; y++) {
       color c = pg.get(int(x*test_w), int(y*test_h)); //test
       boolean textDrawn = (c == PGRAPHICS_COLOR); //test
       //if (dotsArray[x][y] == 1 || textDrawn) {
       if (textDrawn) {
         fill(dotOn); // "on" state  
       } else {
         fill(dotOff);  // "off" state
       }
       ellipse(x*dotSize + 20, y*dotSize + 20, dotSize/2, dotSize/2);
     }
   }
 }
 
 void loadData() {
  String url = buildURL(apifunction, "s&");
  JSONObject rawData = loadJSONObject(url); 
  rawData = rawData.getJSONObject("root");
  String parsedTimeData = rawData.getString("time");
  
  JSONArray rawStationDataArray = rawData.getJSONArray("station");
  JSONObject parsedStationData = rawStationDataArray.getJSONObject(0);
  JSONArray destinationDataArray = parsedStationData.getJSONArray("etd");
  
  // extract each JSONObject from the larger JSONArray
  JSONArray destinationsArray;
  destinationsArray = new JSONArray();
  for (int i = 0; i < destinationDataArray.size(); i++) {
      destinationsArray.append(destinationDataArray.getJSONObject(i));
  }
  // end extraction

  // extract each destination from each destinationArray element
  StringDict desttimes = new StringDict();
  for (int i = 0; i < destinationsArray.size(); i++) {
    JSONObject destinationObject = destinationDataArray.getJSONObject(i);
    String destination = destinationObject.getString("destination"); 
    
    JSONArray estimate = destinationObject.getJSONArray("estimate");
    String estimated = "";
    
    for (int j = 0; j < estimate.size(); j++) {
      JSONObject estimateObject = estimate.getJSONObject(j);
      if (j < estimate.size()-1) {
        estimated += estimateObject.getString("minutes") + ", ";  
      } else {
        estimated += estimateObject.getString("minutes") + " mins.";
      }
    }
    desttimes.set(destination, estimated);
  }
  
  dest1 = desttimes.key(0);
  dest1times = desttimes.get(desttimes.key(0));
  dest2 = desttimes.key(1);
  dest2times = desttimes.get(desttimes.key(1));
  
  println(desttimes);
  println("size " + desttimes.size());
  println(desttimes.key(0));
  println(desttimes.get(desttimes.key(0)));
  println(desttimes.key(1));
  println(desttimes.get(desttimes.key(1)));
}

String buildURL(String apifunc, String dir) {  
  direction += dir;
  return baseurl + apikey + apifunc + origin + direction + json;
}