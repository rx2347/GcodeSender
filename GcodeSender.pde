import controlP5.*;
import processing.serial.*;

Serial myPort;
String feedback;

void setup() {
  size (600, 800);
  frameRate(30);
  fill(255);
  myPort = new Serial(this, Serial.list()[3], 115200);

  setupControls();
  if (!grblInit) senderInit("$$");
}

void draw() {
  if ( myPort.available() > 0)
  {  
    feedback = myPort.readStringUntil('\n');
    updateStatus(feedback);
  }

  if (command != "") {
    input.setText(command);
    command = "";
  }
}
