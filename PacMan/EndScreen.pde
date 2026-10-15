class EndScreen {
  PImage background;
  PImage game_over;
  PImage you_won;
  float you_won_width;
  float you_won_height;
  
  EndScreen() {
    background = loadImage("images/environment/brickwall.png");
    game_over = loadImage("images/environment/game_over.png");
    you_won = loadImage("images/environment/you_won.png");    
  }

  void printGameOver() {
    image(background, window_width / 2, window_height / 2, window_width, window_height);
    image(game_over, window_width / 2, window_height / 2, window_width / 2, window_height / 1.8);
  }
  
  void printYouWon() {
    image(background, window_width / 2, window_height / 2, window_width, window_height);
    image(you_won, window_width / 2, window_height / 2, window_width / 2, window_height / 1.8);
  }
}
