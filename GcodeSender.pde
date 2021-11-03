import controlP5.*;
import processing.serial.*;

Serial myPort;
String feedback;

void setup() {
  size (600, 800);
  background(30);

  setupControls();
  //if (!grblInit) senderInit("$$");
}

void draw() {
  background(30);

  if (grblInit && myPort.available() > 0) {  
    feedback = myPort.readStringUntil('\n');
    updateStatus(feedback);
  }

  if (command != "") {
    input.setText(command);
    command = "";
  }
}
