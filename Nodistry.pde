
import java.util.Map;
import java.util.TreeMap;

// map points to colors. key is "xx yy"
Map<String, Node> nodes = new TreeMap();
//Map<String, String> names = new TreeMap();

int camX=0;
int camY=0;

int radius = 24;
int mLeft  = 37;
int mMid   = 3;
int mRight = 39;

// for debugging
boolean SPACE=false;

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
  
  // nodes first
  drawNodes();
  
  // then UI on top
  drawUI(); //<>//
}

void drawNodes() {
  // nodes
  for(Node node:nodes.values()){
    node.draw();
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
    int mx = nearestMultOf(mouseX+camX, radius);
    int my = nearestMultOf(mouseY+camY, radius);
    String pt = mx+" "+ my;
    
    float dx = mouseX-pmouseX;
    float dy = mouseY-pmouseY;
    
    Node newNode = new Node( mx, my, dx, dy);
    nodes.put( pt, newNode); //<>//
  }
  int M=3;
  if( mouseButton==M ){
    cursor(ARROW);
  }
}

int nearestMultOf( float number, float nearest){
  //println("nearestMultOf("+ number+", "+nearest+")");
  //https://stackoverflow.com/questions/14196987/java-round-to-nearest-multiple-of-5-either-up-or-down
  int res = (int) nearest*(ceil(number/nearest));
  //println(" = "+res);
  return res;
}

void keyPressed() {
  int down = 40;
  int up = 38;
  //println("keyPressed: "+keyCode);
  
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
  
  int spacebar=32;
  if(keyCode==spacebar){
    SPACE=true;
    
    // save an image
    String filename = "screenshot.png";
    saveFrame(filename);
    println("saved frame:"+filename);
  }
}
void keyReleased(){
  //
  SPACE=false;
}

char randomChar(){
  String alpha = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
  int pos = floor(random(alpha.length()));
  return alpha.charAt(pos);
}

class Node {
  int x;
  int y;
  int col;
  String name;
  float dx;
  float dy;
  
  int radius = 24;
  int repelRadius = radius*4;
  
  public Node(float x, float y){
    this.x=(int)x;
    this.y=(int)y;
    col=color(random(255),random(255),random(255));
    name=""+randomChar();
  }
  public Node(float x, float y, float dx, float dy){
    this.x=(int)x;
    this.y=(int)y;
    this.dx=dx+=2*random(2);
    this.dy=dy+=2*random(2);
    col=color(random(255),random(255),random(255));
    name=""+randomChar();
  }
  public String pt(){
    return x+" "+y;
  }
  
  void draw(){
    float nx = this.x-camX;
    float ny = this.y-camY;
    
    // update x, y
    if(dx!=0){
      x+=dx;
      dx/=2;
    }
    if(dy!=0){
      y+=dy;
      dy/=2;
    }
    
    // draw repel radius
    stroke(150);
    fill(255,0.5);
    ellipse( nx,ny, repelRadius, repelRadius );
    
    // draw node
    stroke(0);
    fill(col);
    ellipse( nx,ny, radius, radius );
    if( SPACE ){
      this.print();
    }
    
    // draw name
    fill(0);
    //text(names.get(nodePos), x +(radius/4), y +(radius/4) );
    textSize( radius /2 );
    //text(names.get(nodePos), x -(radius/4), y +(radius/4));
    //text(node.name, x -(radius/4), y +(radius/4));
    text(name, nx -(radius/4), ny +(radius/4));
  }
  
  public String toString(){
    return "Node{ name:"+name+", x:"+x+", y:"+y+", col:"+col+", dx:"+dx+", dy:"+dy+"}";
  }
  public void print(){
    println(this.toString());
  }
}