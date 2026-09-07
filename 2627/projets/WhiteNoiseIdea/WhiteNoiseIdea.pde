// ===========================
// EASY SETTINGS
// ===========================

final int RAY_COUNT = 100;

final int GRID_W = 100;
final int GRID_H = 100;

final float START_VALUE = 100.0;

final float VARIATION = 1.0;          // ±100%
final float NEIGHBOR_BLEND = 0.40;

final int GENERATION_DURATION_MS = 1000;


// ===========================
// DATA
// ===========================

float[][] values = new float[GRID_W][GRID_H];
boolean[][] generated = new boolean[GRID_W][GRID_H];

int centerX;
int centerY;

int currentRadius;
int maxRadius;

float nextRadiusTime;
float msPerRadius;

boolean finished;


// ===========================
// SETUP
// ===========================

void setup() {
  size(800, 800);
  noStroke();

  resetGeneration();
}


// ===========================
// DRAW
// ===========================

void draw() {
  background(0);

  animateGeneration();
  drawGrid();
}


// ===========================
// KEYBOARD
// ===========================

void keyPressed() {
  if (key == 'r' || key == 'R') {
    resetGeneration();
  }
}


// ===========================
// RESET
// ===========================

void resetGeneration() {

  // Clear everything
  for (int x = 0; x < GRID_W; x++) {
    for (int y = 0; y < GRID_H; y++) {
      values[x][y] = 0;
      generated[x][y] = false;
    }
  }

  // Center
  centerX = GRID_W / 2;
  centerY = GRID_H / 2;

  values[centerX][centerY] = START_VALUE;
  generated[centerX][centerY] = true;

  // Distance from center to furthest corner
  int furthestX = max(centerX, GRID_W - 1 - centerX);
  int furthestY = max(centerY, GRID_H - 1 - centerY);

  maxRadius = ceil(
    sqrt(
      sq(furthestX) +
      sq(furthestY)
    )
  );

  currentRadius = 1;

  msPerRadius =
    GENERATION_DURATION_MS / (float) maxRadius;

  nextRadiusTime = millis();

  finished = false;
}


// ===========================
// ANIMATION
// ===========================

void animateGeneration() {

  if (finished) {
    return;
  }

  while (
    !finished &&
    millis() >= nextRadiusTime
  ) {

    processRadius(currentRadius);

    currentRadius++;

    nextRadiusTime += msPerRadius;

    if (currentRadius > maxRadius) {
      finished = true;
    }
  }
}


// ===========================
// PROCESS ONE RADIUS
// ===========================

void processRadius(int radius) {

  /*
    Tiny angular offset every second ring.

    This prevents every ring from hitting
    exactly the same pixel alignments.
  */

  float angleOffset;

  if (radius % 2 == 0) {
    angleOffset = 0.5;
  } else {
    angleOffset = 0.0;
  }


  // Fire rays around the full circle
  for (int ray = 0; ray < RAY_COUNT; ray++) {

    float angleDegrees =
      (ray + angleOffset)
      * 360.0
      / RAY_COUNT;

    float angle = radians(angleDegrees);


    int x = round(
      centerX +
      cos(angle) * radius
    );

    int y = round(
      centerY +
      sin(angle) * radius
    );


    // Ignore coordinates outside the grid
    if (!insideGrid(x, y)) {
      continue;
    }


    // Already generated
    if (generated[x][y]) {
      continue;
    }


    generateCell(x, y, angle);
  }


  // Rays can skip some pixels because
  // we're projecting a circle onto a grid.
  // Fill small local holes afterward.
  fillSmallHoles(radius);
}


// ===========================
// GENERATE CELL
// ===========================

void generateCell(
  int x,
  int y,
  float angle
) {

  /*
    Look approximately one cell inward
    along the same ray.
  */

  float inwardX =
    x - cos(angle);

  float inwardY =
    y - sin(angle);


  int baseX = round(inwardX);
  int baseY = round(inwardY);


  /*
    Maximum possible candidates in a
    3x3 region = 9.
  */

  int[] parentX = new int[9];
  int[] parentY = new int[9];

  int parentCount = 0;


  float childDistance =
    dist(
      x,
      y,
      centerX,
      centerY
    );


  // ===========================
  // FIND INWARD PARENTS
  // ===========================

  for (int ox = -1; ox <= 1; ox++) {
    for (int oy = -1; oy <= 1; oy++) {

      int px = baseX + ox;
      int py = baseY + oy;


      if (!insideGrid(px, py)) {
        continue;
      }


      if (!generated[px][py]) {
        continue;
      }


      float parentDistance =
        dist(
          px,
          py,
          centerX,
          centerY
        );


      /*
        A parent should be closer
        to the center than the child.
      */

      if (parentDistance >= childDistance) {
        continue;
      }


      parentX[parentCount] = px;
      parentY[parentCount] = py;

      parentCount++;
    }
  }


  // ===========================
  // FALLBACK
  // ===========================

  /*
    If ray geometry missed every inward
    parent, use any already-generated
    neighboring cell.
  */

  if (parentCount == 0) {

    for (int ox = -1; ox <= 1; ox++) {
      for (int oy = -1; oy <= 1; oy++) {

        if (ox == 0 && oy == 0) {
          continue;
        }


        int px = x + ox;
        int py = y + oy;


        if (!insideGrid(px, py)) {
          continue;
        }


        if (!generated[px][py]) {
          continue;
        }


        parentX[parentCount] = px;
        parentY[parentCount] = py;

        parentCount++;
      }
    }
  }


  // Still isolated
  if (parentCount == 0) {
    return;
  }


  // ===========================
  // SELECT PARENT
  // ===========================

  int selected =
    int(random(parentCount));


  int px = parentX[selected];
  int py = parentY[selected];


  float parentValue =
    values[px][py];


  // ===========================
  // EVOLUTION
  // ===========================

  float minimumMultiplier =
    1.0 - VARIATION;

  float maximumMultiplier =
    1.0 + VARIATION;


  float evolved =
    parentValue *
    random(
      minimumMultiplier,
      maximumMultiplier
    );


  // ===========================
  // LOCAL COHERENCE
  // ===========================

  float result = evolved;


  int neighborCount =
    getGeneratedNeighborCount(
      x,
      y
    );


  if (neighborCount > 0) {

    float neighborAverage =
      getNeighborAverage(
        x,
        y
      );


    result =
      lerp(
        evolved,
        neighborAverage,
        NEIGHBOR_BLEND
      );
  }


  values[x][y] = result;
  generated[x][y] = true;
}


