class Enemy extends Creature {
  AnimationImage image_right;
  AnimationImage image_left;
  AnimationImage scatter_left;
  AnimationImage scatter_right;
  int counter = 0;
  float position_x;
  float position_y;
  boolean on_same_level_x = false;
  boolean on_same_level_y = false;
  CreatureDirections last_direction;
  CreatureDirections current;
  boolean colliding = false;


  Enemy(float grid_x, float grid_y, float speed, String colour, boolean is_walkable) {
    super(WorldTypes.ENEMY, grid_x, grid_y, speed, is_walkable);
    last_direction = CreatureDirections.RIGHT;
    current = last_direction;

    position_x = grid_x - (grid_x % 1);
    position_y = grid_y - (grid_y % 1);

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

    chooseDirection();
    setImage();

    // NACH OBEN:
    if (direction.equals(CreatureDirections.UP)) {
      counter++;
      if (counter % 2 == 0) {
        move_y = -step;
      }
      // NACH UNTEN:
    } else if (direction.equals(CreatureDirections.DOWN)) {
      counter++;
      if (counter % 2 == 0) {
        move_y = step;
      }
      // NACH LINKS:
    } else if (direction.equals(CreatureDirections.LEFT)) {
      counter++;
      if (counter % 2 == 0) {
        move_x = -step;
      }
      //setImages(CreatureDirections.LEFT); // setzt Laufanimation nach links
      // NACH RECHTS:
    } else if (direction.equals(CreatureDirections.RIGHT)) {
      counter++;
      if (counter % 2 == 0) {
        move_x = step;
      }
      //setImages(CreatureDirections.RIGHT); // setzt Laufanimation nach rechts
    }

    CollisionResult collision_result = checkCollision(move_x, move_y);
    //CollisionResult new_collision_result = checkCollision(move_x + move_x, move_y + move_y);
    if (collision_result != null) {
      colliding = true;
      if (collision_result.type.equals(WorldTypes.WALL_BRICK)) {
        randomDirection();
        return;
      }
    } else {
      colliding = false;
      grid_x += move_x;
      pixel_x = convertToPixel(grid_x);
      grid_y += move_y;
      pixel_y = convertToPixel(grid_y);
      return;
    }
  }

  void chooseDirection() {
    if (!scatter_active) {
      return;
    } else {
      println("choosing direction");
      if (!colliding) {
        println("searching x");
        searchX(corner_up_left_x);
        searchY(corner_up_left_y);
        println("searching y");
        //searchY();
      } else {
        return;
      }
    }
  }

  void searchX(float person_x) {
    if (!on_same_level_x) {
      if (position_x < person_x) {
        //println("RIGHT");
        changeDirection(CreatureDirections.RIGHT);
        last_direction = CreatureDirections.RIGHT;
      } else if (position_x > person_x) {
        //println("LEFT");
        changeDirection(CreatureDirections.LEFT);
        last_direction = CreatureDirections.LEFT;
      } else if (position_x == person_x) {
        on_same_level_x = true;
        on_same_level_y = false;
        //searchY();
        println("Auf dem gleichen x-Level");
        return;
      }
    }
  }

  void searchY(float person_y) {
    if (!on_same_level_y) {
      if (position_y < person_y) {
        println("DOWN");

        changeDirection(CreatureDirections.DOWN);
        last_direction = CreatureDirections.DOWN;
        //searchX();
      } else if (position_y > person_y) {
        //println("UP");

        changeDirection(CreatureDirections.UP);
        last_direction = CreatureDirections.UP;
      } else if (position_y == person_y) {
        on_same_level_x = false;
        on_same_level_y = true;
        //searchX();
        println("Auf dem gleichen y-Level");
        return;
      }
    }
  }

  void randomDirection() {
    int direction_number = round(random(0, 3));
    CreatureDirections random_direction = CreatureDirections.values()[direction_number];
    changeDirection(random_direction);
  }

  void setImages(CreatureDirections direction) {
    if (direction == CreatureDirections.RIGHT) {
      if (scatter_active) {
        setImageContainer(scatter_right);
      } else {
        setImageContainer(image_right);
      }
    } else {
      if (scatter_active) {
        setImageContainer(scatter_left);
      } else {
        setImageContainer(image_left);
      }
    }
  }

  void goLeft() {
    //println("LEFT");
    changeDirection(CreatureDirections.LEFT);
    last_direction = CreatureDirections.LEFT;
    colliding = false;
    return;
  }

  void goRight() {
    //println("RIGHT");
    changeDirection(CreatureDirections.RIGHT);
    last_direction = CreatureDirections.RIGHT;
    colliding = false;
    return;
  }

  void goUp() {
    //println("UP");
    changeDirection(CreatureDirections.UP);
    last_direction = CreatureDirections.UP;
    colliding = false;
    return;
  }

  void goDown() {
    //println("DOWN");
    changeDirection(CreatureDirections.DOWN);
    last_direction = CreatureDirections.DOWN;
    colliding = false;
    return;
  }

  // Setzt das Bild abhängig von der Richtung und Scattermode:
  void setImage() {
    current = last_direction;
    if (current.equals(CreatureDirections.RIGHT)) {
      if (scatter_active) {
        setImageContainer(scatter_right);
      } else {
        setImageContainer(image_right);
      }
    } else if (current.equals(CreatureDirections.LEFT)) {
      if (scatter_active) {
        setImageContainer(scatter_left);
      } else {
        setImageContainer(image_left);
      }
    }
  }
}
