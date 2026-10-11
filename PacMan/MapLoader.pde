class MapLoader {
  String[] lines;
  char[] characters;
  char[][] tiles;
  char character;
  
  MapLoader(ArrayList<WorldObject> world_objects) {
    lines = loadStrings("data/map/map2.txt");
    
    // 2D-Array für map erstellen:
    tiles = new char[lines.length][];

    for (int i = 0; i < lines.length; i++) {
      tiles[i] = lines[i].toCharArray();
      characters = lines[i].toCharArray();
      for (int j = 0; j < characters.length; j++) {
        character = characters[j];

        if (character == 'P') {
          world_objects.add(new Player(j, i, PLAYER_SPEED));
        } else if (character == '#') {
          world_objects.add(new Wall(j, i));
        } else if (character == '.') {
          world_objects.add(0, new Coin(j, i));
        } else if (character == 'E') {
          world_objects.add(new Enemy(j, i, ENEMY_SPEED));
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
