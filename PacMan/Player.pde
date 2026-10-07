class Player extends Creature {
  AnimationImage image_right;
  AnimationImage image_left;
  int counter = 0;

  Player(float grid_x, float grid_y, float speed) {
    super(WorldTypes.PLAYER, grid_x, grid_y, speed);
    image_right = new AnimationImage("images/player/walk_right", 3, ANIMATION_SPEED);
    image_left = new AnimationImage("images/player/walk_left", 3, ANIMATION_SPEED);
    setImageContainer(image_right);
  }

  @Override
    void move() {
    super.move();

    float move_x = 0;
    float move_y = 0;
    
  
  
    if (direction.equals(CreatureDirections.UP)) {
      counter++;
      println(counter);
      if (counter % 2 == 0) {
        move_y = -0.125;
      }         
    } else if (direction.equals(CreatureDirections.DOWN)) {
      counter++;
      if (counter % 2 == 0) {
        move_y = 0.125;
      }
    } else if (direction.equals(CreatureDirections.LEFT)) {
      counter++;
      if (counter % 2 == 0) {
        move_x = -0.125;
      }
    } else if (direction.equals(CreatureDirections.RIGHT)) {
      counter++;
      if (counter % 2 == 0) {
        move_x = 0.125;
      }
    } else if (direction.equals(CreatureDirections.STOP)) {
      move_x = 0;
      move_y = 0;
      //counter = 0;
    }


    CollisionResult collision_result = checkCollision(move_x, move_y);
    if (collision_result != null) {
      if (collision_result.type.equals(WorldTypes.WALL_BRICK)) {
        return;
      } else if (collision_result.type.equals(WorldTypes.COIN)) {
        // Wenn wir mit einer Münze kollidieren, wird diese entfernt vom Spielfeld
        world_objects.remove(collision_result.id);
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


  @Override
    void update() {
    if (key_handler.up_pressed) {
      changeDirection(CreatureDirections.UP);
    } else if (key_handler.down_pressed) {
      changeDirection(CreatureDirections.DOWN);
    } else if (key_handler.left_pressed) {
      changeDirection(CreatureDirections.LEFT);
      setImageContainer(image_left);
    } else if (key_handler.right_pressed) {
      changeDirection(CreatureDirections.RIGHT);
      setImageContainer(image_right);
    } else if (!key_handler.up_pressed) {
      changeDirection(CreatureDirections.STOP);
    } else if (!key_handler.down_pressed) {
      changeDirection(CreatureDirections.STOP);
    } else if (!key_handler.right_pressed) {
      changeDirection(CreatureDirections.STOP);
    } else if (!key_handler.left_pressed) {
      changeDirection(CreatureDirections.STOP);
    }
  }
}