// ===========================
// FILL SMALL GAPS
// ===========================

void fillSmallHoles(int radius) {

  /*
    We don't immediately modify generated[][].

    Otherwise pixels generated early in this
    loop would influence pixels later in the
    same loop and create directional bias.
  */

  boolean[][] shouldFill =
    new boolean[GRID_W][GRID_H];

  float[][] fillValue =
    new float[GRID_W][GRID_H];


  // ===========================
  // FIND HOLES
  // ===========================

  for (int x = 0; x < GRID_W; x++) {
    for (int y = 0; y < GRID_H; y++) {


      if (generated[x][y]) {
        continue;
      }


      float dx =
        x - centerX;

      float dy =
        y - centerY;


      float distance =
        sqrt(
          dx * dx +
          dy * dy
        );


      /*
        Only examine cells close
        to this current ring.
      */

      if (
        abs(distance - radius)
        > 1.25
      ) {
        continue;
      }


      int count =
        getGeneratedNeighborCount(
          x,
          y
        );


      /*
        Require several real generated
        neighbors before filling.
      */

      if (count >= 3) {

        float avg =
          getNeighborAverage(
            x,
            y
          );


        // Tiny additional variation
        avg *= random(
          0.97,
          1.03
        );


        shouldFill[x][y] = true;
        fillValue[x][y] = avg;
      }
    }
  }


  // ===========================
  // APPLY HOLES
  // ===========================

  for (int x = 0; x < GRID_W; x++) {
    for (int y = 0; y < GRID_H; y++) {

      if (!shouldFill[x][y]) {
        continue;
      }


      values[x][y] =
        fillValue[x][y];

      generated[x][y] =
        true;
    }
  }
}


// ===========================
// NEIGHBOR AVERAGE
// ===========================

float getNeighborAverage(
  int x,
  int y
) {

  float total = 0;
  int count = 0;


  for (int ox = -1; ox <= 1; ox++) {
    for (int oy = -1; oy <= 1; oy++) {


      if (ox == 0 && oy == 0) {
        continue;
      }


      int nx = x + ox;
      int ny = y + oy;


      // Ignore coordinates outside the grid
      if (!insideGrid(nx, ny)) {
        continue;
      }


      // Ignore cells that don't exist yet
      if (!generated[nx][ny]) {
        continue;
      }


      total +=
        values[nx][ny];

      count++;
    }
  }


  if (count == 0) {
    return 0;
  }


  return total / count;
}


// ===========================
// NEIGHBOR COUNT
// ===========================

int getGeneratedNeighborCount(
  int x,
  int y
) {

  int count = 0;


  for (int ox = -1; ox <= 1; ox++) {
    for (int oy = -1; oy <= 1; oy++) {


      if (ox == 0 && oy == 0) {
        continue;
      }


      int nx = x + ox;
      int ny = y + oy;


      /*
        IMPORTANT:

        Only count an actual cell if:
        1. it exists inside the grid
        2. it has already been generated

        Out-of-bounds positions do NOT count.
      */

      if (
        insideGrid(nx, ny) &&
        generated[nx][ny]
      ) {
        count++;
      }
    }
  }


  return count;
}


// ===========================
// DRAW GRID
// ===========================

void drawGrid() {

  float cellW =
    width / (float) GRID_W;

  float cellH =
    height / (float) GRID_H;


  float minValue =
    Float.MAX_VALUE;

  float maxValue =
    -Float.MAX_VALUE;


  boolean foundValue = false;


  // ===========================
  // FIND CURRENT RANGE
  // ===========================

  for (int x = 0; x < GRID_W; x++) {
    for (int y = 0; y < GRID_H; y++) {


      if (!generated[x][y]) {
        continue;
      }


      float value =
        values[x][y];


      minValue =
        min(
          minValue,
          value
        );


      maxValue =
        max(
          maxValue,
          value
        );


      foundValue = true;
    }
  }


  if (!foundValue) {
    return;
  }


  // ===========================
  // DRAW
  // ===========================

  for (int x = 0; x < GRID_W; x++) {
    for (int y = 0; y < GRID_H; y++) {


      if (!generated[x][y]) {
        continue;
      }


      float brightness;


      if (
        abs(maxValue - minValue)
        < 0.000001
      ) {

        brightness = 128;

      } else {

        brightness =
          map(
            values[x][y],
            minValue,
            maxValue,
            0,
            255
          );
      }


      fill(brightness);


      rect(
        x * cellW,
        y * cellH,
        cellW + 1,
        cellH + 1
      );
    }
  }
}


// ===========================
// BOUNDS
// ===========================

boolean insideGrid(
  int x,
  int y
) {

  return
    x >= 0 &&
    x < GRID_W &&
    y >= 0 &&
    y < GRID_H;
}