class Enemy extends Creature {
  
  AnimationImage image_right;
  AnimationImage image_left;
  
  Enemy(float grid_x, float grid_y, float speed) {
    super(WorldTypes.ENEMY, grid_x, grid_y, speed);
    image_right = new AnimationImage("C:/Users/bwiens/Documents/GitHub/PacMan/PacMan/Data/images/enemy/walk_right_", 3, ANIMATION_SPEED);
    image_left = new AnimationImage("C:/Users/bwiens/Documents/GitHub/PacMan/PacMan/Data/images/enemy/walk_left_", 3, ANIMATION_SPEED);
    setImageContainer(image_right);
    setImageContainer(image_left);
  }
  
  // move
  // randomDirection
}
