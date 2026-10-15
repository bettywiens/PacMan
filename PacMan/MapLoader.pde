class MapLoader {
  String[] lines;
  char[] characters;
  char[][] tiles;
  char character;
  int heart_counter = 0;
  int number_counter = 0;
  int index = 0;

  MapLoader(ArrayList<WorldObject> world_objects) {
    lines = loadStrings("data/map/map2.txt");

    // 2D-Array für map erstellen:
    tiles = new char[lines.length][];

    hearts = new WorldObject[3];
    numbers = new WorldObject[3];
    walls = new ArrayList<WorldObject>();

    for (int i = 0; i < lines.length; i++) {
      tiles[i] = lines[i].toCharArray();
      characters = lines[i].toCharArray();
      for (int j = 0; j < characters.length; j++) {
        character = characters[j];

        if (character == 'P') {
          world_objects.add(new Player(j, i, PLAYER_SPEED, true));
          index++;
        } else if (character == '#') {
          world_objects.add(new Wall(j, i, "brick", false));
          walls.add(new Wall(j, i, "brick", false));
          index++;
        } else if (character == '.') {
          world_objects.add(0, new Coin(j, i, true));
          coins.add(new Coin(j, i, true));
          amount_coins++;
          index++;
        } else if (character == '+') {
          world_objects.add(new PowerUP(j, i, true));
          index++;
        } else if (character == 'p') {
          world_objects.add(new EnemyPink(j, i, ENEMY_SPEED, true));
          index++;
        } else if (character == 'b') {
          world_objects.add(new Enemy(j, i, ENEMY_SPEED, "blue", true));
          index++;
        } else if (character == 'g') {
          world_objects.add(new EnemyGruen(j, i, ENEMY_SPEED, true));
          index++;
        } else if (character == '*') {
          world_objects.add(new Wall(j, i, "plant", false));
          index++;
        } else if (character == 'H') {
          world_objects.add(new Heart(j, i, "heart", false));
          hearts[heart_counter] = world_objects.get(index);
          heart_counter++;
          index++;
        } else if (character == '0') {
          world_objects.add(new Score(j, i, false));
          numbers[number_counter] = world_objects.get(index);
          number_counter++;
          index++;
        } else if (character == '_') {
          world_objects.add(new Path(j, i, true));
          index++;
        } else if (character == '1') {
          corner_up_left_x = j;
          corner_up_left_y = i;
          //index++;
        } else if (character == '2') {
          corner_up_right_x = j;
          corner_up_right_y = i;
          //index++;
        } else if (character == '5') {
          corner_down_left_x = j;
          corner_down_left_y = i;
          //index++;
        } else if (character == '4') {
          corner_down_right_x = j;
          corner_down_right_y = i;
          //index++;
        }
      }
    }
  }

  boolean isWall(int x, int y) {
    if (y < 0 || y >= tiles.length) {
      return true;
    }
    if ( x < 0 || x >= tiles[y].length) {
      return true;
    }

    return tiles[x][y] == '#';
  }
}
