class Enemy extends Creature{
  AnimationImage image_right;
  AnimationImage image_left;

  Enemy(float grid_x, float grid_y, float speed) {
    super(WorldTypes.PLAYER, grid_x, grid_y, speed);
    image_right = new AnimationImage("images/enemy/walk_right", 3, ANIMATION_SPEED);
    image_left = new AnimationImage("images/enemy/walk_left", 3, ANIMATION_SPEED);
    setImageContainer(image_right);
    ArrayList<WorldTypes> collision_filter = new ArrayList<WorldTypes>();
    collision_filter.add(WorldTypes.COIN);
    setCollisionFilter(collision_filter);
  }

  @Override
  void move() {
    super.move();
    
    float move_x = 0;
    float move_y = 0;
    
    if (direction.equals(CreatureDirections.UP)) {
      move_y = -1;
    } else if (direction.equals(CreatureDirections.DOWN)) {
      move_y = 1;
    } else if (direction.equals(CreatureDirections.LEFT)) {
      move_x = -1;
    } else if (direction.equals(CreatureDirections.RIGHT)) {
      move_x = 1;
    }

    CollisionResult collision_result = checkCollision(move_x, move_y);
    if (collision_result != null) {
      if (collision_result.type.equals(WorldTypes.WALL_BRICK)) {
        randomDirection();
        return;
      }
    } else {
      //grid_x += move_x;
      //pixel_x = convertToPixel(grid_x);
      //grid_y += move_y;
      //pixel_y = convertToPixel(grid_y);
      return;
    }
  }
  
  void randomDirection(){
    int direction_number = round(random(0, 3));
    CreatureDirections random_direction = CreatureDirections.values()[direction_number];
    changeDirection(random_direction);
    
    if(random_direction.equals(CreatureDirections.LEFT)){
      setImageContainer(image_left);
    } else if (random_direction.equals(CreatureDirections.RIGHT)) {
      setImageContainer(image_right);
    }
  }
  
}
