int cols = 250;
int rows = 250;
int cellSize;
int[][] grid; 
int[][] nextGrid; 
/////////////////////////
class Walker {
  float x, y;
  float angle;
  float speed;
  Walker(float x_, float y_, float speed_) {
    x = x_;
    y = y_;
    angle = random(TWO_PI);
    speed = speed_;
  }
  void step() {

    angle += random(-PI/10, PI/10);//courbe des tunnels !!

    float nx = x + cos(angle)*speed;
    float ny =y + sin(angle)*speed;

    nx = constrain(nx, 1, cols-2);
    ny = constrain(ny, 1, rows-2);

    int ix = int(nx);
    int iy = int(ny);

    if(grid[ix][iy]==0){
      float r = random(1);
      if(r<0.06) createOrganicChamber(ix, iy);//Grande !chambre des fourmies
      else if(r<0.08) createSpecialChamber(ix, iy);//petite nurserie et petite zone de stockage
      else grid[ix][iy] = 1;//sinon tunnel

      createWalls(ix, iy);
    }


    if(random(1)<0.01) angle += random(-PI/2, PI/2); //rajout de bifurcation pour simuler comme des caillou en travers de la route et faire un tunnel plus joli/logique naturel

    x = nx;
    y = ny;
  }
}

ArrayList<Walker> walkers = new ArrayList<Walker>();
int totalSteps =6000;//(parametre pour arreter la simu), apres que la colonie ait fait 6000 pas, tout le monde meurt !! (la vie est triste malheureusement)
int stepsPerFrame =2; 
int currentStep =0;
int numWalkers =6; 

void setup(){
  size(1000,1000);
  cellSize = width/cols;
  grid = new int[cols][rows];
  nextGrid = new int[cols][rows];

  int cx = cols/2;
  int cy = rows/2;

  grid[cx][cy] = 2;
  createOrganicChamber(cx, cy);


  for(int i=0;i<numWalkers;i++){ //les fourmies marchent plus ou moins vite parce que pourquoi PAS 
    walkers.add(new Walker(cx, cy, random(0.2,0.6)));
  }
}

void draw(){
  background(20,20,30);
  noStroke();


  for(int s=0;s<stepsPerFrame && currentStep<totalSteps;s++){
    for(Walker w : walkers){
      w.step();
      currentStep++;
      if(currentStep>=totalSteps) break;
    }
  }


  for(int i=0;i<cols;i++){ //la c'est la terre à creuser / grid
    for(int j=0;j<rows;j++){
      switch(grid[i][j]){
        case 0: fill(20,20,30); break;    //fond
        case 1: fill(180,150,120); break; //galerie/tunel
        case 2: fill(250,220,180); break; //chambre des fourmies
        case 3: fill(50,50,60); break;    //mur
        case 4: fill(200,240,180); break; //nurserie pour les bébés/stockage
      }
      rect(i*cellSize,j*cellSize,cellSize,cellSize);
    }
  }

  if(currentStep>=totalSteps) noLoop();
}


void createOrganicChamber(int cx,int cy){ //la chambre principale des fourmies
  int w = int(random(3,6));
  int h = int(random(3,6));
  for(int i=-w;i<=w;i++){
    for(int j=-h;j<=h;j++){
      int nx=cx+i;
      int ny=cy+j;
      if(nx>0 && nx<cols-1 && ny>0 && ny<rows-1){
        float distNorm = pow(i/(float)w,2)+pow(j/(float)h,2);
        if(distNorm<=1.2){
          grid[nx][ny]=2;
          if(random(1)<0.05){
            int ex = nx + int(random(-1,2));
            int ey = ny + int(random(-1,2));
            if(ex>0 && ex<cols-1 && ey>0 && ey<rows-1) grid[ex][ey]=2;
          }
          createWalls(nx, ny);
        }
      }
    }
  }
}

void createSpecialChamber(int cx,int cy){//nurserie/stockage
  int w =int(random(2,5.5));
  int h = int(random(2,4));
  for(int i=-w;i<=w;i++){
    for(int j=-h;j<=h;j++){
      int nx=cx+i;
      int ny=cy+j;
      if(nx>0 && nx<cols-1 && ny>0 && ny<rows-1){
        float distNorm = pow(i/(float)w,2)+pow(j/(float)h,2);
        if(distNorm<=1.2){
          grid[nx][ny]=4;
          createWalls(nx, ny);
        }
      }
    }
  }
}


void createWalls(int cx,int cy){
  for(int i=-1;i<=1;i++){
    for(int j =-1;j<=1;j++){
      int nx=cx+i;
      int ny=cy+j;
      if(nx>0 && nx<cols-1 && ny>0 && ny<rows-1){
        if(grid[nx][ny]==0) grid[nx][ny]=3;
      }
    }
  }
}
