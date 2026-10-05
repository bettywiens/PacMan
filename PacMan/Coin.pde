class Coin extends WorldObject{
  AnimationImage image;
  
  Coin(float grid_x, float grid_y){
    super(WorldTypes.COIN, grid_x, grid_y);
    image = new AnimationImage("images/environment/coin", 4, ANIMATION_SPEED);
    setImageContainer(image);
  }
  
}
