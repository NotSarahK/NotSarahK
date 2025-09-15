// Windows 95/98 Style Loading Bar (fixed fitting & centering)

int barWidth = 400;
int barHeight = 30;
int blockWidth = 20;
int blockHeight = 20;

int gap = 2;                          // visual gap between blocks
int step = blockWidth;                // spacing from one block to next
int fillW = blockWidth - gap;         // actual drawn width of each block
int totalBlocks = barWidth / blockWidth;

int currentFrame = 0;
int maxFrames = totalBlocks + 10;     // Extra frames for pause at end
boolean saveFrames = false;

void setup() {
  size(500, 100);
  background(192, 192, 192); // Win95 gray
  noSmooth();
}

void draw() {
  background(192, 192, 192);

  // Define the inner content rect once
  int innerX = 50;
  int innerY = 35;
  int innerW = barWidth;
  int innerH = barHeight;

  // Draw the window-style border & inner background
  drawWindowBorder(innerX, innerY, innerW, innerH);

  // Compute the total width of all blocks including gaps (no gap after last)
  int contentWidthNeeded = totalBlocks * step - gap;

  // Center the strip horizontally inside the inner area
  int xStart = innerX + (innerW - contentWidthNeeded) / 2;

  // Center blocks vertically inside the inner area
  int yStart = innerY + (innerH - blockHeight) / 2;

  // How many blocks are filled this frame?
  int blocksToFill = (currentFrame * totalBlocks) / (maxFrames - 10);
  blocksToFill = constrain(blocksToFill, 0, totalBlocks);

  // Draw the blocks
  for (int i = 0; i < totalBlocks; i++) {
    int x = xStart + i * step;
    int y = yStart;

    if (i < blocksToFill) {
      drawFilledBlock(x, y, fillW, blockHeight);
    } else {
      drawEmptyBlock(x, y, fillW, blockHeight);
    }
  }

  // Loading text
  fill(0);
  textAlign(CENTER, BASELINE);
  textSize(12);
  text("Loading Next Level...", width/2, 85);

  // Save frames if enabled
  if (saveFrames) {
    saveFrame("frames/loading-####.png");
  }

  // Animation control
  currentFrame++;
  if (currentFrame >= maxFrames) currentFrame = 0;

  delay(100);
}

void drawWindowBorder(int x, int y, int w, int h) {
  // Outer dark border
  stroke(64, 64, 64);
  strokeWeight(1);
  noFill();
  rect(x-2, y-2, w+4, h+4);

  // Inset highlight top/left
  stroke(255);
  line(x-1, y-1, x+w, y-1);
  line(x-1, y-1, x-1, y+h);

  // Inset shadow right/bottom
  stroke(128, 128, 128);
  line(x+w, y-1, x+w, y+h);
  line(x-1, y+h, x+w, y+h);

  // Inner background
  noStroke();
  fill(255);
  rect(x, y, w, h);
}

void drawFilledBlock(int x, int y, int w, int h) {
  // Main blue
  noStroke();
  fill(0, 0, 128);
  rect(x, y, w, h);

  // Highlight (top/left)
  fill(128, 128, 255);
  rect(x, y, w, 1);
  rect(x, y, 1, h);

  // Shadow (bottom/right)
  fill(0, 0, 64);
  rect(x, y + h - 1, w, 1);
  rect(x + w - 1, y, 1, h);
}

void drawEmptyBlock(int x, int y, int w, int h) {
  // Empty block with subtle border
  stroke(192, 192, 192);
  strokeWeight(1);
  fill(240, 240, 240);
  rect(x, y, w, h);
}

void keyPressed() {
  if (key == 's' || key == 'S') {
    saveFrames = !saveFrames;
    println(saveFrames ? "Frame saving enabled" : "Frame saving disabled");
  }
  if (key == 'r' || key == 'R') {
    currentFrame = 0;
    println("Animation reset");
  }
}
