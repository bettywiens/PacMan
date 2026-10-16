class Creature extends WorldObject {
  CreatureDirections direction;
  CreatureDirections wish_direction;
  float speed;
  ArrayList<WorldTypes> collision_filter;

  Creature(WorldTypes type, float grid_x, float grid_y, float speed, boolean is_walkable) {
    super(type, grid_x, grid_y, is_walkable);
    direction = CreatureDirections.UP;
    this.speed = speed;
  }

  void changeDirection(CreatureDirections new_direction) {
    wish_direction = new_direction;
  }

  void move() {
    float gap = 2.3f;

    // Überprüft ob neue Richtung angefragt wurde und ob diese unterschiedlich zur jetzigen Richtung ist
    if (wish_direction != null && !wish_direction.equals(direction)) {
      float grid_gap_x = Math.abs((pixel_x % TILE_SIZE) - TILE_SIZE / 2); // berechnet wie weit Charakter vom Zentrum der jeweiligen Tile ist
      float grid_gap_y = Math.abs((pixel_y % TILE_SIZE) - TILE_SIZE / 2);
      if (grid_gap_x <= gap && grid_gap_y <= gap) {
        direction = wish_direction;
      }
    }
  }

  // Überprüft ob Creature in etwas reinläuft, returns a CollisionResult object
  // Collision? yes: CollisionResult, no: null
  CollisionResult checkCollision(float move_x, float move_y) {

    float collision_size = TILE_SIZE;
    fill(255, 0, 0);
    //rect(pixel_x, pixel_y, collision_size, collision_size);

    // Neue Position in Pixel, Position, wo sich Objekt hinbewegen würde:
    float new_pixel_position_x = convertToPixel(grid_x + move_x);
    float new_pixel_position_y = convertToPixel(grid_y + move_y);

    // Position auf dem Spielfeld nach der Bewegung?
    //int tile_position_x = (int)grid_x + (int)move_x;
    //println("Spieler x: " + tile_position_x);
    //int tile_position_y = (int)grid_y + (int)move_y;
    //println("Spieler y: " + tile_position_y);
    //int[] position_tile = {tile_position_x, tile_position_y};

    // Iterieren durch die world_objects (Alle Elemente auf dem Spielfeld):
    for (int i = 0; i < world_objects.size(); i++) {
      WorldObject collision_object = world_objects.get(i);
      //int collision_tile_x = (int)collision_object.grid_x;
      //println("Objekt x: " + collision_tile_x);
      //int collision_tile_y = (int)collision_object.grid_y;
      //println("Objekt y: " + collision_tile_y);
      //int[] collision_tile = {collision_tile_x, collision_tile_y};


      // Überpüft ob das objekt nicht es selbst ist (mit dem Type nicht id (vielleicht später mit id))
      if (!collision_object.getType().equals(getType())) {
        // Wir holen uns die Position vom mit uns möglicherweise kollidierenden Objekt
        float object_pixel_x = collision_object.getPixelX();
        float object_pixel_y = collision_object.getPixelY();

        //boolean same_position = Arrays.equals(collision_tile, position_tile);
        //// Vergleicht position von möglichen Kollisionsobjekten mit Figur
        //if (same_position) {
        //  CollisionResult result = new CollisionResult();
        //  result.object = collision_object;
        //  result.type = collision_object.getType();
        //  result.id = i;


        //  if (collision_filter == null || !collision_filter.contains(result.type)) {
        //    return  result;
        //  }
        //}


        // Überprüft ob die Kollisionsrechtecke miteinander überlappen
        // Hier könnte man auch abfragen ob der tile den wir betreten betretbar ist
        if (object_pixel_x < new_pixel_position_x + collision_size &&
          object_pixel_x + collision_size > new_pixel_position_x &&
          object_pixel_y < new_pixel_position_y + collision_size &&
          object_pixel_y + collision_size > new_pixel_position_y) {

          CollisionResult result = new CollisionResult();
          result.object = collision_object;
          result.type = collision_object.getType();
          result.id = i; // Die id ist der index von dem Objekt auf dem Spielfeld

          if (collision_filter == null || !collision_filter.contains(result.type)) {
            return  result;
          }
        }
      }
    }

    return null;
  }

  void update() {
  }

  // Erlaubt uns bestimmte collision types zu ignorieren
  void setCollisionFilter(ArrayList<WorldTypes> collision_filter) {
    this.collision_filter = collision_filter;
  }
}
