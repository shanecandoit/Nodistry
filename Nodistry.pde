 //<>// //<>//
import java.util.ArrayList;
import java.util.List;

int RED   = color(255, 0, 0);
int GREEN = color(0, 255, 0);

int camX = 0;
int camY = 0;

int msRdownX=0;
int msRdownY=0;

//int radius = 32;
float zoom = 1;
int   radius = floor(32*zoom);

String status = "middle mouse pans camera, scrollwheel zooms";

// list of nodes
List<Node> nodes;

// for right click connections
Node edgeBegin;
Node edgeEnd;

// for left click moving
Node nodeMoving;

void setup() {
  size(800, 400);

  nodes = createNodes();
}

void vert(int x, int col) {
  stroke(col);
  line(x-camX, 0, x-camX, height);
}
void horiz(int y, int col) {
  stroke(col);
  line(0, y-camY, width, y-camY);
}
void draw() {

  background(200);
  grid(radius);

  text("camX "+camX, 10, 15);
  text("camY "+camY, 10, 30);
  text("zoom "+zoom, 10, 45);
  text("status: "+status, 10, height-20);

  text("mouseX "+mouseX, 100, 15);
  text("mouseY "+mouseY, 100, 30);

  //rect(0-camX, 0-camY, radius, radius);

  // horiz axis
  //stroke(RED);
  //line(0, -camY, width, -camY);
  horiz(0, RED);

  // vert axis
  //stroke(GREEN);
  //line(-camX, 0, -camX, height);
  vert(0, GREEN);

  // draw nodes
  nodesDraw( nodes );

  // draw line on right click
  if (mouseButton==mRight) {
    //
    stroke(0x0000ff);
    if (msRdownX!=0 && msRdownX!=0) {
      line(msRdownX, msRdownY, mouseX, mouseY);
    }
  }
}

void grid(int space) {
  stroke(190);
  int buffer=2*space;
  for (int y=buffer; y<height; y+= space) {
    // horiz
    line(0, y, width, y);
  }
  for (int x=0; x<width; x+= space) {
    // vert
    line(x, buffer, x, height);
  }
}

int mLeft=37;
int mMid=3;
int mRight=39;
void mousePressed() {
  //println("mousePressed ",mouseButton);
  if (mouseButton==mMid) {
    status = "middle mouse pans camera";
  }

  if (mouseButton==mRight) {
    cursor(CROSS);
    status = "right mouse connects nodes";

    msRdownX=mouseX;
    msRdownY=mouseY;

    List<Node> beginNodes = nodesUnderMouse(nodes);
    if (beginNodes.size()>0) {
      edgeBegin = beginNodes.get(0);
      println("connect node "+edgeBegin.id+" to ...");
    }
  }

  // click on status to get new tip
  // YAGNI
  //if(mouseButton==mLeft && 
  //  (mouseX>=10 && mouseX<=100) &&
  //  (mouseY>=height-45 && mouseY<=height-5) ){
  //  status= "new tip."+mouseX+" "+mouseY;
  //}


  if (mouseButton==mLeft) {
    List<Node> hoverNodes = nodesUnderMouse(nodes);
    if ( hoverNodes.size()>0 ) {
      //
      cursor(HAND);
      nodeMoving = hoverNodes.get(0);
    }
  }
}

void mouseDragged() {
  if (mouseButton==mMid) {
    cursor(MOVE);
    //int dx = mouseX-pmouseX;
    //int dy = mouseY-pmouseY;
    int dx = pmouseX-mouseX;
    int dy = pmouseY-mouseY;
    camX+=dx;
    camY+=dy;
  }

  if (mouseButton==mLeft && nodeMoving!=null) {
    //
    int dx = pmouseX-mouseX;
    int dy = pmouseY-mouseY;
    nodeMoving.x-=dx;
    nodeMoving.y-=dy;
  }
}
void mouseReleased() {
  cursor(ARROW);

  //
  List<Node> endNodes = nodesUnderMouse(nodes);
  if (endNodes.size()>0) {
    Node edgeEnd = endNodes.get(0);
    // dont connect to yourself
    if(edgeBegin==null || edgeEnd==null || edgeBegin.id==edgeEnd.id){
      return;
    }
    println("connect node "+edgeBegin.id+" to "+edgeEnd.id);
    edgeBegin.addEdge(edgeEnd);

    // TODO store this connection somehow

    // reset it
    edgeBegin=null;
    edgeEnd=null;
  }

  msRdownX=0;
  msRdownY=0;
  
  if(nodeMoving!=null){
    println("moved node "+nodeMoving.id);
    nodeMoving=null;
  }
}
void mouseWheel(MouseEvent e) {
  float co = e.getCount();
  //println("wheel count "+co);
  if (co>0) {
    zoom += 0.1;
  } else {
    zoom -= 0.1;
  }
  if (zoom<0.1) {
    zoom=0.1;
  }
  if (zoom>10) {
    zoom=10;
  }
  zoom = round(zoom*10);
  zoom /= 10;
  radius = floor(32*zoom);
}
void mouseMoved() {

  // get the nodes under the mouse
  List<Node> underMouse = nodesUnderMouse( nodes );
  int size=underMouse.size();
  if (size>0) {
    println("underMouse "+size);
    status = "over "+size+" nodes";
  } else {
    status ="";
  }
}

