class Player extends Creature {
  AnimationImage image_right;
  AnimationImage image_right_damage;
  AnimationImage image_left;
  AnimationImage image_left_damage;
  NormalImage image_standing_right;
  NormalImage image_standing_right_damage;
  NormalImage image_standing_left;
  NormalImage image_standing_left_damage;
  NormalImage image_dead;
  boolean facing_right = false;
  boolean facing_left = false;
  boolean player_damaged = false;

  int counter = 0;
  int time_counter = 0;
  int apple_counter = 0;
  int live_position = 0;
  int live_counter = 0;
  float diffzeit = 0;
  float zeit = 0;
  float animationszeit = 3000f;

  WorldObject affected_heart;
  NormalImage image_lost_heart;
  NormalImage image_heart;

  Player(float grid_x, float grid_y, float speed) {
    super(WorldTypes.PLAYER, grid_x, grid_y, speed);
    player_x = grid_x;
    player_y = grid_y;
    image_right = new AnimationImage("images/player/walk_right", 3, ANIMATION_SPEED);
    image_right_damage = new AnimationImage("images/damaged_player/walk_right", 3, ANIMATION_SPEED);
    image_left = new AnimationImage("images/player/walk_left", 3, ANIMATION_SPEED);
    image_left_damage = new AnimationImage("images/damaged_player/walk_left", 3, ANIMATION_SPEED);
    image_standing_right = new NormalImage("images/player/walk_right_1.png");
    image_standing_right_damage = new NormalImage("images/damaged_player/walk_right_1.png");
    image_standing_left = new NormalImage("images/player/walk_left_1.png");
    image_standing_left_damage = new NormalImage("images/damaged_player/walk_left_1.png");
    image_lost_heart = new NormalImage("images/hearts/lost_heart.png");
    image_heart = new NormalImage("images/hearts/heart.png");
    image_dead = new NormalImage("images/player/dead.png");
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
        println("is finished");
        time_counter++;
        timer.start();
        if (time_counter == 2) {
          game_lost = true;
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
        // Pro Münze bekommt man einen Punkt
        score++;
        Score object = new Score(1,2); // temporäres Objekt
        object.showPoints(numbers, score); // Bildet aktuellen Punktstand ab
        return;
        // Wenn der player mit einem Gegner kollidiert, nimmt er Schaden und verliert ein Leben
      } else if (collision_result.type.equals(WorldTypes.POWER_UP)) {
        world_objects.remove(collision_result.id);
        if (lives < 3){
          lives++;
          live_position--;
          println("live position: " + live_position);
          affected_heart = hearts[live_position];
          affected_heart.setImageContainer(image_heart);
        }
        println("Lives: " + lives);
        return;
      } else if (collision_result.type.equals(WorldTypes.ENEMY)) {
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

  // Setzt Bild, wenn der Player steht, abhängig davon, wie in welche Richtung er sich bewegt und ob er Schaden nimmt
  void setImageStop() {
    if (player_damaged && !player_dead) {
      if (facing_left) {
        setImageContainer(image_standing_left_damage);
      } else {
        setImageContainer(image_standing_right_damage);
      }
    } else if (player_dead) {
      setImageContainer(image_dead);
    } else {
      if (facing_left) {
        setImageContainer(image_standing_left);
      } else if (facing_right) {
        setImageContainer(image_standing_right);
      }
    }
  }

  // Setzt Bild, wenn der Player geht, abhängig davon, wie er sich bewegt und ob er Schaden nimmt
  void setImage() {
    if (player_damaged && !player_dead) {
      if (facing_right) {
        setImageContainer(image_right_damage);
      } else {
        setImageContainer(image_left_damage);
      }
    } else if (player_dead) {
      setImageContainer(image_dead);
    } else {
      if (facing_right) {
        setImageContainer(image_right);
      } else if (facing_left) {
        setImageContainer(image_left);
      }
    }
  }

  void update_player() {
    player_x = grid_x;
    player_y = grid_y;
  }
}
