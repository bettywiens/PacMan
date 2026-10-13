class PowerUP extends WorldObject{
  NormalImage image;
  
  PowerUP(float grid_x, float grid_y){
    super(WorldTypes.POWER_UP, grid_x, grid_y);
    image = new NormalImage("images/environment/apple.png");
    setImageContainer(image);
  }
  
}
