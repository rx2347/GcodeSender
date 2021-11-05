import controlP5.*;

ControlP5 cp5;
Textarea status;
Textfield input;
DropdownList ports;
String[] sent = {"$$"};
int sentID = 0;
String command = "";

void setupControls() {
  cp5 = new ControlP5(this);

  // INPUT                                    
  input = cp5.addTextfield("input")
    .setPosition(20, height-60)
    .setSize(width-200, 40)
    .setFont(createFont("arial", 20))
    .setCaptionLabel("")
    ;

  // TEXTAREA
  status = cp5.addTextarea("status")
    .setPosition(20, 40)
    .setSize(width-40, height-100)
    .setFont(createFont("arial", 16))
    .setLineHeight(18)
    .setColor(color(64))
    .setColorBackground(color(255))
    .setColorForeground(color(255));
  ;
  
  // BIND ENTER
  cp5.mapKeyFor(new ControlKey() {
    public void keyEvent() { 
      submit();
    }
  }
  , ENTER);

  // RESET BUTTON     
  cp5.addBang("clear")
    .setPosition(width-200+20, height-60)
    .setSize(80, 40)
    .setFont(createFont("arial", 12))
    .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
    ;    

  // SUBMIT BUTTON
  cp5.addBang("submit")
    .setPosition(width-200+80+20, height-60)
    .setSize(80, 40)
    .setFont(createFont("arial", 12))
    .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
    ;

  // DROPDOWN
  ports = cp5.addDropdownList("ports")
    .setPosition(20, 20)
    .setSize(width-40, 200)
    .setBackgroundColor(color(190))
    .setFont(createFont("arial", 12))
    .setItemHeight(20)
    .setBarHeight(20)
    .setValueLabel("")
    .setLabel("Select Port");

  for (int i=0; i<Serial.list().length; i++) {
    ports.addItem(Serial.list()[i], i);
  };

  ports.close();
  
}


// CLEAR INPUT
public void clear() {
  input.clear();
}

// SUBMIT INPUT
void submit() {
  String text = cp5.get(Textfield.class, "input").getText();
  if (text != "") {
    sent = append(sent, text);
    sentID = sent.length;
    sendGcode(text);
    updateStatus(">> "+text+"\n");
    input.clear();
  }
}

// UPDATE STATUS
void updateStatus(String statusText) {
  String currentText = status.getText();
  currentText+=statusText;
  status.setText(currentText);
  status.scroll(100);
}

// KEYBINDINGS
void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      if (sentID > 0) sentID--;
      command = sent[sentID];
    } 

    if (keyCode == DOWN) {
      sentID++;
      if (sentID >= sent.length) sentID = sent.length -1;
      command = sent[sentID];
    }
  }
}

void controlEvent(ControlEvent theEvent) {
 if (theEvent.isGroup()) {
    println("event from group : "+theEvent.getGroup().getValue()+" from "+theEvent.getGroup());
  } 
  else if (theEvent.isController()) {
    if(theEvent.getController().getName() == "ports") {
      myPort = new Serial(this, Serial.list()[int(theEvent.getController().getValue())], 115200);
      if (!grblInit) senderInit("$$");  
    }
  }
}
