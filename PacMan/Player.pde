class Player extends Creature {
  AnimationImage image_right;
  AnimationImage image_left;
  AnimationImage image_right_damage;
  AnimationImage image_left_damage;
  AnimationImage image_right_scatter;
  AnimationImage image_left_scatter;

  AnimationImage image_standing_right;
  AnimationImage image_standing_left;
  AnimationImage image_standing_right_damage;
  AnimationImage image_standing_left_damage;
  AnimationImage image_standing_right_scatter;
  AnimationImage image_standing_left_scatter;

  AnimationImage image_won;
  NormalImage image_dead;
  boolean facing_right = false;
  boolean facing_left = false;
  boolean player_damaged = false;
  boolean collided_with_enemy = false;


  int counter = 0;
  int time_counter = 0;
  int apple_counter = 0;
  int live_position = 0;
  int live_counter = 0;
  int enemy_counter = 0;
  float diffzeit = 0;
  float zeit = 0;
  float animationszeit = 3000f;

  WorldObject affected_heart;
  NormalImage image_lost_heart;
  NormalImage image_heart;

  Player(float grid_x, float grid_y, float speed, boolean is_walkable) {
    super(WorldTypes.PLAYER, grid_x, grid_y, speed, is_walkable);
    player_x = grid_x;
    player_y = grid_y;

    // normale Bilder
    image_right = new AnimationImage("images/player/walk_right", 3, ANIMATION_SPEED);
    image_left = new AnimationImage("images/player/walk_left", 3, ANIMATION_SPEED);
    image_right_scatter = new AnimationImage("images/player/scatter/walk_right", 3, ANIMATION_SPEED);
    image_left_scatter = new AnimationImage("images/player/scatter/walk_left", 3, ANIMATION_SPEED);
    // standing:
    image_standing_right = new AnimationImage("images/player/standing/standing_right", 2, ANIMATION_STANDING_SPEED);
    image_standing_left = new AnimationImage("images/player/standing/standing_left", 2, ANIMATION_STANDING_SPEED);
    image_standing_right_scatter = new AnimationImage("images/player/scatter/standing/standing_right", 2, ANIMATION_STANDING_SPEED);
    image_standing_left_scatter = new AnimationImage("images/player/scatter/standing/standing_left", 2, ANIMATION_STANDING_SPEED);

    // Damage Bilder
    image_right_damage = new AnimationImage("images/damaged_player/walk_right", 3, ANIMATION_SPEED);
    image_left_damage = new AnimationImage("images/damaged_player/walk_left", 3, ANIMATION_SPEED);
    image_standing_right_damage = new AnimationImage("images/damaged_player/standing/standing_right", 2, ANIMATION_STANDING_SPEED);
    image_standing_left_damage = new AnimationImage("images/damaged_player/standing/standing_left", 2, ANIMATION_STANDING_SPEED);

    // Bilder bei Gewinn und Verlust
    image_won = new AnimationImage("images/player/won", 2, ANIMATION_WON_SPEED);
    image_dead = new NormalImage("images/player/dead.png");

    image_lost_heart = new NormalImage("images/hearts/lost_heart.png");
    image_heart = new NormalImage("images/hearts/heart.png");

    setImageContainer(image_standing_right);
  }

  @Override
    void move() {
    super.move();

    float move_x = 0;
    float move_y = 0;

    float step = 0.125f;

    if (direction.equals(CreatureDirections.UP)) {
      counter++;
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
    } else if (direction.equals(CreatureDirections.STOP)) {
      move_x = 0;
      move_y = 0;
    }

    if (lives < 1) {
      player_dead = true;
      move_x = 0;
      move_y = 0;

      if (timer.isFinished()) {
        //println("is finished");
        time_counter++;
        timer.start();
        if (time_counter == 2) {
          game_lost = true;
        }
      }
    }
    if (amount_coins == 0) {
      //println("score equals coins");
      player_won = true;
      move_x = 0;
      move_y = 0;

      if (timer.isFinished()) {
        time_counter++;
        timer.start();
        if (time_counter == 2) {
          //println("time is up");
          game_won = true;
        }
      }
    }



    CollisionResult collision_result = checkCollision(move_x, move_y);
    if (collision_result != null) {
      if (collision_result.type.equals(WorldTypes.WALL_BRICK)) {
        return;
      } else if (collision_result.type.equals(WorldTypes.COIN)) {
        // Wenn wir mit einer Münze kollidieren, wird diese entfernt vom Spielfeld
        world_objects.remove(collision_result.id);
        amount_coins--;
        // Pro Münze bekommt man einen Punkt
        score++;
        //println(coins.size());
        Score object = new Score(1, 2, false); // temporäres Objekt
        object.showPoints(numbers, score); // Bildet aktuellen Punktstand ab
        return;
        // Wenn der player mit einem Gegner kollidiert, nimmt er Schaden und verliert ein Leben
      } else if (collision_result.type.equals(WorldTypes.POWER_UP)) {
        world_objects.remove(collision_result.id);
        if (lives < 3) {
          lives++;
          live_position--;
          //println("live position: " + live_position);
          affected_heart = hearts[live_position];
          affected_heart.setImageContainer(image_heart);
        }
        //println("Lives: " + lives);
        return;
      } else if (collision_result.type.equals(WorldTypes.ENEMY) && !player_won) {
        if (!scatter_active) {
          collided_with_enemy = false;
          player_damaged = true;
          if (live_counter == 1) { // Stellt sicher, dass man pro Schaden nur ein Leben verliert
            lives--;
            println("Lives: " + lives);
            if (live_position < hearts.length) {
              affected_heart = hearts[live_position]; // Position an der sich das jetzige Leben befindet
              affected_heart.setImageContainer(image_lost_heart);
              live_position++;
            }
          }
        } else {
          //println("caught enemy");
          if (!collided_with_enemy) {
            //println("ADDED TO SCORE");
            score += 5;
            Score object = new Score(1, 2, false); // temporäres Objekt
            object.showPoints(numbers, score); // Bildet aktuellen Punktstand ab
            collided_with_enemy = true;
          }
        }
        enemy_counter++;
        live_counter++;
        // Der Gegner hält einen nicht auf

        grid_x += move_x;
        pixel_x = convertToPixel(grid_x);
        grid_y += move_y;
        pixel_y = convertToPixel(grid_y);
        return;
      }
    } else {
      // Sobald der Schaden vorbei ist, kann man wieder ein Leben verlieren
      live_counter = 0;
      apple_counter = 0;
      player_damaged = false;
      grid_x += move_x;
      pixel_x = convertToPixel(grid_x);
      grid_y += move_y;
      pixel_y = convertToPixel(grid_y);
      update_player();
      return;
    }
  }

  @Override
    void update() {
    if (!player_dead) {
      if (key_handler.up_pressed) {
        changeDirection(CreatureDirections.UP);
        setImage();
      } else if (key_handler.down_pressed) {
        changeDirection(CreatureDirections.DOWN);
        setImage();
      } else if (key_handler.left_pressed) {
        changeDirection(CreatureDirections.LEFT);
        facing_left = true;
        facing_right = false;
        setImage();
      } else if (key_handler.right_pressed) {
        changeDirection(CreatureDirections.RIGHT);
        facing_right = true;
        facing_left = false;
        setImage();
        // Man kann stehen bleiben (Animation passt sich dementsprechend an)
      } else if (!key_handler.up_pressed) {
        changeDirection(CreatureDirections.STOP);
        setImageStop();
      }
    } else {
      setImage();
      setImageStop();
    }
  }

  // Setzt Bild, wenn der Player STEHT, abhängig davon, wie in welche Richtung er sich bewegt und ob er Schaden nimmt
  void setImageStop() {
    if (player_damaged && !player_dead && !player_won) {
      if (facing_left) {
        setImageContainer(image_standing_left_damage);
      } else {
        setImageContainer(image_standing_right_damage);
      }
    } else if (player_dead) {
      setImageContainer(image_dead);
    } else if (player_won) {
      setImageContainer(image_won);
    } else {
      if (facing_left) {
        if (scatter_active) {
          setImageContainer(image_standing_left_scatter);
        } else {
          setImageContainer(image_standing_left);
        }
      } else if (facing_right) {
        if (scatter_active) {
          setImageContainer(image_standing_right_scatter);
        } else {
          setImageContainer(image_standing_right);
        }
      }
    }
  }

  // Setzt Bild, wenn der Player GEHT, abhängig davon, wie er sich bewegt und ob er Schaden nimmt
  void setImage() {
    if (player_damaged && !player_dead && !player_won) {
      if (facing_right) {
        setImageContainer(image_right_damage);
      } else {
        setImageContainer(image_left_damage);
      }
    } else if (player_dead) {
      setImageContainer(image_dead);
    } else if (player_won) {
      setImageContainer(image_won);
    } else {
      if (facing_right) {
        if (scatter_active) {
          setImageContainer(image_right_scatter);
        } else {
          setImageContainer(image_right);
        }
      } else if (facing_left) {
        if (scatter_active) {
          setImageContainer(image_left_scatter);
        } else {
          setImageContainer(image_left);
        }
      }
    }
  }

  void update_player() {
    player_x = grid_x;
    player_y = grid_y;
  }

  boolean collideWithWall(float player_x, float player_y) {
    int counter = 0;
    for (WorldObject wall : walls) {
      if (wall.grid_x != player_x || wall.grid_y != player_y) {
        counter++;
      } else {
        counter += 0;
      }
    }
    if (counter == walls.size()) {
      //println("ist wahr");
      return true;
    } else {
      return false;
    }
  }
}
