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
  boolean in_place = false;
  CreatureDirections last_direction;
  CreatureDirections before_direction;
  CreatureDirections current;
  CreatureDirections last_x_direction;
  CreatureDirections last_y_direction;
  CreatureDirections last_x_wall;
  CreatureDirections last_y_wall;
  boolean colliding = false;


  Enemy(float grid_x, float grid_y, float speed, String colour, boolean is_walkable) {
    super(WorldTypes.ENEMY, grid_x, grid_y, speed, is_walkable);
    last_direction = CreatureDirections.RIGHT;
    before_direction = CreatureDirections.RIGHT;
    current = last_direction;
    last_x_direction = CreatureDirections.RIGHT;
    last_y_direction = CreatureDirections.DOWN;
    last_x_wall = CreatureDirections.RIGHT;
    last_y_wall = CreatureDirections.DOWN;

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

    chooseDirectionRandom();
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
      // NACH RECHTS:
    } else if (direction.equals(CreatureDirections.RIGHT)) {
      counter++;
      if (counter % 2 == 0) {
        move_x = step;
      }
    }

    checkCollisionRandom(move_x, move_y);
    setImage();
  }

  void checkCollisionRandom(float move_x, float move_y) {
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

  void checkCollisionEnemy(float move_x, float move_y) {
    CollisionResult collision_result = checkCollision(move_x, move_y);
    if (collision_result != null) {
      colliding = true;
      if (collision_result.type.equals(WorldTypes.WALL_BRICK)) {
        WorldObject myObject = world_objects.get(collision_result.id);
        float object_x = myObject.grid_x;
        float object_y = myObject.grid_y;

        // Wenn die WAND RECHTS ist:
        if (object_x > position_x) {
          println("WAND RECHTS");
          last_x_wall = CreatureDirections.RIGHT;
          if (last_direction == CreatureDirections.RIGHT) {
            if (before_direction == CreatureDirections.RIGHT) {
              before_direction = CreatureDirections.RIGHT;
              if (last_y_wall == CreatureDirections.DOWN) {
                goUp();
              } else if (last_y_wall == CreatureDirections.UP) {
                goDown();
              }
            } else {
              before_direction = CreatureDirections.RIGHT;
              goUp();
            }
          } else if (last_direction == CreatureDirections.LEFT) {
            if (before_direction == CreatureDirections.UP) {
              before_direction = CreatureDirections.LEFT;
              goLeft();
            } else {
              before_direction = CreatureDirections.LEFT;
              goUp();
            }
          } else {
            before_direction = last_direction;
            goLeft();
          }
          // Wenn die WAND LINKS ist:
        } else if (object_x < position_x) {
          println("WAND LINKS");
          last_x_wall = CreatureDirections.LEFT;
          if (last_direction == CreatureDirections.LEFT) {
            if (before_direction == CreatureDirections.LEFT) {
              before_direction = CreatureDirections.LEFT;
              if (last_y_wall == CreatureDirections.UP) {
                goDown();
              } else if (last_y_wall == CreatureDirections.DOWN) {
                goUp();
              }
            } else {
              before_direction = CreatureDirections.LEFT;
              goRight();
            }
          } else if (last_direction == CreatureDirections.RIGHT) {
            before_direction = CreatureDirections.RIGHT;
            goUp();
          } else if (last_direction == CreatureDirections.DOWN) {
            before_direction = CreatureDirections.DOWN;
            goDown();
          } else {
            before_direction = last_direction;
            goRight();
          }
          // Wenn die WAND UNTEN ist:
        } else if (object_y > position_y) {
          println("WAND UNTEN");
          last_y_wall = CreatureDirections.DOWN;
          if (last_direction == CreatureDirections.DOWN) {
            before_direction = CreatureDirections.DOWN;
            if (last_x_wall == CreatureDirections.LEFT) {
              goRight();
            } else if (last_x_wall == CreatureDirections.RIGHT) {
              goLeft();
            }
          } else if (last_direction == CreatureDirections.RIGHT) {
            if (before_direction == CreatureDirections.RIGHT) {
              before_direction = CreatureDirections.RIGHT;
              goUp();
            }
          } else {
            before_direction = last_direction;
          }
          // Wenn die WAND OBEN ist:
        } else if (object_y < position_y) {
          println("WAND OBEN");
          last_y_wall = CreatureDirections.UP;
          if (last_direction == CreatureDirections.UP) {
            if (before_direction == CreatureDirections.RIGHT) {
              before_direction = CreatureDirections.UP;
              goRight();
            } else if (before_direction == CreatureDirections.LEFT) {
              before_direction = CreatureDirections.UP;
              goRight();
            } else if (before_direction == CreatureDirections.UP) {
              // Hier muss noch unterschieden werden ob es eine rechte oder linke ecke ist
              before_direction = CreatureDirections.UP;
              if (last_x_wall == CreatureDirections.LEFT) {
                goRight(); // oben links Ecke
              } else if (last_x_wall == CreatureDirections.RIGHT) {
                goLeft(); // oben rechts Ecke
              }
            } else {
              before_direction = CreatureDirections.UP;
              goLeft();
            }
          } else if (last_direction == CreatureDirections.LEFT) {
            if (before_direction == CreatureDirections.UP) {
              before_direction = CreatureDirections.LEFT;
              goLeft();
            } else {
              before_direction = last_direction;
              goRight();
            }
          } else if (last_direction == CreatureDirections.RIGHT) {
            if (before_direction == CreatureDirections.UP) {
              before_direction = CreatureDirections.RIGHT;
              goLeft();
            } else {
              before_direction = last_direction;
              goRight();
            }
          } else {
            before_direction = last_direction;
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

  void chooseDirectionRandom() {
    if (!scatter_active) {
      return;
    } else {
      if (!colliding) {
        searchX(corner_up_left_x, true);
        searchY(corner_up_left_y, true);
      } else {
        return;
      }
    }
  }

  void searchX(float person_x, boolean seeing) {
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
        if (seeing) {
          on_same_level_x = true;
          on_same_level_y = false;
        }
        return;
      }
    }
  }

  void searchY(float person_y, boolean seeing) {
    if (!on_same_level_y) {
      if (position_y < person_y) {
        changeDirection(CreatureDirections.DOWN);
        last_direction = CreatureDirections.DOWN;
      } else if (position_y > person_y) {
        changeDirection(CreatureDirections.UP);
        last_direction = CreatureDirections.UP;
      } else if (position_y == person_y) {
        if (seeing) {
          on_same_level_x = false;
          on_same_level_y = true;
        }
        return;
      }
    }
  }

  void randomDirection() {
    int direction_number = round(random(0, 3));
    CreatureDirections random_direction = CreatureDirections.values()[direction_number];
    changeDirection(random_direction);
    last_direction = random_direction;
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
    last_x_direction = CreatureDirections.LEFT;
    colliding = false;
    return;
  }

  void goRight() {
    //println("RIGHT");
    changeDirection(CreatureDirections.RIGHT);
    last_direction = CreatureDirections.RIGHT;
    last_x_direction = CreatureDirections.RIGHT;
    colliding = false;
    return;
  }

  void goUp() {
    //println("UP");
    changeDirection(CreatureDirections.UP);
    last_direction = CreatureDirections.UP;
    last_y_direction = CreatureDirections.UP;
    colliding = false;
    return;
  }

  void goDown() {
    //println("DOWN");
    changeDirection(CreatureDirections.DOWN);
    last_direction = CreatureDirections.DOWN;
    last_y_direction = CreatureDirections.DOWN;
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

  void chooseDirection(boolean seeing, float corner_x, float corner_y) {
    if (!scatter_active) {
      if (!colliding) {
        in_place = false;
        searchX(player_x, seeing); // Sucht nach X Position vom Ziel
        searchY(player_y, seeing); // Sucht nach Y Position vom Ziel
      } else {
        return;
      }
    } else {
      if (!colliding && !in_place) {
        // Geht im Scattermode nach oben rechts
        checkIfInCorner(grid_x, grid_y, corner_x, corner_y);
        searchX(corner_up_right_x, seeing);
        searchY(corner_up_right_y, seeing);
      } else {
        return;
      }
    }
  }

  void checkIfInCorner(float player_x, float player_y, float corner_x, float corner_y) {
    if (player_x == corner_x && player_y == corner_y) {
      in_place = true;
    }
  }

  // Sagt auf welchem Tile wird uns befinden:
  void getPosition() {
    position_x = grid_x - (grid_x % 1);
    position_y = grid_y - (grid_y % 1);
  }
}
