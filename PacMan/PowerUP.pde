class PowerUP extends WorldObject
{
  NormalImage image;
  
  PowerUP(float grid_x, float grid_y, boolean is_walkable)
  {
    super(WorldTypes.POWER_UP, grid_x, grid_y, is_walkable);
    image = new NormalImage("images/environment/apple.png");
    setImageContainer(image);
  }
  
}
