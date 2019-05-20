import netP5.*;
import oscP5.*;
import java.util.ListIterator;
import lord_of_galaxy.timing_utils.*;
import codeanticode.syphon.*;
SyphonServer server;


float _val;

float vib = 0;


int z= 1 ;
PImage img, img1, m, f, p, g ;
PImage photo;
ArrayList<Brique> mesBriques;
ArrayList<Brique> mesBriques1;
ArrayList<Brique> mesBriques2; // 2 liste
int num = 200; // contenance du tableau
int k ;
int l ;


dispersion C1 = new dispersion(100, 100, 40, 16); 

OscP5 oscP5;
NetAddress adresse;


Stopwatch s;

void setup() {

  size(1050, 1400, P3D);
  oscP5= new OscP5 (this, 12000);
  adresse = new NetAddress("127.0.0.1", 9000);

  server = new SyphonServer(this, "Processing Syphon");

  s = new Stopwatch(this);
  s.start(); // on lance le chrono

  // declaration des listes de briques
  mesBriques = new ArrayList();   
  mesBriques1 = new ArrayList();
  mesBriques2 = new ArrayList();

  strokeWeight(2);
  background(0);
  //strokeWeight(random(0,4));

  for (int y=0; y<height; y+=20) {
    for (int x=0; x<width; x+=42) {
      Brique b = new Brique(x, y);
      mesBriques.add(b);
    }
  }

  // Liste 1 : 
  for (int y=0; y<height; y+=20) {
    for (int x=0; x<width; x+=100) {
      Brique b = new Brique(x, y);
      mesBriques1.add(b);
    }
  }

  // Liste 2 : décalé par 50 pixels sur l'axe X
  for (int y=0; y<height; y+=20) {
    for (int x=50; x<width; x+=100) { //x+=100
      Brique b = new Brique(x, y);
      mesBriques2.add(b);
    }
  }

/*  img = loadImage("gaba.jpg");
  img1 = loadImage("f0.png");
  m = loadImage("moulure.png");
  f = loadImage("f1.png");
  p = loadImage("porte.png");
  g = loadImage("g.png");
  photo = loadImage("gaba.jpg"); */
}


void draw() {
    stroke(255);
    noFill();
  k = int(random(0, 1749)); // taille de l'index

 //image(img, 0, 0);


  if (( s.time() > 0) && ( s.time() < 20000) ) { 

    OscMessage myMessage = new OscMessage("/sequence");  
    myMessage.add(20); 
    oscP5.send(myMessage, adresse); 

    C1.dessiner(200);
  
  }


  if (( s.time() > 20000) &&(s.time() < 40000)) { // le moment où le sketch commence
    background(0);
    stroke(255);
    OscMessage myMessage = new OscMessage("/sequence");  
    myMessage.add(21); 
    oscP5.send(myMessage, adresse); 


    pushMatrix();

    translate(0, 0, -10);
    // animation 1  avec vibration
    for (int i=0; i<mesBriques.size(); i++) {   
      mesBriques.get(i).display();
      mesBriques.get(i).animate1(vib);//vibration
    }        

    for (int i=k; i<k+1; i++) {   
      // mesBriques.get(l).col = color(255,255,0);
      mesBriques.get(i).display();
    }
    popMatrix();
  }


  if (s.time() > 40000) {
    background(0);
    // animation 2 verticale
    strokeWeight(random(0, 3));

    pushMatrix();
    translate(0, 0, -10);
    ListIterator<Brique> iter = mesBriques1.listIterator();
    while (iter.hasNext()) {
      Brique b = iter.next();

      b.display();
      b.animateY(1, 1.73); // nouvelle méthod - voir dans la classe ;–)

      //si nos briques qui descendent sortent du champ, on les supprime
      // mais nous rajoutons également des nouveaux à notre liste...
      // sinon, en supprimant, nous n'aurons plus de briques ;—)
      // pareil pour les autres en bas

      if (b.y>height) {
        iter.remove();
        b = new Brique(b.x, 0);
        iter.add(b);
      }
    }
    popMatrix();

    pushMatrix();
    translate(0, 0, -10);

    ListIterator<Brique> iter2 = mesBriques2.listIterator();
    while (iter2.hasNext()) {
      Brique b = iter2.next();
      b.display();
      b.animateY(0, 2.3); // nouvelle méthod - voir dans la classe ;–)

      if (b.y<0) {
        iter2.remove();
        b = new Brique(b.x, height);
        iter2.add(b);
      }
    }
    popMatrix();
  }





 
   
 pushMatrix();
 rectMode(CORNERS);
 fill(0);
  noStroke();
  
  //la partie gauche en haut
  rect(54,301,322,316);
  rect(60,316,314,333);
  rect(80,333,302,370);
  //fenetre noir
  rect(112,370,265,494);
  //les choses en bas
  rect(86,494,288,514);
  rect(101,514,276,536);
  rect(119,536,260,560);
  rect(154,560,227,751);
  rect(174,751,209,762);
  
  
  //Les trois musketeer
  rect(386,266,527,575);
  rect(582,266,726,575);
  rect(782,266,925,575);
  //Les trucs en bas
  rect(359,575,955,593);
  rect(370,593,943,646);
  
  //En bas à gauche
  arc(190,1075,308,246,-PI,0);
  rect(93,1075,292,1150);
  rect(114,1180,273, 1241);
  
  //En bas à droit
  arc(655,936,474,438,-PI,0);
  rect(471,923,829,1233);
  rect(427,1103,880,1233);
  
  rectMode(CORNER);
  popMatrix();
  
   server.sendScreen();
  if (s.time() > 60000) {
    OscMessage myMessage = new OscMessage("/exit");  
    myMessage.add(3); 
    oscP5.send(myMessage, adresse); 

    exit();
  }

 
}

