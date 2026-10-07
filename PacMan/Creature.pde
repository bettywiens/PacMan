class Creature extends WorldObject {
  CreatureDirections direction;
  CreatureDirections wish_direction;
  float speed;
  ArrayList<WorldTypes> collision_filter;

  Creature(WorldTypes type, float grid_x, float grid_y, float speed) {
    super(type, grid_x, grid_y);
    direction = CreatureDirections.UP;
    this.speed = speed;
  }

  void changeDirection(CreatureDirections new_direction) {
    wish_direction = new_direction;
  }

  void move() {
    float gap = 2.3f;
    
    if(wish_direction != null && !wish_direction.equals(direction)){
      float grid_gap_x = Math.abs((pixel_x % TILE_SIZE) - TILE_SIZE / 2);
      float grid_gap_y = Math.abs((pixel_y % TILE_SIZE) - TILE_SIZE / 2);
      if(grid_gap_x <= gap && grid_gap_y <= gap){
        direction = wish_direction;
      }
    }
  }

  CollisionResult checkCollision(float move_x, float move_y) {

    float collision_size = TILE_SIZE;
    fill(255,0,0);
   //rect(pixel_x, pixel_y, collision_size, collision_size);

    // Neue Position in Pixel:
    float new_pixel_position_x = pixel_x + move_x;
    float new_pixel_position_y = pixel_y + move_y;
    
    // Neue grid position:
    //float new_grid_position_x = grid_x

    // Iterieren durch die world_objects (Alle Elemente auf dem Spielfeld):
    for (int i = 0; i < world_objects.size(); i++) {
      WorldObject collision_object = world_objects.get(i);
      
      // Wenn das objekt nicht sich selbst ist?
      if (!collision_object.getType().equals(getType())) {
        float object_pixel_x = collision_object.getPixelX();
        float object_pixel_y = collision_object.getPixelY();

        if (object_pixel_x < new_pixel_position_x + collision_size &&
          object_pixel_x + collision_size > new_pixel_position_x &&
          object_pixel_y < new_pixel_position_y + collision_size &&
          object_pixel_y + collision_size > new_pixel_position_y) {

          CollisionResult result = new CollisionResult();
          result.object = collision_object;
          result.type = collision_object.getType();
          result.id = i;
          
          if(collision_filter == null || !collision_filter.contains(result.type)){
            return  result;
          }
        }
      }
    }

    return null;
  }

  void update() {
  }
  
  void setCollisionFilter(ArrayList<WorldTypes> collision_filter){
    this.collision_filter = collision_filter;
  }
}
