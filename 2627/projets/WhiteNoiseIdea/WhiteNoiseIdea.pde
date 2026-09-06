// ===========================
// EASY SETTINGS
// ===========================

final int RAY_COUNT = 100;

final int GRID_W = 100;
final int GRID_H = 100;

final float START_VALUE = 100.0;

final float VARIATION = 1.0;        // ±100%
final float NEIGHBOR_BLEND = 0.40;

final int GENERATION_DURATION_MS = 1000;

// ===========================
// DATA
// ===========================

float[][] values =
  new float[GRID_W][GRID_H];

boolean[][] generated =
  new boolean[GRID_W][GRID_H];

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

  for (int x = 0; x < GRID_W; x++) {
    for (int y = 0; y < GRID_H; y++) {

      values[x][y] = 0;
      generated[x][y] = false;
    }
  }

  centerX = GRID_W / 2;
  centerY = GRID_H / 2;

  values[centerX][centerY] =
    START_VALUE;

  generated[centerX][centerY] =
    true;

  maxRadius = ceil(
    sqrt(
      sq(max(centerX, GRID_W - 1 - centerX)) +
      sq(max(centerY, GRID_H - 1 - centerY))
    )
  );

  currentRadius = 1;

  msPerRadius =
    GENERATION_DURATION_MS
    / (float) maxRadius;

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
   * Slight angular offset between rings
   * avoids repeatedly hitting the exact same
   * grid alignments.
   */

  float angleOffset =
    (radius % 2 == 0)
    ? 0.5
    : 0.0;


  for (int ray = 0; ray < RAY_COUNT; ray++) {

    float angleDegrees =
      (ray + angleOffset)
      * 360.0
      / RAY_COUNT;

    float angle =
      radians(angleDegrees);


    int x = round(
      centerX +
      cos(angle) * radius
    );

    int y = round(
      centerY +
      sin(angle) * radius
    );


    if (!insideGrid(x, y)) {
      continue;
    }

    if (generated[x][y]) {
      continue;
    }


    generateCell(x, y, angle);
  }


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
   * Step one cell backward along
   * the ray, toward the center.
   */

  float inwardX =
    x - cos(angle);

  float inwardY =
    y - sin(angle);


  int baseX =
    round(inwardX);

  int baseY =
    round(inwardY);


  // ===========================
  // FIND POSSIBLE PARENTS
  // ===========================

  int[] parentX = new int[9];
  int[] parentY = new int[9];

  int parentCount = 0;


  /*
   * Search the 3x3 area around the
   * point immediately behind the new cell.
   */

  for (int ox = -1; ox <= 1; ox++) {
    for (int oy = -1; oy <= 1; oy++) {

      int px =
        baseX + ox;

      int py =
        baseY + oy;


      if (!insideGrid(px, py)) {
        continue;
      }

      if (!generated[px][py]) {
        continue;
      }


      /*
       * Only allow cells that are actually
       * closer to the center than the new cell.
       */

      float parentDist =
        dist(
          px,
          py,
          centerX,
          centerY
        );

      float childDist =
        dist(
          x,
          y,
          centerX,
          centerY
        );


      if (parentDist >= childDist) {
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
   * If somehow no inward parent exists,
   * use any generated neighbor.
   */

  if (parentCount == 0) {

    for (int ox = -1; ox <= 1; ox++) {
      for (int oy = -1; oy <= 1; oy++) {

        if (ox == 0 && oy == 0) {
          continue;
        }

        int px =
          x + ox;

        int py =
          y + oy;


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


  /*
   * Still nothing?
   * Extremely unlikely, but just skip.
   */

  if (parentCount == 0) {
    return;
  }


  // ===========================
  // RANDOM PARENT
  // ===========================

  int selected =
    int(random(parentCount));

  int px =
    parentX[selected];

  int py =
    parentY[selected];


  float parentValue =
    values[px][py];


  // ===========================
  // EVOLUTION
  // ===========================

  float evolved =
    parentValue *
    random(
      1.0 - VARIATION,
      1.0 + VARIATION
    );


  // ===========================
  // COHERENCE
  // ===========================

  float result =
    evolved;

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


  values[x][y] =
    result;

  generated[x][y] =
    true;
}


// ===========================
// FILL SMALL GAPS
// ===========================

void fillSmallHoles(int radius) {

  boolean[][] shouldFill =
    new boolean[GRID_W][GRID_H];

  float[][] fillValue =
    new float[GRID_W][GRID_H];


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


      if (count >= 3) {

        float avg =
          getNeighborAverage(
            x,
            y
          );


        /*
         * Add a tiny amount of noise,
         * otherwise filled cells become
         * suspiciously smooth.
         */

        avg *= random(
          0.97,
          1.03
        );


        shouldFill[x][y] =
          true;

        fillValue[x][y] =
          avg;
      }
    }
  }


  // Apply afterward.

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


      int nx =
        x + ox;

      int ny =
        y + oy;


      if (!insideGrid(nx, ny)) {
        continue;
      }

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


  return
    total / count;
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


      int nx =
        x + ox;

      int ny =
        y + oy;


      if (!insideGrid(nx, ny)) {
        continue;
      }


      if (generated[nx][ny]) {
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


  for (int x = 0; x < GRID_W; x++) {
    for (int y = 0; y < GRID_H; y++) {

      if (!generated[x][y]) {
        continue;
      }


      minValue =
        min(
          minValue,
          values[x][y]
        );

      maxValue =
        max(
          maxValue,
          values[x][y]
        );
    }
  }


  for (int x = 0; x < GRID_W; x++) {
    for (int y = 0; y < GRID_H; y++) {

      if (!generated[x][y]) {
        continue;
      }


      float brightness;


      if (maxValue == minValue) {

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