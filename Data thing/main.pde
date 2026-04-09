// Kira introduced the Main class 19.03.26 9 am
//imports & Global Variables
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.BufferedReader;
import java.io.FileReader;
import java.util.ArrayList;
import javax.swing.JFrame;
import javax.swing.JScrollPane;
import javax.swing.JTable;
import java.io.*;
import java.util.List;


DataReader datareader;
Screen screen1, screen2, screen3, screen4, currentScreen;
boolean darkMode = false;
PImage logo;
Table table;

void setup() {
  size(1300, 700);   // Create 1300x700 pixel window
  textAlign(CENTER, CENTER);   // Center text alignment by default

  logo = loadImage("logo2.jpg");   // Load logo image from file

  table = new Table();   //initialize custom Table object

  datareader = new DataReader();  //create DataReader instance
  datareader.sortData();     // load data from CSV (misnamed method)
  println(datareader.originState.toString());   // Debug: print origin states

// Create all four screens
  screen1 = new Screen1(color(#f5f0eb), color(#f5f0eb));
  screen2 = new Screen2(color(#f5f0eb), color(#f5f0eb), datareader);
  screen3 = new Screen3(color(#f5f0eb), color(#f5f0eb));
  screen4 = new Screen4(color(#f5f0eb), color(#f5f0eb), datareader);

  currentScreen = screen1;  //start on main screen
}


void draw() {
  currentScreen.draw();  //draw whatever screen is active
}


// Ines and Jacek (Jack) added mouse Events and wdiget handling 25.03.26 12 pm
void mousePressed() {
  //logo
  if (mouseX > 20 && mouseX < 80 && mouseY > 10 && mouseY < 60) {
    currentScreen = screen1;
    return;
  }

  //toggle
  int tx = width - 100;   //toggle x position
  int ty = 30;  // Toggle Y position
  if (mouseX > tx && 
      mouseX < tx + 46 && 
      mouseY > ty && 
      mouseY < ty + 22) {
    darkMode = !darkMode;   //change to dark mode
    return;  //exit after toggling
  }

  if (currentScreen == screen1) {
    ((Screen1) currentScreen).checkFileButtons(mouseX, mouseY);
  }
  
  if (currentScreen == screen4){
    ((Screen4) currentScreen).clicked(mouseX, mouseY);
    return;
  }
  if (currentScreen == screen3){
    ((Screen3) currentScreen).clicked(mouseX, mouseY);
    return;
  }
  if (currentScreen == screen2){
    ((Screen2) currentScreen).mousePressed();
  }

  // Check if any widget (button) was clicked
  Widget pressed = currentScreen.getEvent(mouseX, mouseY);

 //switch to the different sceens
  if (pressed != null) {
    if (pressed.label.equals("Maps")) {
      currentScreen = screen2;
    } else if (pressed.label.equals("Charts")) {
      currentScreen = screen3;
    } else if (pressed.label.equals("Tables")) {
      currentScreen = screen4;
    } else {
      println("Button pressed: " + pressed.label);
    }
  }
}

//Mouse Wheel Handler
void mouseWheel(MouseEvent event) {
  if (currentScreen == screen3) {
    ((Screen3) currentScreen).scrolled(event.getCount());
  }
}

//mouse Moved Handler
void mouseMoved() {
  currentScreen.moved(mouseX, mouseY);
}


public int[] changeType(String[] values) {
  int[] temp = new int[values.length];

  for (int i = 0; i < values.length; i++) {      
    temp[i] = (int) Float.parseFloat(values[i]); 
  }

  return temp;
}
