/* =========================================================
 * ====                   WARNING                        ===
 * =========================================================
 * The code in this tab has been generated from the GUI form
 * designer and care should be taken when editing this file.
 * Only add/edit code inside the event handlers i.e. only
 * use lines between the matching comment tags. e.g.

 void myBtnEvents(GButton button) { //_CODE_:button1:12356:
     // It is safe to enter your event code here  
 } //_CODE_:button1:12356:
 
 * Do not rename this tab!
 * =========================================================
 */

// draws the controls window
synchronized public void draw_controls(PApplet appc, GWinData data) { //_CODE_:controls:757330:
  appc.background(230);
} //_CODE_:controls:757330:

// method for handling value change for a slider
public void slider_change(GSlider source, GEvent event) { //_CODE_:slider1:453839:
  int tag = source.tagNo;
  pends.get(tag).setLength(sliders.get(tag).getValueI());
  defLens.set(tag, source.getValueI());

  
} //_CODE_:slider1:453839:

// method for handling value change for a knob
public void knob_turn(GKnob source, GEvent event){
  int tag = source.tagNo;
  pends.get(tag).setAngle(-1*radians(knobs.get(tag).getValueF()));
  degs.get(tag).setText(""+-1*round(knobs.get(tag).getValueF()));
}

// method for handling value change for angle value text field
public void deg_changed(GTextField source, GEvent event){
  if (event == GEvent.ENTERED || event == GEvent.LOST_FOCUS){
    int tag = source.tagNo;
    float num = parseFloat(degs.get(tag).getText());
    
    pends.get(tag).setAngle(radians(num));
    defAngles.set(tag, -1*num);

  }
  // sets the knob to match
  // cannot do this while the text field has focus due restrictions in g4p library
  if(event == GEvent.LOST_FOCUS){
    int tag = source.tagNo;
    float num = parseFloat(degs.get(tag).getText());

    knobs.get(tag).setValue(-1*num);
  }
  
}

// method for handling change in number of pendulums 
public void numP_changed(GTextField source, GEvent event) { //_CODE_:numP:917752:  
  if(event == GEvent.CHANGED){
        
    if(0 <= parseInt(source.getText()) && parseInt(source.getText()) <= 12){ // testing for valid input
      numP.setLocalColorScheme(GCScheme.CYAN_SCHEME);
    
      // clears old objects 
      for(int i=0; i<pends.size(); i++){
        GSlider s = sliders.get(i);
        s.dispose();      
        GKnob k = knobs.get(i);
        k.dispose();
        GTextField d = degs.get(i);
        d.dispose();
      }
      // empties arrayLists to be refilled with new objects
      sliders = new ArrayList<GSlider>();
      knobs =  new ArrayList<GKnob>();
      degs = new ArrayList<GTextField>();
      pends = new ArrayList<Pendulum>();
      
    
      // creates the proper number of sliders, knobs, and text fields so there is one to control each pendulum
      for(int i=0; i<parseInt(source.getText()); i++){
        Pendulum P = new Pendulum(defLens.get(i), -1*radians(defAngles.get(i)));
        
        // length sliders
        slider = new GSlider(controls, 155+i*60, 22, 247, 50, 10.0); 
        slider.setShowValue(true);
        slider.setRotation(PI/2, GControlMode.CORNER);
        slider.setLimits(defLens.get(i), 30, 330);
        slider.setNbrTicks(61);
        slider.setStickToTicks(true);
        slider.setShowTicks(true);
        slider.setNumberFormat(G4P.INTEGER, 0);
        slider.setOpaque(false);
        slider.addEventHandler(this, "slider_change");
        slider.tagNo = i;
        sliders.add(slider);        
        
        // release-angle knobs
        knob = new GKnob(controls, 105+i*60, 290, 50, 50, 0.8);
        knob.setTurnRange(0,180);
        knob.setTurnMode(GKnob.CTRL_ANGULAR);
        knob.setShowArcOnly(false);
        knob.setOverArcOnly(false);
        knob.setIncludeOverBezel(false);
        knob.setShowTrack(true);
        knob.setLimits(defAngles.get(i), -90.0, 90.0);
        knob.setNbrTicks(181);
        knob.setStickToTicks(true);
        knob.setShowTicks(false);
        knob.setNumberFormat(G4P.DECIMAL, 0);
        knob.setOpaque(false);
        knob.addEventHandler(this, "knob_turn");
        knob.tagNo = i;
        knobs.add(knob);
        
        // release-angle text field
        deg = new GTextField(controls, 115+60*i, 350, 30, 20, G4P.SCROLLBARS_NONE);
        deg.setOpaque(true);
        deg.setText(""+ -1*round(defAngles.get(i)));
        deg.addEventHandler(this, "deg_changed");
        deg.tagNo = i;
        degs.add(deg);
      }
    }
    
    // if the user entered an invalid number of pendulums, the text turns red
    else {
      numP.setTextBold();
      numP.setLocalColorScheme(GCScheme.RED_SCHEME);
    }
  }
} //_CODE_:numP:917752:

// ghost mode checkbox
public void checkbox1_clicked1(GCheckbox source, GEvent event) { 
  visible = !visible;
}


// method for handling the go/stop button
public void goButton_click(GButton source, GEvent event) { //_CODE_:goButton:413652:

  if (mode.equals("still")){
    mode = "moving";
    goButton.setText("STOP");
  }
  else{
    mode = "still";
    goButton.setText("GO");
  }

} //_CODE_:goButton:413652:

// method for handling the reset button
public void resetButton_click(GButton source, GEvent event){ 
  presets(pends.size(),defLens,defAngles);

}

