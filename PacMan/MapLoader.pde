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
          world_objects.add(new Player(j, i, PLAYER_SPEED));
          index++;
        } else if (character == '#') {
          world_objects.add(new Wall(j, i, "brick"));
          walls.add(new Wall(j, i, "brick"));
          index++;
        } else if (character == '.') {
          world_objects.add(0, new Coin(j, i));
          index++;
        } else if (character == '+') {
          world_objects.add(new PowerUP(j, i));
          index++;
        } else if (character == 'p') {
          world_objects.add(new Enemy(j, i, ENEMY_SPEED, "pink"));
          index++;
        } else if (character == 'b') {
          world_objects.add(new Enemy(j, i, ENEMY_SPEED, "blue"));
          index++;
        } else if (character == 'g') {
          world_objects.add(new Enemy(j, i, ENEMY_SPEED, "green"));
          index++;
        } else if (character == '*') {
          world_objects.add(new Wall(j, i, "plant"));
          index++;
        } else if (character == '3') {
          world_objects.add(new Heart(j, i, "heart"));
          hearts[heart_counter] = world_objects.get(index);
          heart_counter++;
          index++;
        } else if (character == '0') {
          world_objects.add(new Score(j, i));
          numbers[number_counter] = world_objects.get(index);
          number_counter++;
          println("Number added " + number_counter);
          index++;
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
