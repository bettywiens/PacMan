class Coin extends WorldObject{
  AnimationImage image;
  
  Coin(float grid_x, float grid_y, boolean is_walkable){
    super(WorldTypes.COIN, grid_x, grid_y, is_walkable);
    image = new AnimationImage("images/environment/coin", 4, ANIMATION_SPEED);
    setImageContainer(image);
  }
  
}