// method for handling the random configuration button
public void ranButton_click(GButton source, GEvent event){ 
  IntList l = new IntList();
  FloatList a = new FloatList();
  for(int i=0; i<pends.size(); i++){
    l.append(round(random(30,330)));
    a.append(round(random(-90,90)));
  }
  presets(pends.size(), l, a);
  
}

// method for handling the default configuration button
public void resButton_click(GButton source, GEvent event){ 
  for(int i=0; i<pends.size(); i++){
    numP.setText("1");
    numP_changed(numP, GEvent.CHANGED);
    pends.get(i).setAngle(-PI/4);
    pends.get(i).setAVeloc(0);
    pends.get(i).setAAccel(0);
    pends.get(i).setLength(250);
    sliders.get(i).setValue(250);
    knobs.get(i).setValue(45);
    degs.get(i).setText("-45");
    
  }
}

// demo button click handlers

public void demo1_click(GButton source, GEvent event){ 
  readFile(1);
}
public void demo2_click(GButton source, GEvent event){ 
  readFile(2);
}
public void demo3_click(GButton source, GEvent event){ 
  readFile(3);
}


// Create all the GUI controls. 
// autogenerated do not edit
public void createGUI(){
  G4P.messagesEnabled(false);
  G4P.setGlobalColorScheme(GCScheme.CYAN_SCHEME);
  G4P.setCursor(ARROW);
  
  // creating the two windows
  surface.setTitle("Simulation Window");
  controls = GWindow.getWindow(this, "Controls", 0, 0, 820, 460, JAVA2D);
  controls.noLoop();
  controls.addDrawHandler(this, "draw_controls");
  
  // camera perspective instructions on main window
  label0 = new GLabel(this, -40, -40, 200, 20);
  label0.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
  label0.setText("Left click and drag to rotate");
  label0.resizeToFit(true,true);
  label0.setOpaque(false);
  
  label01 = new GLabel(this, -40, -25, 200, 20);
  label01.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
  label01.setText("Right click and drag to zoom");
  label01.resizeToFit(true,true);
  label01.setOpaque(false);
  
  label02 = new GLabel(this, -40, -10, 200, 20);
  label02.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
  label02.setText("Double click to reset perspective");
  label02.resizeToFit(true,true);
  label02.setOpaque(false);
  
  // number of pendulums text field and labels
  numP = new GTextField(controls, 30, 35, 30, 20, G4P.SCROLLBARS_NONE);
  numP.setOpaque(true);
  numP.setPromptText("0");
  numP.addEventHandler(this, "numP_changed");
  
  label1 = new GLabel(controls, 5, 9, 100, 20);
  label1.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  label1.setText("No. Pendulums");
  label1.setOpaque(false);
  
  label2 = new GLabel(controls, 0, 55, 100, 20);
  label2.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  label2.setText("max 12");
  label2.setOpaque(false);
  
  // ghost mode checkbox
  checkbox1 = new GCheckbox(controls, 20, 80, 120, 20);
  checkbox1.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  checkbox1.setText("ghost mode");
  checkbox1.setOpaque(false);
  checkbox1.addEventHandler(this, "checkbox1_clicked1");
  
  // go/stop button
  goButton = new GButton(controls, 20, 410, 80, 30);
  goButton.setText("GO");
  goButton.setTextBold();
  goButton.addEventHandler(this, "goButton_click");
  
  // reset button
  resetButton = new GButton(controls, 120, 410, 80, 30);
  resetButton.setText("RESET");
  resetButton.setTextBold();
  resetButton.addEventHandler(this, "resetButton_click");
  
  // demos label
  label3 = new GLabel(controls, 10, 110, 100, 100);
  label3.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  label3.setText("CHOOSE DEMO, THEN PRESS GO");
  label3.resizeToFit(true,true);
  label3.setOpaque(false);
  
  // default configuration button 
  resButton = new GButton(controls, 20, 320, 80, 30);
  resButton.setText("DEFAULT");
  resButton.setTextBold();
  resButton.addEventHandler(this, "resButton_click");
  controls.loop();
  
  // random configuration button
  ranButton = new GButton(controls, 20, 280, 80, 30);
  ranButton.setText("RANDOM");
  ranButton.setTextBold();
  ranButton.addEventHandler(this, "ranButton_click");
  controls.loop();
  
  // demo buttons
  demo1 = new GButton(controls, 20, 160, 80, 30);
  demo1.setText("DEMO 1");
  demo1.setTextBold();
  demo1.addEventHandler(this, "demo1_click");
  controls.loop();
  
  demo2 = new GButton(controls, 20, 200, 80, 30);
  demo2.setText("DEMO 2");
  demo2.setTextBold();
  demo2.addEventHandler(this, "demo2_click");
  controls.loop();
  
  demo3 = new GButton(controls, 20, 240, 80, 30);
  demo3.setText("DEMO 3");
  demo3.setTextBold();
  demo3.addEventHandler(this, "demo3_click");
  controls.loop();
}

// Variable declarations 
// autogenerated do not edit
GWindow controls;
GSlider slider; 
GTextField numP, deg; 
GKnob knob;
GLabel label0, label01, label02, label1, label2, label3; 
GButton goButton, resetButton, resButton, ranButton, demo1, demo2, demo3; 
GCheckbox checkbox1;
ArrayList<GSlider> sliders = new ArrayList<GSlider>();
ArrayList<GKnob> knobs = new ArrayList<GKnob>();
ArrayList<GTextField> degs = new ArrayList<GTextField>();