class Enemy extends Creature {
  AnimationImage image_right;
  AnimationImage image_left;
  AnimationImage scatter_left;
  AnimationImage scatter_right;
  int counter = 0;


  Enemy(float grid_x, float grid_y, float speed, String colour, boolean is_walkable) {
    super(WorldTypes.ENEMY, grid_x, grid_y, speed, is_walkable);

    image_right = new AnimationImage("images/enemy/" + colour + "/walk_right", 3, ANIMATION_SPEED);
    image_left = new AnimationImage("images/enemy/" + colour + "/walk_left", 3, ANIMATION_SPEED);

    scatter_right = new AnimationImage("images/enemy/" + colour + "/scatter/walk_right", 3, ANIMATION_SPEED);
    scatter_left = new AnimationImage("images/enemy/" + colour + "/scatter/walk_left", 3, ANIMATION_SPEED);

    setImageContainer(image_right);
    ArrayList<WorldTypes> collision_filter = new ArrayList<WorldTypes>();
    collision_filter.add(WorldTypes.COIN);
    collision_filter.add(WorldTypes.POWER_UP);
    collision_filter.add(WorldTypes.PLAYER);
    setCollisionFilter(collision_filter);
  }

  @Override
    void move() {
    super.move();

    float move_x = 0;
    float move_y = 0;
    float step = 0.03125f;

    if (direction.equals(CreatureDirections.UP)) {
      counter++;
      //println(counter);
      if (counter % 2 == 0) {
        move_y = -step;
      }
    } else if (direction.equals(CreatureDirections.DOWN)) {
      counter++;
      if (counter % 2 == 0) {
        move_y = step;
      }
    } else if (direction.equals(CreatureDirections.LEFT)) {
      counter++;
      if (counter % 2 == 0) {
        move_x = -step;
      }
    } else if (direction.equals(CreatureDirections.RIGHT)) {
      counter++;
      if (counter % 2 == 0) {
        move_x = step;
      }
    }

    CollisionResult collision_result = checkCollision(move_x, move_y);
    //CollisionResult new_collision_result = checkCollision(move_x + move_x, move_y + move_y);
    if (collision_result != null) {
      if (collision_result.type.equals(WorldTypes.WALL_BRICK)) {
        randomDirection();
        return;
      }
    } else {
      grid_x += move_x;
      pixel_x = convertToPixel(grid_x);
      grid_y += move_y;
      pixel_y = convertToPixel(grid_y);
      return;
    }
  }


  void randomDirection() {
    int direction_number = round(random(0, 3));
    CreatureDirections random_direction = CreatureDirections.values()[direction_number];
    changeDirection(random_direction);

    if (random_direction.equals(CreatureDirections.LEFT)) {
      if (scatter_active) {
        setImageContainer(scatter_left);
      } else {
        setImageContainer(image_left);
      }
    } else if (random_direction.equals(CreatureDirections.RIGHT)) {
      if (scatter_active) {
        setImageContainer(scatter_right);
      } else {
        setImageContainer(image_right);
      }
    }
  }
}
