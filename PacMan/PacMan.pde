int SCALE = 2;
int TILE_SIZE = 16 * SCALE;
float PLAYER_SPEED = 0.7f * SCALE;
float ENEMY_SPEED = 0.6f * SCALE;
float ANIMATION_SPEED = 0.1f;
int window_width;
int window_height;




KeyHandler key_handler;
ArrayList<WorldObject> world_objects;

void setup() {
  size(480, 600);
  world_objects = new ArrayList<WorldObject>();
  MapLoader map = new MapLoader(world_objects);
  window_height = map.lines.length * TILE_SIZE;
  window_width = map.characters.length * TILE_SIZE;
  windowResize(window_width, window_height);
  imageMode(CENTER);
  rectMode(CENTER);
  noSmooth();
  key_handler = new KeyHandler();
}

void draw() {
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
}

void keyPressed() {
  key_handler.pressed();
}

void keyReleased() {
  key_handler.released();
}
