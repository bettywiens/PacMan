class Timer {
  int savedTime;
  int totalTime;
  
  Timer(int tempTotalTime) {
    totalTime = tempTotalTime;
  }
  
  // starten des Timers
  void start() {
    // Wenn der Timer gestartet wird, wird die jetzige Zeit in millisekunden gespeichert
    savedTime = millis();
  }
  
  boolean isFinished() {
    // Überprüfen wie viel Zeit vergangen ist
    int passedTime = millis() - savedTime;
    if (passedTime > totalTime) {
      return true;
    } else {
      return false;
    }
  }
}
