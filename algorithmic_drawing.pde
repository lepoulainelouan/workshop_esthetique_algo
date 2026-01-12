PVector curve(float t){
  float a = 220;
  float b = 140;

  float x = a * cos(t) + b * cos(4*t);
  float y = a * sin(t) - b * sin(4*t);

  return new PVector(x, y);
}

int baseLayers = 5;
float rotStep;

color[] palette; 

void setup(){
  pixelDensity(1);
  fullScreen(P3D);


  palette = new color[5];
  palette[0] = color(210, 80, 90); 
  palette[1] = color(200, 60, 80); 
  palette[2] = color(180, 70, 85);
  palette[3] = color(160, 50, 90);
  palette[4] = color(140, 60, 80);
}

void draw(){
  background(0, 0, 100);
  translate(width/2, height/2);


  int layers = baseLayers + int(map(mouseX, 0, width, 0, 40));
  rotStep = TWO_PI / layers;

  drawShape(layers);
}

void drawShape(int layers){
  float time = frameCount * 0.01; 

  for(int i=0; i<layers; i++){

    float depth = i / float(layers);


    color c = palette[i % palette.length];
    float alpha = map(i, 0, layers, 80, 150);
    stroke(hue(c), saturation(c), brightness(c), alpha);
    strokeWeight(3);


    float twist = sin(i * 0.15 + time) * 0.15;

    pushMatrix();
    rotate(i * rotStep + time + twist);
    scale(1.0 + depth * 0.15);

    drawCurve();

    popMatrix();
  }

}

void drawCurve(){
  noFill();
  beginShape();
  for(float t = 0; t < TWO_PI; t += 0.01){
    PVector p = curve(t);
    vertex(p.x, p.y);
  }
  endShape(CLOSE);
}
