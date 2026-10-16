import java.util.Arrays;

int SCALE = 3;
int TILE_SIZE = 16 * SCALE;
float PLAYER_SPEED = 0.7f * SCALE;
float ENEMY_SPEED = 0.6f * SCALE;
float ANIMATION_SPEED = 0.1f;
float ANIMATION_WON_SPEED = 0.05f;
float ANIMATION_STANDING_SPEED = 0.025f;

ArrayList<WorldObject> world_objects;
ArrayList<WorldObject> walls;
ArrayList<WorldObject> coins;
WorldObject[] hearts;
WorldObject[] numbers;

float player_x;
float player_y;
float corner_up_right_x;
float corner_up_right_y;
float corner_up_left_x;
float corner_up_left_y;
float corner_down_right_x;
float corner_down_right_y;
float corner_down_left_x;
float corner_down_left_y;

int window_width;
int window_height;

int lives = 3;
int amount_lives = 3;
int score = 0;
int amount_coins = 0;
int scatter_timer_counter = 0;

boolean game_lost = false;
boolean game_won = false;
boolean player_dead = false;
boolean player_won = false;
boolean scatter_active = false;

PImage background;
PImage game_over;

Timer timer;
Timer scatter_timer;
EndScreen end;
MapLoader map_loader;
KeyHandler key_handler;

void setup() 
{
  size(480, 600);
  timer = new Timer(2000);
  scatter_timer = new Timer(20000);
  timer.start();
  scatter_timer.start();
  world_objects = new ArrayList<WorldObject>();
  coins = new ArrayList<WorldObject>();  
  map_loader = new MapLoader(world_objects);
  println("Amount coins: " + amount_coins);
  window_height = map_loader.lines.length * TILE_SIZE;
  window_width = map_loader.characters.length * TILE_SIZE;
  windowResize(window_width, window_height);
  imageMode(CENTER);
  rectMode(CENTER);
  noSmooth();
  key_handler = new KeyHandler();
  end = new EndScreen();
}

void draw() 
{  
  if (!game_lost && !game_won) 
  {
    background(187, 212, 121);
    for (int i = 0; i < world_objects.size(); i++) 
    {
      WorldObject object = world_objects.get(i);

      object.drawObject();

      if (object instanceof Creature) 
      {
        Creature creature = (Creature) object;
        creature.move();
        creature.update();
      }
      
     // Scattermode wird 20 Sekunden aktiviert und hält 20 Sekunden an (temporär);
     // Eigenen Zeit für scattermode an sich machen
      //if (scatter_timer.isFinished()) {
      //  scatter_active = true;
      //  //println("scatter is active.");
      //  scatter_timer_counter++;
      //  scatter_timer.start();
      //  if (scatter_timer_counter == 2){
      //    scatter_active = false;
      //    //println("scatter is inactive.");
      //    scatter_timer_counter = 0;
      //  }     
      //}
    }
  } else 
  {
    if (player_dead) 
    {
      end.printGameOver();
    } else if (game_won) 
    {
      end.printYouWon();
    }
  }
}

void keyPressed() 
{
  key_handler.pressed();
}

void keyReleased() 
{
  key_handler.released();
}
