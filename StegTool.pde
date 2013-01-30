String version = "2.4.2";

import controlP5.*;
import java.io.File;
import javax.swing.*;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.Random;
import java.util.Iterator;
import java.util.Map;

HashMap code = new HashMap();
HashMap decode = new HashMap();
Random r = new Random("".hashCode());
LinkedList<int[]> coords = new LinkedList<int[]>();

Textarea decoded_view;
boolean encode_tab = true;

String message = "Secret Message";
ControlP5 cp5;
PImage img;

void setup() {
  setupCodes();

  size(640, 340);
  background(0);
  frame.setTitle("StegTool"+version);
  cp5 = new ControlP5(this);

  cp5.addTab("decode")
    .setLabel("decode")
      .setId(1)
        .activateEvent(true);

  cp5.getTab("default")
    .setLabel("encode")
      .setId(0)
        .activateEvent(true);

  cp5.addTextarea("message")
    .setPosition(20, 30)
      .setSize(width-140, 50)
        .setColor(color(200))
          .setFont(createFont("arial", 11))
            .setColorBackground(color(255, 100))
              .setColorForeground(color(255, 100));

  decoded_view = cp5.addTextarea("decoded_view")
    .setPosition(20, 30)
      .setSize(width-140, 50)
        .moveTo("decode")
          .setLineHeight(14)
            .setFont(createFont("arial", 11))

              .setColor(color(200))
                .setColorBackground(color(255, 100))
                  .setColorForeground(color(255, 100));

  cp5.addButton("load_text")
    .setPosition(width-100, 30)
      .setSize(80, 50)
        .getCaptionLabel()
          .align(ControlP5.CENTER, ControlP5.CENTER);

  cp5.addTextfield("image")
    .setPosition(20, 100)
      .setSize(width-140, 40)
        .setFocus(false)
          .setColor(color(200))
            .setFont(createFont("arial", 14))
              .moveTo("global");

  cp5.addButton("load_image")
    .setPosition(width-100, 100)
      .setSize(80, 40)
        .getCaptionLabel()
          .align(ControlP5.CENTER, ControlP5.CENTER);

  cp5.getController("load_image").moveTo("global");

  cp5.addTextfield("output")
    .setPosition(20, 160)
      .setSize(width-140, 40)
        .setFocus(false)
          .setColor(color(200))
            .setFont(createFont("arial", 14))
              .moveTo("global");

  cp5.addButton("save_location")
    .setPosition(width-100, 160)
      .setSize(80, 40)
        .getCaptionLabel()
          .align(ControlP5.CENTER, ControlP5.CENTER);

  cp5.getController("save_location").moveTo("global");

  cp5.addTextfield("password")
    .setPosition(20, 220)
      .setSize(width-40, 40)
        .setFocus(false)
          .setColor(color(200))
            .setFont(createFont("arial", 14))
              .setPasswordMode(true);

  cp5.getController("password").moveTo("global");

  cp5.addButton("encode_message")
    .setPosition(20, 280)
      .setSize(80, 40)
        .getCaptionLabel()
          .align(ControlP5.CENTER, ControlP5.CENTER);

  cp5.addButton("decode_message")
    .setPosition(20, 280)
      .setSize(80, 40)
        .getCaptionLabel()
          .align(ControlP5.CENTER, ControlP5.CENTER);

  cp5.getController("decode_message").moveTo("decode");

  cp5.addButton("clear")
    .setPosition(120, 280)
      .setSize(80, 40)
        .getCaptionLabel()
          .align(ControlP5.CENTER, ControlP5.CENTER);

  cp5.getController("clear").moveTo("global");
  cp5.get(Textfield.class, "image").setLabel("base image location (.jpg or .png)");
  cp5.get(Textfield.class, "output").setLabel("coded image save location (.png)");
}

void load_text() {
  selectInput("Select a text file:", "textSelected");
}

void textSelected(File selection) {
  if (selection != null) {
    if (!selection.getAbsolutePath().endsWith(".txt")) {
      cp5.get(Textarea.class, "message").setText("Invalid - please load a .txt file."); 
      return;
    }
    String[] text = loadStrings(selection.getAbsolutePath());
    String out = "";
    for (String s : text) {
      out += s + '\n';
    }
    out = clean(out);
    cp5.get(Textarea.class, "message").setText(out);
  }
}

void load_image() {
  selectInput("Select an image:", "imageSelected");
}

void imageSelected(File selection) {
  if (selection != null) {
    String path = selection.getAbsolutePath();
    if (encode_tab) {
      if (!(path.endsWith("jpg") || path.endsWith("png"))) {
        cp5.get(Textfield.class, "image").setText("Filetype must be .jpg or .png");
        return;
      }
    } 
    else {
      if (!(path.endsWith("png"))) {
        cp5.get(Textfield.class, "image").setText("Filetype must be .png");
        return;
      }
    }
    cp5.get(Textfield.class, "image").setText(path);
  }
}

