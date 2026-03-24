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


// ==== Setup ====
void setup() {
  size(1300, 700);
  textAlign(CENTER, CENTER);

  logo = loadImage("logo2.jpg");

  table = new Table();

  // === Data ===
  datareader = new DataReader();
  datareader.sortData();
  println(datareader.originState.toString());


  // --- Screens ---
  screen1 = new Screen1(color(#f5f0eb), color(#f5f0eb));
  screen2 = new Screen2(color(#f5f0eb), color(#f5f0eb), datareader);
  screen3 = new Screen3(color(#f5f0eb), color(#f5f0eb));
  screen4 = new Screen4(color(#f5f0eb), color(#f5f0eb), datareader);

  currentScreen = screen1;
}


// ==== Draw ====
void draw() {
  currentScreen.draw();
}


// ==== Mouse Events ====
void mousePressed() {

  if (mouseX > 20 && mouseX < 80 && mouseY > 10 && mouseY < 60) {
    currentScreen = screen1;
    return;
  }

  if (currentScreen == screen4) {
    ((Screen4) currentScreen).clicked(mouseX, mouseY);
    return;
  }


  // Dark mode toggle
  int tx = width - 100;
  int ty = 30;
  if (mouseX > tx && 
      mouseX < tx + 46 && 
      mouseY > ty && 
      mouseY < ty + 22) {
    darkMode = !darkMode;
    return;
  }


  Widget pressed = currentScreen.getEvent(mouseX, mouseY);

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

void mouseMoved() {
  currentScreen.moved(mouseX, mouseY);
}


// ==== Helper: changeType ====
public int[] changeType(String[] values) {
  int[] temp = new int[values.length];

  for (int i = 0; i < values.length; i++) {      
    temp[i] = (int) Float.parseFloat(values[i]); 
  }

  return temp;
}