void keyPressed() {
  println("keyPressed "+keyCode+" "+key);
  if (key=='r') {
    camX*=0.9;
    camY*=0.9;
  }

  // save an image
  if (key==' ') {
    String filename = "screenshot.png";
    saveFrame(filename);
    println("saved frame:"+filename);
  }
}

String node(int x, int y, int id, int colr, String name) {
  String res= x+" "+y+" "+id+" "+colr+" "+name;
  println("node "+res);
  return res;
}



List<Node> createNodes() {
  int count = 10;
  List<Node> nodes = new ArrayList();
  for (int i=0; i<count; i++) {
    Node node = new Node();
    nodes.add( node );
  }
  return nodes;
}

List<Node> nodesUnderMouse( List<Node> nodes ) {
  boolean debugMouse=false;
  List<Node> underMouse = new ArrayList();
  for (Node node : nodes) {
    if ( node.x-camX-radius <= mouseX ) {
      if (debugMouse) {
        vert(node.x-radius, RED);
      }
      if ( node.x-camX+radius >= mouseX ) {
        // x under

        if (debugMouse) {
          vert(node.x+radius, RED);
        }
        //println("mouseX "+mouseX);
        //println("mouseY "+mouseY);
        //println("x nodesUnderMouse "+node.id);
        if ( node.y-camY-radius <= mouseY ) {
          if (debugMouse) {
            horiz(node.y-radius, RED);
          }
          if (node.y-camY+radius >= mouseY ) {
            // y under

            if (debugMouse) {
              horiz(node.y+radius, RED);
            }
            underMouse.add(node);
            println("nodesUnderMouse "+node.id);
          }
        }
      }
    }
  }
  return underMouse;
}

void nodesDraw( List<Node> nodes ) {
  for (Node node : nodes) {
    node.draw();
  }
  for (Node node : nodes) {
    node.drawEdges();
  }
}

class Node {

  int x, y, id, col;
  String name;
  Node(int x, int y, int id, int colr, String name) {
    this.x=x;
    this.y=y;
    this.id=id;
    this.col=colr;
    this.name=name;
  }
  Node() {
    x = floor(random(width));
    y = floor(random(height));
    id = (int)random(9999);
    col = color( random(255), random(255), random(255)); 
    name = ""+id;
  }
  void move() {
    if (this.x%radius!=0) {
      this.x-=random(1.1);
    }
    if (this.y%radius!=0) {
      this.y-=random(1.1);
    }
  }
  void draw() {
    move();

    fill(col);
    stroke(0);
    rectMode(RADIUS);
    rect(x-camX, y-camY, radius, radius);
    fill(0);
    textSize(radius/2);
    text(""+id, x-camX, y-camY +radius/2);

    boolean showAttract=true;
    if (showAttract) {
      //
      noFill();
      stroke(0, 150, 0, 50);
      ellipse(x-camX, y-camY, attractRadius(), attractRadius());
      fill(0);
    }

    boolean showRepel=true;
    if (showRepel) {
      //
      noFill();
      stroke(150, 0, 0, 50);
      ellipse(x-camX, y-camY, repelRadius(), repelRadius());
      fill(0);
    }
  }

  void drawEdges() {
    // edges
    for (Node targ : edges) {
      stroke(0x0000ff);
      //rect(x-camX, y-camY, radius, radius);
      line( this.x-camX, this.y-camY, targ.x-camX, targ.y-camY);
    }
  }

  String toString() {
    String res= "Node:{"+x+" "+y+" "+id+" "+col+" "+name+"}";
    println("node.toString() "+res);
    return res;
  }

  // nodes want to be close
  int attractRadius() {
    return radius* 10;
  }

  // but not too close
  int repelRadius() {
    return radius*5;
  }

  // edges
  List<Node> edges = new ArrayList();
  void addEdge(Node sink) {
    // check whether this is already an edge?
    if ( edges.contains(sink) ) {
      return;// dont add again
    }
    edges.add(sink);
  }
}