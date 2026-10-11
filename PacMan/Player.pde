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

  Player(float grid_x, float grid_y, float speed) {
    super(WorldTypes.PLAYER, grid_x, grid_y, speed);
    image_right = new AnimationImage("images/player/walk_right", 3, ANIMATION_SPEED);
    image_right_damage = new AnimationImage("images/damaged_player/walk_right", 3, ANIMATION_SPEED);
    image_left = new AnimationImage("images/player/walk_left", 3, ANIMATION_SPEED);
    image_left_damage = new AnimationImage("images/damaged_player/walk_left", 3, ANIMATION_SPEED);
    image_standing_right = new NormalImage("images/player/walk_right_1.png");
    image_standing_right_damage = new NormalImage("images/damaged_player/walk_right_1.png");
    image_standing_left = new NormalImage("images/player/walk_left_1.png");
    image_standing_left_damage = new NormalImage("images/damaged_player/walk_left_1.png");
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
    } //else if (direction.equals(CreatureDirections.STOP)) {
      //move_x = 0;
      //move_y = 0;      
    //}


    CollisionResult collision_result = checkCollision(move_x, move_y);
    if (collision_result != null) {
      if (collision_result.type.equals(WorldTypes.WALL_BRICK)) {
        return;
      } else if (collision_result.type.equals(WorldTypes.COIN)) {
        // Wenn wir mit einer Münze kollidieren, wird diese entfernt vom Spielfeld
        world_objects.remove(collision_result.id);
        return;
      } else if (collision_result.type.equals(WorldTypes.ENEMY)) {
        player_damaged = true;
        grid_x += move_x;
        pixel_x = convertToPixel(grid_x);
        grid_y += move_y;
        pixel_y = convertToPixel(grid_y);
        return;
      }
    } else {
      player_damaged = false;
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
    } //else if (!key_handler.up_pressed) {
      //changeDirection(CreatureDirections.STOP);
      //setImageStop();
    //}
  }

  void setImageStop() {
    if (player_damaged) {
      if (facing_left) {
        setImageContainer(image_standing_left_damage);
      } else {
        setImageContainer(image_standing_right_damage);
      }
    } else {
      if (facing_left) {
        setImageContainer(image_standing_left);
      } else if (facing_right) {
        setImageContainer(image_standing_right);
      }
    }
  }


  void setImage() {
    if (player_damaged) {
      if (facing_right) {
        setImageContainer(image_right_damage);
      } else {
        setImageContainer(image_left_damage);
      }
    } else {
      if (facing_right) {
        setImageContainer(image_right);
      } else if (facing_left) {
        setImageContainer(image_left);
      }
    }
  }
}
