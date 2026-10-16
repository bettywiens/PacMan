class EnemyGruen extends Enemy 
{
  boolean green_can_see = false;
  float corner_x = corner_up_left_x;
  float corner_y = corner_up_left_y;
  
  EnemyGruen(float grid_x, float grid_y, float speed, boolean is_walkable) 
  {
    super(grid_x, grid_y, speed, "green", is_walkable);
  }

  @Override
    void move() 
    {
    super.move();

    float move_x = 0;
    float move_y = 0;
    float step = 0.03125f;

    chooseDirection(green_can_see, corner_x, corner_y);
    setImage();

    // Nach OBEN:
    if (direction.equals(CreatureDirections.UP)) 
    {
      counter++;
      if (counter % 2 == 0) 
      {
        move_y = -step;
      }
      // Nach UNTEN:
    } else if (direction.equals(CreatureDirections.DOWN)) 
    {
      counter++;
      if (counter % 2 == 0) 
      {
        move_y = step;
      }
      // Nach LINKS:
    } else if (direction.equals(CreatureDirections.LEFT)) 
    {
      counter++;
      if (counter % 2 == 0) 
      {
        move_x = -step;
      }
      // Nach RECHTS:
    } else if (direction.equals(CreatureDirections.RIGHT)) 
    {
      counter++;
      if (counter % 2 == 0) 
      {
        move_x = step;
      }
    }

    getPosition();

    checkCollisionEnemy(move_x, move_y);
    
    setImage();
  }
}
