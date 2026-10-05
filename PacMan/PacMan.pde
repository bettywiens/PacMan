float SCALE = 2;
float TILE_SIZE = 16 * SCALE;
float PLAYER_SPEED = 0.7f * SCALE;
float ENEMY_SPEED = 0.6f * SCALE;
float ANIMATION_SPEED = 0.1f;

KeyHandler key_handler;
ArrayList<WorldObject> world_objects;

void setup() {
  size(600, 600);
  imageMode(CENTER);
  rectMode(CENTER);
  noSmooth();
  key_handler = new KeyHandler();
  world_objects = new ArrayList<WorldObject>();
  new MapLoader(world_objects);
}

void draw() {
  background(200);
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
