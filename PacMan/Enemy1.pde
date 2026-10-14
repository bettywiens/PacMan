class Enemy1 extends Enemy {
  boolean colliding = false;
  boolean on_same_level_x = false;
  boolean on_same_level_y = false;

  CreatureDirections last_direction;
  CreatureDirections current;

  float position_x;
  float position_y;

  Enemy1(float grid_x, float grid_y, float speed, boolean is_walkable) {
    super(grid_x, grid_y, speed, "pink", is_walkable);
    last_direction = CreatureDirections.RIGHT;
    current = last_direction;
    position_x = grid_x - (grid_x % 1);
    position_y = grid_y - (grid_y % 1);
  }

  @Override
    void move() {
    super.move();
    setImage();


    float move_x = 0;
    float move_y = 0;
    float step = 0.03125f;

    chooseDirection();

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

    setPosition();

    CollisionResult collision_result = checkCollision(move_x, move_y);
    CollisionResult new_collision_result = checkCollision(move_x + move_x, move_y + move_y);
    if (collision_result != null) {
      println("Kollidieren");
      colliding = true;
      if (collision_result.type.equals(WorldTypes.WALL_BRICK)) {
        WorldObject myObject = world_objects.get(collision_result.id);
        float object_x = myObject.grid_x;
        float object_y = myObject.grid_y;

        // Kollision links und rechts (funktioniert?)
        if (object_x > position_x) {
          println("WAND RECHTS");
          if (last_direction == CreatureDirections.RIGHT) {
            println("Letzte Richtung war rechts.");
            goUp();
          } else if (last_direction == CreatureDirections.LEFT) {
            goUp();
          } 
          else {
            goLeft();
          }
        } else if (object_x < position_x) {
          println("WAND LINKS");
          //println("Gegner: " + position_y);
          //println("Gegner: " + object_y);
          if (last_direction == CreatureDirections.LEFT) {
            goUp();
          } else if (last_direction == CreatureDirections.RIGHT) {
            goUp();
          } else if (last_direction == CreatureDirections.DOWN) {
            goDown();
          } else {
            goRight();
          }
          // Kollision oben und unten (funktioniert nicht ganz)
        } else if (object_y > position_y) {
          println("WAND UNTEN");
          if (last_direction == CreatureDirections.DOWN) {
            goLeft();
          }
        } else if (object_y < position_y) {
          println("WAND OBEN");
          if (last_direction == CreatureDirections.UP) {
            goLeft();
          } else if (last_direction == CreatureDirections.LEFT) {
            goDown();
          } else if (last_direction == CreatureDirections.RIGHT) {
            goDown();
          }
        }
      }
    } else {
      grid_x += move_x;
      pixel_x = convertToPixel(grid_x);
      grid_y += move_y;
      pixel_y = convertToPixel(grid_y);
      colliding = false;
      return;
    }
  }

  void chooseDirection() {
    println("choosing direction");
    if (!colliding) {
      println("searching x");
      searchX();
      searchY();
      println("searching y");
      //searchY();
    } else {
      return;
    }
  }

  void setImage() {
    if (current.equals(CreatureDirections.RIGHT)) {
      setImageContainer(image_right);
    } else if (current.equals(CreatureDirections.LEFT)) {
      setImageContainer(image_left);
    }
  }

  void setPosition() {
    position_x = grid_x - (grid_x % 1);
    position_y = grid_y - (grid_y % 1);
  }

  void searchX() {
    if (!on_same_level_x) {
      if (position_x < player_x) {
        //println("RIGHT");
        changeDirection(CreatureDirections.RIGHT);
        last_direction = CreatureDirections.RIGHT;
      } else if (position_x > player_x) {
        //println("LEFT");
        changeDirection(CreatureDirections.LEFT);
        last_direction = CreatureDirections.LEFT;
      } else if (position_x == player_x) {
        on_same_level_x = true;
        on_same_level_y = false;
        //searchY();
        println("Auf dem gleichen x-Level");
        return;
      }
    }
  }

  void searchY() {
    if (!on_same_level_y) {
      if (position_y < player_y) {
        println("DOWN");

        changeDirection(CreatureDirections.DOWN);
        last_direction = CreatureDirections.DOWN;
        //searchX();
      } else if (position_y > player_y) {
        //println("UP");

        changeDirection(CreatureDirections.UP);
        last_direction = CreatureDirections.UP;
      } else if (position_y == player_y) {
        on_same_level_x = false;
        on_same_level_y = true;
        //searchX();
        println("Auf dem gleichen y-Level");
        return;
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
}
