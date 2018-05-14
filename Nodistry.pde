
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

int mDownX=0;
int mDownY=0;

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
  int mx = nearestMultOf(mouseX, radius);
  int my = nearestMultOf(mouseY, radius);
  fill(250);
  stroke(200);
  ellipse(mx,my,radius, radius);
  
  // text to display variables and instructions
  drawUI();
  
  // nodes
  for(long nodePos:nodes.keySet()){
    float x = floor(nodePos/1000);
    x+=camX;
    float y = nodePos % 1000;
    y+=camY;
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
    
  text("camX: "+camX, 200,low);
  text("camY: "+camY, 200,low+15);
  
  text("mDownX: "+mDownX, 300,low);
  text("mDownY: "+mDownY, 300,low+15);
  
  int dragX = mDownX - mouseX;
  int dragY = mDownY - mouseY;
  text("dragX: "+dragX, 400,low);
  text("dragY: "+dragY, 400,low+15);
  
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
  
  println("mousePressed "+mouseX+" "+mouseY);
  if(mouseButton==mMid){
    mDownX=mouseX;
    mDownY=mouseY;
  }
}
 
void mouseDragged(){
  //
  int dragX = mDownX - mouseX;
  int dragY = mDownY - mouseY;
  
  camX -= dragX/radius;
  camY -= dragY/radius;
}

void mouseReleased(){
  
  //left click create node
  if(mouseButton==mLeft){
    int mx = nearestMultOf(mouseX, radius);
    int my = nearestMultOf(mouseY, radius);
    long p = mx*1000+ my;
    int col = color( random(255), random(255), random(255) );
    nodes.put( p, col);
    names.put(p, ""+randomChar());
    println("node "+p+" "+col);
  }
  
  // middle mouse
  if(mouseButton==mMid){
    mDownX=0;
    mDownY=0;
  }
}

int nearestMultOf( float number, float nearest){
  //https://stackoverflow.com/questions/14196987/java-round-to-nearest-multiple-of-5-either-up-or-down
  return (int) nearest*(ceil(abs(number/nearest)));
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