void save_location() {
  selectInput("Where to save?", "save_loc");
}

void save_loc(File selection) {
  if (selection != null) { 
    String path = selection.getAbsolutePath();
    if (encode_tab) {
      if (!path.endsWith("png")) {
        cp5.get(Textfield.class, "output").setText("Filetype must be .png");
        return;
      }
    } 
    else {
      if (!path.endsWith("txt")) {
        cp5.get(Textfield.class, "output").setText("Filetype must be .txt");
        return;
      }
    }
    cp5.get(Textfield.class, "output").setText(selection.getAbsolutePath());
  }
}

int[] getRandom() {
  return coords.remove(r.nextInt(coords.size()));
}

void encode_message() {
  //try {
  String message = cp5.get(Textarea.class, "message").getText();
  String cypher = cp5.get(Textfield.class, "password").getText();
  r = new Random(cypher.hashCode());
  message = cypher(message, cypher);
  message = encode(message);
  PImage img = loadImage(cp5.get(Textfield.class, "image").getText());
  setupCoordList(img);
  codeImage(img, message);
  img.save(cp5.get(Textfield.class, "output").getText());
  cp5.get(Textarea.class, "message").setText("DONE");
  cp5.get(Textfield.class, "image").clear();
  cp5.get(Textfield.class, "output").clear();
  cp5.get(Textfield.class, "password").clear();
  //} 
  /*
  catch (Exception e) {
   cp5.get(Textfield.class, "image").setText("Unable to load image.");
   } */
}

void decode_message() {
  try {
    PImage img = loadImage(cp5.get(Textfield.class, "image").getText());
    setupCoordList(img);
    String cypher = cp5.get(Textfield.class, "password").getText();
    r = new Random(cypher.hashCode());
    String message = decodeImage(img);
    message = decode(message);
    message = decypher(message, cypher);
    String outFile = cp5.get(Textfield.class, "output").getText();
    if (outFile.length() > 0) {
      saveStrings(outFile, new String[] {
        message
      }
      );
    }
    decoded_view.setText(message);
    cp5.get(Textfield.class, "output").clear();
    cp5.get(Textfield.class, "password").clear();
  } 
  catch (Exception e) {
    cp5.get(Textfield.class, "image").setText("Unable to load image.");
  }
}

void draw() {
  background(0);
}

void clear() {
  cp5.get(Textarea.class, "message").clear();
  cp5.get(Textfield.class, "image").clear();
  cp5.get(Textfield.class, "output").clear();
}

void codeImage(PImage img, String encoded) {
  do {
    int[] pixel = getRandom();
    color c = img.get(pixel[0], pixel[1]);
    int r = (int)red(c);
    int g = (int)green(c);
    int b = (int)blue(c);
    //Modify red
    char bit = encoded.charAt(0);
    encoded = encoded.substring(1);
    if ((r%2==0)!=(bit=='0')) {
      if (r > 127) {
        r--;
      }
      else {
        r++;
      }
    }
    if (r > 127) while (r%3==0) r -= 2;
    else while (r%3==0) r+=2;
    if (encoded.length() == 0) {
      if (g > 127) while (g%3!=0) g -= 1;
      else while (g%3!=0) g+=1;
      img.set(pixel[0], pixel[1], color(r, g, b));
      break;
    }
    //Modify green
    bit = encoded.charAt(0);
    encoded = encoded.substring(1);
    if ((g%2==0)!=(bit=='0')) {
      if (g > 127) { 
        g--;
      }
      else {
        g++;
      }
    }
    if (g > 127) while (g%3==0) g -= 2;
    else while (g%3==0) g+=2;
    if (encoded.length() == 0) {
      if (b > 127) while (b%3!=0) b -= 1;
      else while (b%3!=0) b+=1;
      img.set(pixel[0], pixel[1], color(r, g, b));
      break;
    }
    //Modify blue
    bit = encoded.charAt(0);
    encoded = encoded.substring(1);
    if ((b%2==0)!=(bit=='0')) {
      if (b > 127) { 
        b--;
      }
      else {
        b++;
      }
    }
    if (b > 127) while (b%3==0) b -= 2;
    else while (b%3==0) b+=2;
    img.set(pixel[0], pixel[1], color(r, g, b));
  } 
  while (encoded.length () > 0);
  int[] pixel = getRandom();
  color c = img.get(pixel[0], pixel[1]);
  int r = (int)red(c);
  if (r > 127) {
    while (r%3 != 0) r--;
  } 
  else {
    while (r%3 != 0) r++;
  }
  img.set(r, (int)green(c), (int)blue(c));
}

String decodeImage(PImage img) {
  String encoded = "";
  color c;
  do {
    int[] pixel = getRandom();
    c = img.get(pixel[0], pixel[1]);
    int r = (int)red(c);
    int g = (int)green(c);
    int b = (int)blue(c);
    if (r % 3 == 0) break;
    encoded += Integer.toString(r%2);
    if (g % 3 == 0) break;
    encoded += Integer.toString(g%2);
    if (b % 3 == 0) break;
    encoded += Integer.toString(b%2);
  } 
  while (true);
  return encoded;
}

