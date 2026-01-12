float[][] data = {
  {0, 0},
  {0, 2},
  {2, -1}
};

void setup() {
  size(640, 400);
  colorMode(HSB, 360, 100, 100);
  background(0);
  noFill();
  smooth();

  drawCurves();
}

void drawCurves() {
  for (float x = 1; x <= 1100; x += 4) {

    float x1 = x/2;
    float y1 = (x/10.0) * sin(x/20.0) + x/20.0 + height/5.0;

    float x2 = 50 * sin(width/x/70.0) + height/2.0;
    float y2 = (x/4.0) * sin(x/120.0) + width/5.0;

    // LES COULEURS
    float hue = (x * 0.4) % 360;
    float sat = 80;
    float bri = 100;

    stroke(hue, sat, bri, 80);
    strokeWeight(1.5);

    line(x1, y1, x2, y2);
  }
}
