/**
 *
 *
 * Iteration 1: Displays dot-matrix / LED content like BART station signs
 * Iteration 2: Turn "on" when inText == True: "off " when inText == False
 *
 */
 
 // Size of Cells
 int dotSize = 7;
 
 color dotOn = color(255, 20, 20);
 color dotOff = color(20, 20, 20);
 
 // Array of Cells
 int[][] dotsArray;
 // Buffer to record state of the dots
 int[][] dotsBuffer;
 
 int w; //screen width
 int h; //screen height
 
 void setup() {
   size(960, 540);
   
   w = width - 30;
   h = height - 30;
 
   dotsArray = new int[w/dotSize][h/dotSize];
   dotsBuffer = new int[w/dotSize][h/dotSize]; 
   
   // Stroke to draw background grid
   //stroke(20,20,20);
   
   noSmooth();
   
   // Initialization of Dots
   for (int x = 0; x < w/dotSize; x++) {
     for (int y = 0; y < h/dotSize; y++) {
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
   background(20,20,40); // What happens w/ this deleted?
 }
 
 void draw() {
   // Draw Grid
   for (int x=0; x<w/dotSize; x++) {
     for (int y=0; y<h/dotSize; y++) {
       if (dotsArray[x][y] == 1) {
         fill(dotOn); // If alive  
       } else {
         fill(dotOff);  
       }
       ellipse(x*dotSize + 20, y*dotSize + 20, dotSize/2, dotSize/2);
     }
   }
 }
 