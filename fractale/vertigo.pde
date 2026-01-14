float time = 0;
float rotationAngle = 0;
int layers= 6; 
int numPoints= 1500; 
////// VERTIGOOOOOO
void setup() {
  size(800, 800);
  smooth(8);
}

void draw() {
  background(235, 110, 60);

  translate(width/ 2,height / 2);

  rotationAngle += 0.003;
  time += 0.02;
for (int layer= 0;layer < layers; layer++) {
    float prevX= 0;
    float prevY = 0;

    float layerPulseOffset = layer * 0.35;
    float layerAngleOffset = layer * 0.2;

    for (int i = 0; i < numPoints; i++) {

      float angle = i * 0.14 +3 * log(1 + i * 0.02) +rotationAngle + time + layerAngleOffset;


      float zoom = 30 * (1 + 0.9 * sin(time * 0.5 + layerPulseOffset));
      float radius = pow(1.015, i) * 3.5 * zoom * (0.75 + 0.15 * sin(time + i * 0.05 + layerPulseOffset));

      float x = cos(angle) * radius;
      float y = sin(angle) * radius;

      float alpha = map(i, 0, numPoints, 255 - layer * 40, 60 - layer * 10);


      float w = max(1.5, 6 - layer); 

      stroke(245,238, 220, alpha);
      strokeWeight(w);
      line(prevX, prevY, x, y);

      prevX =x;
      prevY = y;
    }
  }
}
