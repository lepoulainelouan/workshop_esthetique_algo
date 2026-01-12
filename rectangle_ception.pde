int Xrsl, Yrsl;
int N = 0;
int D = 0;
int X, Y;

void setup() {
  size(640, 400);
  Xrsl = width - 1;
  Yrsl = height - 1;

  background(255);
  stroke(50);
  noFill();

  drawRectangles();
}

void drawRectangles() {
  X = Xrsl;
  Y = Yrsl;

  while (N < Y) {
    D = D + 1;         
    strokeWeight(D);
    N = N + D + 1;
    X = X - D - 10;
    Y = Y - D - 10;

    rect(N, N, X - N, Y - N);
  }
}
