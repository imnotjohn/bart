/**
 *
 *
 * Iteration 1: Displays dot-matrix / LED content like BART station signs
 * Iteration 2: Turn "on" when inText == True: "off " when inText == False
 * Iteration 3: Add ControlP5 GUI
 *
 *
 */
 
 import controlP5.*;
 
 int dotSize = 6;  // Size of Cells
 color dotOn = color(255, 20, 20);
 color dotOff = color(20, 20, 20);
 color PGRAPHICS_COLOR = color(255, 255, 255); // font color that pgraphics reacts to
 
 PGraphics pg;
 ControlP5 cp5;
 
 int[][] dotsArray;  // Array of Cells
 int[][] dotsBuffer;  // Buffer to record state of the dots
 
 int w; //screen width variable
 int h; //screen height variable
 int gridHorizontal;
 int gridVertical;
 
 void setup() {
   size(960, 540);
   
   cp5 = new ControlP5(this);
   Group location = cp5.addGroup("location")
                       .setPosition(100,100)
                       .setBackgroundHeight(150)
                       .setBackgroundColor(color(255, 50))
                       ;
   cp5.addBang("San Francisco")
      .setPosition(10,20)
      .setSize(45,20)
      .setGroup(location)
      ;
   cp5.addBang("Oakland")
      .setPosition(10,20)
      .setSize(45,20)
      .setGroup(location)
      ;
   
   w = width - 30;
   h = height - 30;
 
   gridHorizontal = w/dotSize;
   gridVertical = h/dotSize;
   
   dotsArray = new int[w/dotSize][h/dotSize];
   dotsBuffer = new int[w/dotSize][h/dotSize]; 
   
   noSmooth();
   
   // Initialization of Dots
   for (int x = 0; x < gridHorizontal; x++) {
     for (int y = 0; y < gridVertical; y++) {
       float state = random(100);
       if (state > 40) {
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
   pg.textSize(250);
   pg.textAlign(CENTER, CENTER);
   pg.fill(PGRAPHICS_COLOR);
   pg.text("hello\n", pg.width/2, pg.height/2);
   pg.textSize(125);
   pg.text("good bye", pg.width/2, pg.height/2);
   pg.endDraw();
   
   imageMode(CENTER);
 }
 
 void draw() {
   // Draw Grid
   float test_w = float(width)/gridHorizontal;
   float test_h = float(height)/gridVertical;
   
   for (int x=0; x < gridHorizontal; x++) {
     for (int y=0; y < gridVertical; y++) {
       color c = pg.get(int(x*test_w), int(y*test_h)); //test
       //println(c);
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
 