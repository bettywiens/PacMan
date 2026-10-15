class EnemyPink extends Enemy {      

  EnemyPink(float grid_x, float grid_y, float speed, boolean is_walkable) {
    super(grid_x, grid_y, speed, "pink", is_walkable);        
  }

  @Override
    void move() {
    super.move();        

    float move_x = 0;
    float move_y = 0;
    float step = 0.03125f;

    chooseDirection();
    setImage();    
    
    // Nach OBEN:
    if (direction.equals(CreatureDirections.UP)) {
      counter++;     
      if (counter % 2 == 0) {
        move_y = -step;
      }
    // Nach UNTEN:
    } else if (direction.equals(CreatureDirections.DOWN)) {
      counter++;
      if (counter % 2 == 0) { 
        move_y = step;
      }
    // Nach LINKS:
    } else if (direction.equals(CreatureDirections.LEFT)) {
      counter++;
      if (counter % 2 == 0) {
        move_x = -step;
      }
    // Nach RECHTS:
    } else if (direction.equals(CreatureDirections.RIGHT)) {
      counter++;
      if (counter % 2 == 0) {
        move_x = step;
      }
    }

    getPosition();
    
    checkCollisionEnemy(move_x, move_y);
    
  }
  
  void checkCollisionEnemy(float move_x, float move_y) {
    CollisionResult collision_result = checkCollision(move_x, move_y);
    CollisionResult new_collision_result = checkCollision(move_x + move_x, move_y + move_y);
    if (collision_result != null) {      
      colliding = true;
      if (collision_result.type.equals(WorldTypes.WALL_BRICK)) {
        WorldObject myObject = world_objects.get(collision_result.id);
        float object_x = myObject.grid_x;
        float object_y = myObject.grid_y;

        // Wenn die WAND RECHTS ist:
        if (object_x > position_x) {          
          if (last_direction == CreatureDirections.RIGHT) {            
            goUp();
          } else if (last_direction == CreatureDirections.LEFT) {
            goUp();
          } else {
            goLeft();
          }
        // Wenn die WAND LINKS ist:
        } else if (object_x < position_x) {          
          if (last_direction == CreatureDirections.LEFT) {
            goUp();
          } else if (last_direction == CreatureDirections.RIGHT) {
            goUp();
          } else if (last_direction == CreatureDirections.DOWN) {
            goDown();
          } else {
            goRight();
          }
        // Wenn die WAND UNTEN ist:
        } else if (object_y > position_y) {          
          if (last_direction == CreatureDirections.DOWN) {
            goLeft();
          }
        // Wenn die WAND OBEN ist:
        } else if (object_y < position_y) {          
          if (last_direction == CreatureDirections.UP) {
            goLeft();
          } else if (last_direction == CreatureDirections.LEFT) {
            goDown();
          } else if (last_direction == CreatureDirections.RIGHT) {
            goDown();
          }
        }
      }
    } else {
      grid_x += move_x;
      pixel_x = convertToPixel(grid_x);
      grid_y += move_y;
      pixel_y = convertToPixel(grid_y);
      colliding = false;
      return;
    }
  }

  void chooseDirection() {
    if (!scatter_active) {      
      if (!colliding) {        
        searchX(player_x); // Sucht nach X Position vom Ziel
        searchY(player_y); // Sucht nach Y Position vom Ziel               
      } else {
        return;
      }
    } else {      
      if (!colliding) {
        // Geht im Scattermode nach oben rechts
        searchX(corner_up_right_x); 
        searchY(corner_up_right_y);                
      } else {
        return;
      }
    }
  }

  // Sagt auf welchem Tile wird uns befinden:
  void getPosition() {
    position_x = grid_x - (grid_x % 1);
    position_y = grid_y - (grid_y % 1);
  }
}
