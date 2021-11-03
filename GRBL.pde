int counter =0;
boolean grblInit = false;

// INIT GBRBL
void senderInit(String initCommand) {
  println("In init");
  String val = "";
  while (myPort.available()==0) {
    println("waiting for serial port");
  }
  while (myPort.available()>0) {
    println("Waiting for init...");
    if (!grblInit) updateStatus("Waiting for init...\n");
    val = myPort.readString();
    if (val.contains("Grbl 1.1f")) {
      delay(2000);
      myPort.clear();
      println("Grbl initalized");
      updateStatus("Grbl initalized\n");
      grblInit = true;
      print("Sending init command: ");
      println(initCommand);
      myPort.write(initCommand);
      myPort.write("\n");
      while (myPort.available()==0) {
        println("waiting for response");
      }
      print("Got response ");
      //val = myPort.readString();
      //updateStatus(val);
      myPort.clear();
      //println(val);

      delay(1000);
    }
  }
  println("Init done.");
}

// SEND GCODE
void sendGcode(String gcode) {
  if (grblInit) {
    println("Sending gcode", gcode);
    myPort.clear();
    delay(1000);
    myPort.write(gcode);
    myPort.write("\n");
  }
}
