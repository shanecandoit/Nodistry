
import java.awt.Point;
import java.awt.Color;

import java.util.Map;
import java.util.TreeMap;

//Color[] colors = 

// map points to colors
Map<Long, Integer> nodes = new TreeMap();
Map<Long, String> names = new TreeMap();

int radius = 24;

void setup(){
  size(800,400);
}

void draw(){
  background(250);
  
  // cursor box
  int mx = nearestMultOf(mouseX, radius);
  int my = nearestMultOf(mouseY, radius);
  fill(250);
  stroke(200);
  ellipse(mx,my,radius, radius);
  
  //textSize(12);
  textSize(radius/2);
  fill(0);
  stroke(0);
  int low = height-30;
  text("mouseX: "+mouseX, 10,low);
  text("mouseY: "+mouseY, 10,low+15);
  
  text("nodeCount: "+nodes.size(), 100, low);
  text("zoom: "+radius, 100, low+15);
  
  // instructions
  String instruct ="Left-click to drop nodes with random names and colors";
  //textSize(16);
  textSize( 2/3 * radius);
  fill(100);
  text(instruct, 10,20);
  
  // nodes
  for(long nodePos:nodes.keySet()){
    float x = floor(nodePos/1000);
    float y = nodePos % 1000;
    int col = nodes.get(nodePos);
    fill(col);
    ellipse( x,y, radius, radius );
    
    // name
    fill(0);
    //text(names.get(nodePos), x +(radius/4), y +(radius/4) );
    text(names.get(nodePos), x -(radius/4), y +(radius/4));
  }
}

void mousePressed(){
  
}
 
int nearestMultOf( float number, float nearest){
  //https://stackoverflow.com/questions/14196987/java-round-to-nearest-multiple-of-5-either-up-or-down
  return (int) nearest*(ceil(abs(number/nearest)));
}

void mouseReleased(){
  int mx = nearestMultOf(mouseX, radius);
  int my = nearestMultOf(mouseY, radius);
  long p = mx*1000+ my;
  int col = color( random(255), random(255), random(255) );
  nodes.put( p, col);
  names.put(p, ""+randomChar());
  println("node "+p+" "+col);
}

void keyPressed() {
  int down = 40;
  int up = 38;
  println("keyPressed: "+keyCode);
  
  if(keyCode==down){
    radius--;
  }else if(keyCode==up){
    radius++;
  }
  
  if (radius < 0) {
    radius = 0;
  }
  
  if (radius > 50) {
    radius = 50;
  }
}

char randomChar(){
  String alpha = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
  int pos = floor(random(alpha.length()));
  return alpha.charAt(pos);
}