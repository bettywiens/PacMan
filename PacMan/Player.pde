class Player extends Creature {
  
  AnimationImage image_right;
  AnimationImage image_left;
  
  Player(float grid_x, float grid_y, float speed) {
    super(WorldTypes.PLAYER, grid_x, grid_y, speed);
    image_right = new AnimationImage("C:/Users/bwiens/Documents/GitHub/PacMan/PacMan/Data/images/player/walk_right_", 3, ANIMATION_SPEED);
    image_left = new AnimationImage("C:/Users/bwiens/Documents/GitHub/PacMan/PacMan/Data/images/player/walk_left_", 3, ANIMATION_SPEED);
    setImageContainer(image_right);
    setImageContainer(image_left);
  }
  
  // move
  // update
}
