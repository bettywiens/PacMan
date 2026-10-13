class Heart extends WorldObject {
  NormalImage image_heart;
  NormalImage image_lost_heart;

  Heart(float grid_x, float grid_y, String type) {
    super(WorldTypes.HEART, grid_x, grid_y);
    image_heart = new NormalImage("images/hearts/heart.png");
    image_lost_heart = new NormalImage("images/hearts/lost_heart.png");

    switch (type) {
    case "heart":
      setImageContainer(image_heart);
      break;
    case "lost":
      setImageContainer(image_lost_heart);
      break;
    }
  }

  void setImageContainerHeart(String type) {
    switch (type) {
    case "heart":
      setImageContainer(image_heart);
      break;
    case "lost":
      setImageContainer(image_lost_heart);
      break;
    }
  }
}
