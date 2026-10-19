class Enemy extends Creature
{
  AnimationImage image_right;
  AnimationImage image_left;
  AnimationImage scatter_left;
  AnimationImage scatter_right;

  int counter = 0;
  float position_x;
  float position_y;

  boolean on_same_level_x = false;
  boolean on_same_level_y = false;
  boolean in_place = false;
  boolean colliding = false;

  CreatureDirections last_direction;
  CreatureDirections before_direction;
  CreatureDirections current;
  CreatureDirections last_x_direction;
  CreatureDirections last_y_direction;
  CreatureDirections last_x_wall;
  CreatureDirections last_y_wall;
  CreatureDirections before_x_wall;
  CreatureDirections before_y_wall;


  Enemy(float grid_x, float grid_y, float speed, String colour, boolean is_walkable)
  {
    super(WorldTypes.ENEMY, grid_x, grid_y, speed, is_walkable);
    last_direction = CreatureDirections.RIGHT;
    before_direction = CreatureDirections.RIGHT;
    current = last_direction;
    last_x_direction = CreatureDirections.RIGHT;
    last_y_direction = CreatureDirections.DOWN;
    last_x_wall = CreatureDirections.RIGHT;
    last_y_wall = CreatureDirections.DOWN;
    before_x_wall = CreatureDirections.RIGHT;
    before_y_wall = CreatureDirections.DOWN;

    position_x = grid_x - (grid_x % 1);
    position_y = grid_y - (grid_y % 1);

    image_right = new AnimationImage("images/enemy/" + colour + "/walk_right", 3, ANIMATION_SPEED);
    image_left = new AnimationImage("images/enemy/" + colour + "/walk_left", 3, ANIMATION_SPEED);

    scatter_right = new AnimationImage("images/enemy/" + colour + "/scatter/walk_right", 3, ANIMATION_SPEED);
    scatter_left = new AnimationImage("images/enemy/" + colour + "/scatter/walk_left", 3, ANIMATION_SPEED);

    setImageContainer(image_right);
    ArrayList<WorldTypes> collision_filter = new ArrayList<WorldTypes>();
    collision_filter.add(WorldTypes.COIN);
    collision_filter.add(WorldTypes.POWER_UP);
    collision_filter.add(WorldTypes.PLAYER);
    setCollisionFilter(collision_filter);
  }

  @Override
    void move()
  {
    super.move();

    float move_x = 0;
    float move_y = 0;
    float step = 0.03125f;

    chooseDirectionRandom();
    setImage();

    // NACH OBEN:
    if (direction.equals(CreatureDirections.UP))
    {
      counter++;
      if (counter % 2 == 0)
      {
        move_y = -step;
      }
      // NACH UNTEN:
    } else if (direction.equals(CreatureDirections.DOWN))
    {
      counter++;
      if (counter % 2 == 0)
      {
        move_y = step;
      }
      // NACH LINKS:
    } else if (direction.equals(CreatureDirections.LEFT))
    {
      counter++;
      if (counter % 2 == 0)
      {
        move_x = -step;
      }
      // NACH RECHTS:
    } else if (direction.equals(CreatureDirections.RIGHT))
    {
      counter++;
      if (counter % 2 == 0)
      {
        move_x = step;
      }
    }

    checkCollisionRandom(move_x, move_y);
    setImage();
  }

  // Wenn eine Kollision stattfindet wird eine random Richtung gewählt
  void checkCollisionRandom(float move_x, float move_y)
  {
    CollisionResult collision_result = checkCollision(move_x, move_y);
    //CollisionResult new_collision_result = checkCollision(move_x + move_x, move_y + move_y);
    if (collision_result != null)
    {
      colliding = true;
      if (collision_result.type.equals(WorldTypes.WALL_BRICK))
      {
        randomDirection();
        return;
      }
    } else
    {
      colliding = false;
      grid_x += move_x;
      pixel_x = convertToPixel(grid_x);
      grid_y += move_y;
      pixel_y = convertToPixel(grid_y);
      return;
    }
  }

  // Wenn eine Kollision stattfindet, wird das Hindernis umgangen
  void checkCollisionEnemy(float move_x, float move_y)
  {
    CollisionResult collision_result = checkCollision(move_x, move_y);

    if (collision_result != null)
    {
      colliding = true;
      // Wenn man mit einer WAND kollidiert
      if (collision_result.type.equals(WorldTypes.WALL_BRICK))
      {
        WorldObject myObject = world_objects.get(collision_result.id);
        float object_x = myObject.grid_x;
        float object_y = myObject.grid_y;

        // Wenn die WAND RECHTS ist:
        if (object_x > position_x)
        {
          before_x_wall = last_x_wall;
          last_x_wall = CreatureDirections.RIGHT;
          println("!!!WAND RECHTS!!!");
          println("LAST X WALL || " + last_x_wall);
          println("LAST Y WALL || " + last_y_wall);
          if (last_direction == CreatureDirections.RIGHT)
          {
            if (before_direction == CreatureDirections.RIGHT)
            {
              before_direction = CreatureDirections.RIGHT;
              if (last_y_wall == CreatureDirections.DOWN)
              {
                goUp();
              } else if (last_y_wall == CreatureDirections.UP)
              {
                goDown();
              }
            } else if (before_direction == CreatureDirections.LEFT)
            {
              before_direction = CreatureDirections.RIGHT;
              if (before_x_wall == CreatureDirections.LEFT)
              {
                if (last_y_wall == CreatureDirections.DOWN)
                {
                  goDown();
                } else if (last_y_wall == CreatureDirections.UP)
                {
                  goDown();
                }
              }
            } else
            {
              before_direction = CreatureDirections.RIGHT;
              goUp();
            }
          } else if (last_direction == CreatureDirections.LEFT)
          {
            if (before_direction == CreatureDirections.UP)
            {
              before_direction = CreatureDirections.LEFT;
              goLeft();
            } else
            {
              before_direction = CreatureDirections.LEFT;
              goUp();
            }
          } else
          {
            before_direction = last_direction;
            goLeft();
          }
          // Wenn die WAND LINKS ist:
        } else if (object_x < position_x)
        {
          before_x_wall = last_x_wall;
          last_x_wall = CreatureDirections.LEFT;

          println("!!!WAND LINKS!!!");
          println("LAST X WALL || " + last_x_wall);
          println("LAST Y WALL || " + last_y_wall);

          if (last_direction == CreatureDirections.LEFT)
          {
            if (before_direction == CreatureDirections.LEFT)
            {
              before_direction = CreatureDirections.LEFT;
              if (last_y_wall == CreatureDirections.DOWN)
              {
                goUp();
              } else if (last_y_wall == CreatureDirections.UP)
              {
                goDown();
              }
            } else if (before_direction == CreatureDirections.DOWN)
            {
              
              before_direction = CreatureDirections.LEFT;
              if (last_y_wall == CreatureDirections.DOWN)
              {
                goUp();
              }
            } else
            {
              before_direction = CreatureDirections.LEFT;
              goUp();
            }
          } else if (last_direction == CreatureDirections.RIGHT)
          {
            if (before_direction == CreatureDirections.UP)
            {
              before_direction = CreatureDirections.RIGHT;
              goRight();
            } else
            {
              before_direction = CreatureDirections.RIGHT;
              goUp();
            }
          } else
          {
            before_direction = last_direction;
            goRight();
          }
          // Wenn die WAND UNTEN ist:
        } else if (object_y > position_y)
        {
          before_y_wall = last_y_wall;
          last_y_wall = CreatureDirections.DOWN;

          println("!!!WAND UNTEN!!!");
          println("LAST X WALL || " + last_x_wall);
          println("LAST Y WALL || " + last_y_wall);

          if (last_direction == CreatureDirections.DOWN)
          {

            //if (before_direction == CreatureDirections.DOWN)
            //{
            //  before_direction = CreatureDirections.DOWN;
            //  if (last_x_wall == CreatureDirections.LEFT)
            //  {
            //    goUp();
            //  }
            //} else
            //{
            //before_direction = CreatureDirections.DOWN;
            if (last_x_wall == CreatureDirections.LEFT)
            {
              if (last_y_wall == CreatureDirections.DOWN && before_direction == CreatureDirections.LEFT)
              {
                goUp();
              } else
              {
                goRight();
              }
            } else if (last_x_wall == CreatureDirections.RIGHT)
            {
              if (last_y_wall == CreatureDirections.DOWN && before_direction == CreatureDirections.RIGHT)
              {
                goUp();
              } else
              {
                goLeft();
              }
            }
            //}
          } else if (last_direction == CreatureDirections.RIGHT)
          {
            if (before_direction == CreatureDirections.RIGHT)
            {
              before_direction = CreatureDirections.RIGHT;
              goUp();
            } else if (before_direction == CreatureDirections.DOWN)
            {
              if (last_x_wall == CreatureDirections.RIGHT)
              {
                goUp();
              }
            }
          } else if (last_direction == CreatureDirections.LEFT)          
          {
            if (before_direction == CreatureDirections.DOWN)
            {
              if (last_x_wall == CreatureDirections.RIGHT)
              {
                goUp();
              }
            }
          } else if (last_direction == CreatureDirections.DOWN)
          {
            
          }
          else
          {
            before_direction = last_direction;
          }
          // Wenn die WAND OBEN ist:
        } else if (object_y < position_y)
        {
          before_y_wall = last_y_wall;
          last_y_wall = CreatureDirections.UP;

          println("!!!WAND OBEN!!!");
          println("LAST X WALL || " + last_x_wall);
          println("LAST Y WALL || " + last_y_wall);

          if (last_direction == CreatureDirections.UP)
          {
            if (before_direction == CreatureDirections.RIGHT)
            {
              before_direction = CreatureDirections.UP;
              goRight();
            } else if (before_direction == CreatureDirections.LEFT) { // Linke Ecke
              before_direction = CreatureDirections.UP;
              // neu
              //Wenn oben und links eine Wand ist und wir nach links wollen, befindet sich über uns ein Hindernis
              if (last_x_wall == CreatureDirections.LEFT) {
                float[] new_position = findNewPosition(object_x, object_y, last_direction, last_y_wall);
                // Neue Position über Hindernis finden

                searchY(new_position[1], true);
                // Müssen wissen wo die Wand ist, nehmen Koordinate drüber
                // Wenn drüber is_walkable == false ist nehmen wir noch eine drüber bis sie is_walkable == true ist
                // Setzen gefundene Tile als neues Ziel fest
                // Wenn Ziel erreicht ist, suchen wir wieder nach Spieler, aber:
                // Wenn das Hindernis auf y_Ebene war suchen wir zuerst nach player_x
                // Wenn das Hindernis auf x_Ebene war suchen wir zuerst nach player_Y
                // Sonst läuft der Gegner wieder an die selbe Stelle zurück
                // goAroundObstacle(newCoordinate_x, newCoordinate_y)
              }
              //
              goRight();
            } else if (before_direction == CreatureDirections.UP)
            {
              // Hier muss noch unterschieden werden ob es eine rechte oder linke ecke ist
              before_direction = CreatureDirections.UP;
              if (last_x_wall == CreatureDirections.LEFT)
              {
                goRight(); // oben links Ecke
              } else if (last_x_wall == CreatureDirections.RIGHT)
              {
                goLeft(); // oben rechts Ecke
              }
            } else
            {
              before_direction = CreatureDirections.UP;
              goLeft();
            }
          } else if (last_direction == CreatureDirections.LEFT)
          {
            if (before_direction == CreatureDirections.UP)
            {
              before_direction = CreatureDirections.LEFT;
              goLeft();
            } else
            {
              before_direction = last_direction;
              goRight();
            }
          } else if (last_direction == CreatureDirections.RIGHT)
          {
            if (before_direction == CreatureDirections.UP)
            {
              before_direction = CreatureDirections.RIGHT;
              goLeft();
            } else if (before_direction == CreatureDirections.LEFT)
            {
              before_direction = CreatureDirections.RIGHT;
              goRight();
            } else
            {
              before_direction = last_direction;
              goRight();
            }
          } else
          {
            before_direction = last_direction;
          }
        }
      }
    } else
    {
      grid_x += move_x;
      pixel_x = convertToPixel(grid_x);
      grid_y += move_y;
      pixel_y = convertToPixel(grid_y);
      colliding = false;
      return;
    }
  }

  // Findet neue Position abhängig von der Bewegungsrichtung und der Kollisionswand
  float[] findNewPosition(float wall_x, float wall_y, CreatureDirections move_direction, CreatureDirections wall_position)
  {
    if (move_direction == CreatureDirections.UP)
    {
      if (wall_position == CreatureDirections.UP)
      {
        // wall_x bleibt unverändert da wir nach oben müssen
        wall_y++;
        while (!checkIfWalkable(wall_x, wall_y))
        {
          // wall_y wird erhöht, bis es ein betretbares Feld ist
          wall_y++;
        }
        float[] newPosition = { wall_x, wall_y};
        return newPosition;
      }
    }
    float[] array = null;
    return array;
  }

  // Überpüft ob TILE an bestimmterstelle walkable ist (eig. überflüssig kann man auch direkt machen)
  boolean checkIfWalkable (float wall_x, float wall_y)
  {
    WorldObject object = map_loader.getWorldObject(wall_x, wall_y);
    println("GETTING WORLD OBJECT WORKED");
    println(object.type);
    return object.is_walkable;
  }

  // Wenn scattermode aktiv ist, geht Gegner in die obere linke Ecke
  void chooseDirectionRandom()
  {
    if (!scatter_active)
    {
      return;
    } else
    {
      if (!colliding)
      {
        searchX(corner_up_left_x, true);
        searchY(corner_up_left_y, true);
      } else
      {
        return;
      }
    }
  }

  // Sucht nach Ziel auf der x-Achse
  void searchX(float person_x, boolean seeing)
  {
    //println("------SEARCHING X------");
    if (!on_same_level_x)
    {
      // Gegner ist links vom Ziel --> muss nach rechts
      if (position_x < person_x)
      {
        changeDirection(CreatureDirections.RIGHT);
        last_direction = CreatureDirections.RIGHT;
        // Gegner ist rechts vom Ziel --> muss nach links
      } else if (position_x > person_x)
      {
        changeDirection(CreatureDirections.LEFT);
        last_direction = CreatureDirections.LEFT;
        // Gegner ist entweder direkt über oder direkt unter Ziel
      } else if (position_x == person_x)
      {
        // Gegner kann entweder durch Wände sehen oder nicht
        if (seeing) {
          on_same_level_x = true;
          on_same_level_y = false;
        }
        return;
      }
    }
  }

  // Sucht nach Ziel auf der y-Achse
  void searchY(float person_y, boolean seeing)
  {
    //println("------SEARCHING Y------");
    if (!on_same_level_y)
    {
      // Gegner ist über dem Ziel --> muss nach unten
      if (position_y < person_y)
      {
        changeDirection(CreatureDirections.DOWN);
        last_direction = CreatureDirections.DOWN;
        // Gegner ist unter dem Ziel --> muss nach oben
      } else if (position_y > person_y)
      {
        changeDirection(CreatureDirections.UP);
        last_direction = CreatureDirections.UP;
        // Gegner ist entweder direkt links oder rechts vom Ziel
      } else if (position_y == person_y)
      {
        // Gegner kann entweder durch Wände sehen oder nicht
        if (seeing)
        {
          on_same_level_x = false;
          on_same_level_y = true;
        }
        return;
      }
    }
  }

  // Wählt eine zufällige Richtung aus
  void randomDirection()
  {
    int direction_number = round(random(0, 3));
    CreatureDirections random_direction = CreatureDirections.values()[direction_number];
    changeDirection(random_direction);
    last_direction = random_direction;
  }

  void goLeft()
  {
    //println("LEFT");
    changeDirection(CreatureDirections.LEFT);
    last_direction = CreatureDirections.LEFT;
    last_x_direction = CreatureDirections.LEFT;
    colliding = false;
    return;
  }

  void goRight()
  {
    //println("RIGHT");
    changeDirection(CreatureDirections.RIGHT);
    last_direction = CreatureDirections.RIGHT;
    last_x_direction = CreatureDirections.RIGHT;
    colliding = false;
    return;
  }

  void goUp()
  {
    //println("UP");
    changeDirection(CreatureDirections.UP);
    last_direction = CreatureDirections.UP;
    last_y_direction = CreatureDirections.UP;
    colliding = false;
    return;
  }

  void goDown()
  {
    //println("DOWN");
    changeDirection(CreatureDirections.DOWN);
    last_direction = CreatureDirections.DOWN;
    last_y_direction = CreatureDirections.DOWN;
    colliding = false;
    return;
  }

  // Setzt das Bild abhängig von der Richtung und Scattermode:
  void setImage()
  {
    current = last_direction;
    if (current.equals(CreatureDirections.RIGHT))
    {
      if (scatter_active)
      {
        setImageContainer(scatter_right);
      } else
      {
        setImageContainer(image_right);
      }
    } else if (current.equals(CreatureDirections.LEFT))
    {
      if (scatter_active)
      {
        setImageContainer(scatter_left);
      } else
      {
        setImageContainer(image_left);
      }
    }
  }

  // Sucht nach Spieler
  void chooseDirection(boolean seeing, float corner_x, float corner_y)
  {
    if (!scatter_active)
    {
      if (!colliding)
      {
        in_place = false;
        searchX(player_x, seeing); // Sucht nach X Position vom Ziel
        searchY(player_y, seeing); // Sucht nach Y Position vom Ziel
      } else
      {
        return;
      }
    } else
    {
      if (!colliding) // && !in_place
      {
        // Geht im Scattermode nach oben rechts
        //checkIfInCorner(grid_x, grid_y, corner_x, corner_y);
        searchX(corner_x, seeing);
        searchY(corner_y, seeing);
      } else
      {
        return;
      }
    }
  }

  void checkIfInCorner(float player_x, float player_y, float corner_x, float corner_y)
  {
    if (player_x == corner_x && player_y == corner_y)
    {
      in_place = true;
    }
  }

  // Sagt auf welchem Tile wird uns befinden:
  void getPosition()
  {
    position_x = grid_x - (grid_x % 1);
    position_y = grid_y - (grid_y % 1);
  }
}
