
import java.util.Map;
import java.util.TreeMap;

//Color[] colors = 

// map points to colors
Map<Long, Integer> nodes = new TreeMap();
Map<Long, String> names = new TreeMap();

int camX=0;
int camY=0;

int radius = 24;
int mLeft  = 37;
int mMid   = 3;
int mRight = 39;

//int mDownX=0;
//int mDownY=0;

void setup(){
  size(800,400);
}

void draw(){
  background(250);
  
  // bg grid
  stroke(240);
  for(int x=0; x<width; x+=radius){
    for(int y=radius; y<height; y+=radius){
      // vert
      line(x,radius,x,height);
      // horiz
      line(0,y,width,y);
    }
  }
  
  // cursor box
  boolean cursorHint = false;
  if(cursorHint){
    int mx = nearestMultOf(mouseX, radius);
    int my = nearestMultOf(mouseY, radius);
    fill(250);
    stroke(200);
    ellipse(mx,my,radius, radius);
  }
  
  // text to display variables and instructions
  drawUI();
  
  // nodes
  for(long nodePos:nodes.keySet()){
    float x = floor(nodePos/1000);
    x-=camX;
    float y = nodePos % 1000;
    y-=camY;
    int col = nodes.get(nodePos);
    fill(col);
    ellipse( x,y, radius, radius );
    
    // name
    fill(0);
    //text(names.get(nodePos), x +(radius/4), y +(radius/4) );
    textSize( radius /2 );
    text(names.get(nodePos), x -(radius/4), y +(radius/4));
  }
}

void drawUI(){
  //
  //textSize(12);
  textSize(radius/2);
  fill(0);
  stroke(0);
  int low = height-30;
  text("mouseX: "+mouseX, 10,low);
  text("mouseY: "+mouseY, 10,low+15);
  int worldX = camX + mouseX;
  int worldY = camY + mouseY;
  text("worldX: "+worldX, 10,low-35);
  text("worldY: "+worldY, 10,low-20);
    
  text("camX: "+camX, 200,low);
  text("camY: "+camY, 200,low+15);
  
  text("nodeCount: "+nodes.size(), 100, low);
  text("zoom: "+radius, 100, low+15);
  
  // instructions
  String instruct ="Left-click to drop nodes with random names and colors";
  //textSize(16);
  textSize(  radius * 2/3.0 );
  fill(100);
  text(instruct, 10,20);

}

void mousePressed(){
  //println("mousePressed "+mouseX+" "+mouseY);

  int mMid=3;
  if( mouseButton==mMid ){
    cursor(MOVE);
  }
}
 
void mouseDragged(){
  //println("mouseDragged "+mouseX+" "+mouseY);
  
  int mMid=3;
  if( mouseButton==mMid ){
    int dx = pmouseX -mouseX;
    camX += dx;
    
    int dy = pmouseY -mouseY;
    camY += dy;
  }
}

void mouseReleased(){
  
  //left click create node
  if(mouseButton==mLeft){
    //int mx = nearestMultOf(mouseX-camX, radius); // flips
    int mx = nearestMultOf(mouseX+camX, radius); // flips
    //int mx = nearestMultOf(camX-mouseX, radius);//
    //int mx = nearestMultOf(camX+mouseX, radius);
    int my = nearestMultOf(mouseY-camY, radius);
    println("new node x "+mx+" y "+my);
    long p = mx*1000+ my;
    int col = color( random(255), random(255), random(255) );
    nodes.put( p, col);
    names.put(p, ""+randomChar());
    println("node "+p+" "+col);
  }
  int M=3;
  if( mouseButton==M ){
    cursor(ARROW);
  }
}

int nearestMultOf( float number, float nearest){
  println("nearestMultOf("+ number+", "+nearest+")");
  //https://stackoverflow.com/questions/14196987/java-round-to-nearest-multiple-of-5-either-up-or-down
  int res = (int) nearest*(ceil(number/nearest));
  println(" = "+res);
  return res;
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