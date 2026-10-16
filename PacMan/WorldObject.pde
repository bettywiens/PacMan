class WorldObject
{
  float pixel_x;
  float pixel_y;
  float grid_x;
  float grid_y;
  boolean is_walkable;
  WorldTypes type;
  ImageContainer image_container;
  
  WorldObject(WorldTypes type, float grid_x, float grid_y, boolean is_walkable)
  {
    this.type = type;
    this.grid_x = grid_x;
    this.grid_y = grid_y;
    this.pixel_x = convertToPixel(grid_x);
    this.pixel_y = convertToPixel(grid_y);
    this.is_walkable = is_walkable;
  }
  
  void setImageContainer(ImageContainer container)
  {
    this.image_container = container;
  }
  
  // Zeichnet Objekt abhängig vom image_container (Animation oder Normal)
  void drawObject()
  {
    image_container.drawImage(pixel_x, pixel_y);
  }
  
  // Position auf der Grid-Koordinaten wird auf Pixel umgerechnet (für Zeichnen) 
  float convertToPixel(float position)
  {
    return position * TILE_SIZE + (TILE_SIZE / 2);
  }
  
  // Position wird von Pixel-Koordinaten auf Grid-Koordinaten umgerechnet
  int convertToGrid(float position)
  {
    return Math.round((position - (TILE_SIZE / 2)) / TILE_SIZE);
  }
  
  float getPixelX()
  {
    return pixel_x;
  }
  
  float getPixelY()
  {
    return pixel_y;
  }
  
  WorldTypes getType()
  {
    return type;
  }
}
