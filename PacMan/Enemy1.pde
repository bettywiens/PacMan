class Enemy1 extends Enemy{
  Enemy1(float grid_x, float grid_y, float speed){
    super(grid_x, grid_y, speed, "pink");
  }
  
  void move_pattern() {
    if (grid_x < player_x) {
      changeDirection(CreatureDirections.RIGHT);
    } else {
      changeDirection(CreatureDirections.LEFT);
    }
    
    if (grid_y < player_y) {
      changeDirection(CreatureDirections.DOWN);
    } else {
      changeDirection(CreatureDirections.UP);
    }
  }
}
