class Wall extends WorldObject{
  NormalImage image_wall;
  NormalImage image_plant;
  
  Wall(float grid_x, float grid_y, String type, boolean is_walkable){
    super(WorldTypes.WALL_BRICK, grid_x, grid_y, is_walkable);
    image_wall = new NormalImage("images/environment/wall_brick.png");
    image_plant = new NormalImage("images/environment/wall_plant.png");
    
    switch (type) {
      case "brick":
        setImageContainer(image_wall);
        break;
      case "plant":
        setImageContainer(image_plant);
        break;
    }
  }
  
}
