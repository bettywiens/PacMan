class Score extends WorldObject {
  NormalImage zero;
  NormalImage point_image_0;
  NormalImage point_image_1;
  NormalImage point_image_2;
  String image_path;
  String pointsS;

  Score(float grid_x, float grid_y) {
    super(WorldTypes.SCORE, grid_x, grid_y);
    zero = new NormalImage("images/numbers/0.png");
    image_path = "images/numbers/";
    setImageContainer(zero);
  }


  void showPoints(WorldObject[] pointPositions, int points) {
    pointsS = String.valueOf(points);
    char[] pointsArray = pointsS.toCharArray();
    if (points < 10) {
      point_image_0 = new NormalImage(image_path + points + ".png");
      point_image_1 = zero;
      point_image_2 = zero;
    } else if (points >= 10 && points < 100) {
      point_image_0 = new NormalImage(image_path + pointsArray[1] + ".png");
      point_image_1 = new NormalImage(image_path + pointsArray[0] + ".png");
      point_image_2 = zero;
    } else if (points >= 100) {
      point_image_0 = new NormalImage(image_path + pointsArray[2] + ".png");
      point_image_1 = new NormalImage(image_path + pointsArray[1] + ".png");
      point_image_2 = new NormalImage(image_path + pointsArray[0] + ".png");
    }
    pointPositions[0].setImageContainer(point_image_2);
    pointPositions[1].setImageContainer(point_image_1);
    pointPositions[2].setImageContainer(point_image_0);
  }
}