void oscEvent(OscMessage msg) {

  if (msg.checkAddrPattern("/note"))
  {

    int index = int(random(mesBriques.size()));  // rend blanche la brique determinée par k
    mesBriques.get(index).col = color(255, 255, 255);  // rend blanche la brique determinée par k
    vib = vib + 0.02; //
  }
}




class Brique {

  float x;
  float y;
  float longeur;
  float hauteur;
  color col;

  Brique(float _x, float _y) {

    x = _x;
    y = _y;
    longeur = 30;
    hauteur = 12;
    col = color(255, 255, 255, 0);
  }

  void animate1(float _val) {
    y += random(-_val, _val);
  }

  /**
   * Méthode pour animer nos briques sur l'axe Y
   * @param _direction : la valeur change la direction > 0 vers le haut || 1 vers le bas
   * @param _s : détermine la "vitesse"
   */
  void animateY(int _direction, float _s) {
    if (_direction == 0) {
      y-=_s;
    } else if (_direction == 1) {
      y+=_s;
    }
  }


  void display() {

    if (( s.time() >20000) &&( s.time() <30000)) { //le moment où apparait le 2e sketch

      stroke(col);
      noFill();
      rect(x, y, longeur, hauteur);
    } else {


      stroke(255);
      noFill();
      rect(x, y, longeur, hauteur);
    }
  }


  boolean test() {
    boolean b = false;
    if ((this.y > height) || ((this.y < 0))) {
      b = true;
    }
    return b;
  }
}



////////////////////////



class dispersion {
  float xpos, ypos, longueur, hauteur;
  dispersion(float x, float y, float l, float h) 

  { 
    xpos= x;
    ypos= y;
    longueur = l;
    hauteur = h;
  }

  void dessiner(float degres) {
    pushMatrix();
    xpos = xpos + (random(-50, 50)); //déplace xpos dans la limite de +/- 15px
    ypos = ypos + (random(-50, 50)); //déplace ypos dans la limite de +/- 15px
    rect(xpos, ypos, longueur, hauteur); // dessine la quebri

    if (xpos >= 1050) // condition de non depassement du champ donné
    {
      xpos = xpos + (random(-30, 0));
    }  

    if (xpos <= 0)
    {
      xpos = xpos + (random(0, 30));
    }  

    if (ypos >= 1400)
    {
      ypos = ypos + (random(-30, 0));
    }  

    if (ypos <= 0)
    {
      ypos = ypos + (random(0, 30));
    }  

    popMatrix();

    // wave.setFrequency(ypos);}
  }
}