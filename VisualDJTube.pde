//The MIT License (MIT) - See Licence.txt for details

//Copyright (c) 2013 Mick Grierson, Matthew Yee-King, Marco Gillies


int[] deckX = new int[4];
boolean[] deckPlaying = new boolean[4];
float[] rotateDeck = new float[4];
AudioPlayer[] player = new AudioPlayer[4];
int[][] colors = {{255, 0, 0}, {0, 255, 0}, {0, 0, 255}, {255, 255, 255}};

PImage [] recordPlayer;
int recordWidth = 150;
int recordHeight = 150;
Maxim maxim;
int MEMORY_SIZE = 200;
float[][] memory = new float[4][MEMORY_SIZE];


void setup()
{
  size(768,1024);
  imageMode(CENTER);
  recordPlayer = loadImages("black-record_", ".png", 36);
  maxim = new Maxim(this);
  player[0] = maxim.loadFile("audiocheck.net_sin_300Hz_-3dBFS_3s.wav");
  player[0].setLooping(true);
  player[1] = maxim.loadFile("audiocheck.net_sqr_250Hz_-3dBFS_3s.wav");
  player[1].setLooping(true);
  player[2] = maxim.loadFile("audiocheck.net_tri_250Hz_-3dBFS_3s.wav");
  player[2].setLooping(true);
  player[3] = maxim.loadFile("audiocheck.net_saw_300Hz_-3dBFS_3s.wav");
  player[3].setLooping(true);
  background(10);
}

void draw()
{
  background(10); 
  imageMode(CENTER);
  for (int i = 0; i < deckX.length; i++) {
    deckX[i] = (2*i + 1) * width / 8;
    image(recordPlayer[(int) rotateDeck[i]], deckX[i], 3*recordHeight/4,
          recordWidth, recordHeight);

    if (deckPlaying[i]) {
      rotateDeck[i] += 1;

      if (rotateDeck[i] >= recordPlayer.length) {
        rotateDeck[i] = 0;
      }
    }
  }

  for (int i = 0; i < memory.length; i++) {
    for (int j = 1; j < MEMORY_SIZE; j++) {
      memory[i][j - 1] = memory[i][j];
    }
    memory[i][MEMORY_SIZE - 1] = player[i].getSample() / 500;

    for (int j = 1; j < MEMORY_SIZE; j++) {
      int prev = j - 1;
      stroke(colors[i][0], colors[i][1], colors[i][2]);
      line(prev*width/MEMORY_SIZE, memory[i][prev] + 300 + 100*i,
           j*width/MEMORY_SIZE, memory[i][j] + 300 + 100*i);
    }
  }
}


void mouseClicked()
{
  for (int i = 0; i < deckX.length; i++) {
    if (dist(mouseX, mouseY, deckX[i], recordHeight/2) < recordWidth/2) {
      deckPlaying[i] = !deckPlaying[i];
    }

    if (deckPlaying[i]) {
      player[i].play();
    } else {
      player[i].stop();
    }
  }
}