String clean(String message) {
  message = message.trim();
  message = message.toLowerCase();
  String out = "";
  for (char c : message.toCharArray()) {
    if (Character.isLetter(c) || c == '\n')
      out += c;
    else if (Character.isWhitespace(c))
      out += ' ';
  }
  return out;
}

String encode(String message) {
  //message = clean(message);
  String out = "";
  for (char c : message.toCharArray()) {
    out += code.get(c);
  }
  return out;
}

String decode(String encoded) {
  String curr = "";
  String message = "";
  while (encoded.length () > 0) {
    curr += encoded.charAt(0);
    encoded = encoded.substring(1);
    if (decode.get(curr) != null) {
      message += decode.get(curr);
      curr = "";
    }
  }
  return message;
}

String cypher(String message, String password) {
  return cypher(message, password, true);
}

String cypher(String message, String password, boolean scramble) {
  if (password.length() == 0) return message;
  message = message.toLowerCase();
  Random r;
  if (scramble)
    r = new Random(cypher(password, password, false).hashCode());
  else
    r = new Random(password.hashCode());
  String out = "";
  for (int i = 0; i < message.length(); i++) {
    out += cypher(message.charAt(i), r.nextInt(28));
  }
  return out;
}

String decypher(String message, String password) {
  if (password.length() == 0) return message;
  message = message.toLowerCase();
  Random r = new Random(cypher(password, password, false).hashCode());
  String out = "";
  for (int i = 0; i < message.length(); i++) {
    out += decypher(message.charAt(i), r.nextInt(28));
  }
  return out;
}

char cypher(char c, int p) {
  c = Character.toLowerCase(c);
  int val = ((int)c);
  if (val == 32) val = 123;
  if (val == 10 || val == 13) val = 124;
  val -= 97;
  val += p;
  val %= 28;
  val += 97;
  if (val == 123) return ' ';
  else if (val == 124) return '\n';
  return (char)val;
}

char decypher(char c, int p) {
  c = Character.toLowerCase(c);
  if (c == ' ') c = '{';
  if (c == '\n') c = '|';
  int val = ((int)c) - 97;
  val -= p;
  while (val < 0) val += 28;
  val %= 28;
  val += 97;
  if (val == 123) return ' ';
  else if (val == 124) return '\n';
  else return (char)val;
}

void controlEvent(ControlEvent theControlEvent) {
  if (theControlEvent.isTab()) {
    if (theControlEvent.getTab().getId() == 0) {
      encode_tab = true;
      cp5.get(Textarea.class, "message").clear();
      cp5.get(Textfield.class, "image").clear();
      cp5.get(Textfield.class, "output").clear();
      cp5.get(Textfield.class, "password").clear();
      cp5.get(Textfield.class, "image").setLabel("base image location (.jpg or .png)");
      cp5.get(Textfield.class, "output").setLabel("coded image save location (.png)");
    } 
    else if (theControlEvent.getTab().getId() == 1) {
      encode_tab = false;
      cp5.get(Textarea.class, "message").clear();
      cp5.get(Textfield.class, "image").clear();
      cp5.get(Textfield.class, "output").clear();
      cp5.get(Textfield.class, "password").clear();
      cp5.get(Textfield.class, "image").setLabel("coded image location (.png)");
      cp5.get(Textfield.class, "output").setLabel("decoded text save location (.txt)");
    }
  }
}

void setupCoordList(PImage img) {
  coords.clear();
  for (int i = 0; i < img.width; i++) {
    for (int j = 0; j < img.height; j++) {
      int[] point = new int[2];
      point[0] = i;
      point[1] = j;
      coords.add(point);
    }
  }
}

void setupCodes() {
  // Encodings:
  code.put('a', "00000");
  code.put('b', "00001");
  code.put('c', "00010");
  code.put('d', "00011");
  code.put('e', "00100");
  code.put('f', "00101");
  code.put('g', "00110");
  code.put('h', "00111");
  code.put('i', "01000");
  code.put('j', "01001");
  code.put('k', "01010");
  code.put('l', "01011");
  code.put('m', "01100");
  code.put('n', "01101");
  code.put('o', "01110");
  code.put('p', "01111");
  code.put('q', "10000");
  code.put('r', "10001");
  code.put('s', "10010");
  code.put('t', "10011");
  code.put('u', "10100");
  code.put('v', "10101");
  code.put('w', "10110");
  code.put('x', "10111");
  code.put('y', "1100");
  code.put('z', "1101");
  code.put(' ', "1110");
  code.put('\n', "1111");
  // Decodings:
  Iterator i = code.entrySet().iterator();
  while (i.hasNext ()) {
    Map.Entry me = (Map.Entry)i.next();
    decode.put(me.getValue(), me.getKey());
  }
}

