WorldObject[] hearts;
WorldObject[] numbers;
float player_x;
float player_y;
int SCALE = 3;
int TILE_SIZE = 16 * SCALE;
float PLAYER_SPEED = 0.7f * SCALE;
float ENEMY_SPEED = 0.6f * SCALE;
float ANIMATION_SPEED = 0.1f;
Timer timer;
int window_width;
int window_height;
int lives = 3;
int score = 0;

PImage background;
PImage game_over;

boolean game_lost = false;
boolean player_dead = false;
EndScreen end;


MapLoader map_loader;
KeyHandler key_handler;
ArrayList<WorldObject> world_objects;
ArrayList<WorldObject> walls;

void setup() {
  size(480, 600);
  timer = new Timer(2000);
  timer.start();
  world_objects = new ArrayList<WorldObject>();
  map_loader = new MapLoader(world_objects);

  window_height = map_loader.lines.length * TILE_SIZE;
  window_width = map_loader.characters.length * TILE_SIZE;
  windowResize(window_width, window_height);
  imageMode(CENTER);
  rectMode(CENTER);
  noSmooth();
  key_handler = new KeyHandler();
  end = new EndScreen();  
}

void draw() {
  //println(player_x);
  //println(player_y);
  if (!game_lost) {
    background(187, 212, 121);
    for (int i = 0; i < world_objects.size(); i++) {
      WorldObject object = world_objects.get(i);

      object.drawObject();

      if (object instanceof Creature) {
        Creature creature = (Creature) object;
        creature.move();
        creature.update();
      }
    }
  } else {
    if (player_dead){
      end.printGameOver();
    }
  }
}

void keyPressed() {
  key_handler.pressed();
}

void keyReleased() {
  key_handler.released();
}
