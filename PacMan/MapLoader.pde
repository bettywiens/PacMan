class MapLoader {

  MapLoader(ArrayList<WorldObject> world_objects) {
    String[] lines = loadStrings("C:/Users/bwiens/Documents/GitHub/PacMan/PacMan/Data/map/map.txt");

    for (int i = 0; i < lines.length; i++) {
      char[] characters = lines[i].toCharArray();
      for (int j = 0; j < characters.length; j++) {
        char character = characters[j];

        switch (character) {
        case 'P':
          world_objects.add(new Player(j, i, PLAYER_SPEED));
          break;
        case '#':
          world_objects.add(new Wall(j, i));
          break;
        case '.':
          world_objects.add(new Coin(j, i));
          break;
        case 'E':
          world_objects.add(new Enemy(j, i, ENEMY_SPEED));
          break;
        }
      }
    }
  }
}
