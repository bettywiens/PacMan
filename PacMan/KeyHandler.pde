class KeyHandler{
  boolean up_pressed;
  boolean left_pressed;
  boolean right_pressed;
  boolean down_pressed;
  boolean w_pressed;
  boolean a_pressed;
  boolean s_pressed;
  boolean d_pressed;
  
  KeyHandler(){
    up_pressed = false;
  }
  
  void pressed(){
    if(keyCode == UP){
      up_pressed = true;
    }
    if(keyCode == DOWN){
      down_pressed = true;
    }
    if(keyCode == LEFT){
      left_pressed = true;
    }
    if(keyCode == RIGHT){
      right_pressed = true;
    }
    if(key == 'w'){
      w_pressed = true;
    }
    if(key == 's'){
      s_pressed = true;
    }
    if(key == 'a'){
      a_pressed = true;
    }
    if(key == 'd'){
      d_pressed = true;
    }
  }
  
  void released(){
    if(keyCode == UP){
      up_pressed = false;
    }
    if(keyCode == DOWN){
      down_pressed = false;
    }
    if(keyCode == LEFT){
      left_pressed = false;
    }
    if(keyCode == RIGHT){
      right_pressed = false;
    }
    if(key == 'w'){
      w_pressed = false;
    }
    if(key == 's'){
      s_pressed = false;
    }
    if(key == 'a'){
      a_pressed = false;
    }
    if(key == 'd'){
      d_pressed = false;
    }
  }
}
