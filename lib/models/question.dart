class Question {
  
  int id;
  String question;
  List<String> answer;
  int answerSelected;
  int correctAnswer;

  Question({required this.id, required this.question, required this.answer, required this.answerSelected, required this.correctAnswer});

  String get getQuestion {
    return question;
  }

  List<String> get getAnswer {
    return answer;
  }

}