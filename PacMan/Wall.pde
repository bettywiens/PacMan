class Wall extends WorldObject{
  NormalImage image;
  
  Wall(float grid_x, float grid_y){
    super(WorldTypes.WALL_BRICK, grid_x, grid_y);
    image = new NormalImage("images/environment/wall_brick.png");
    setImageContainer(image);
  }
  
}
