class PredictionResponse {
  final double predictedScore;

  PredictionResponse({required this.predictedScore});

  factory PredictionResponse.fromJson(Map<String, dynamic> json) {
    return PredictionResponse(predictedScore: json['predicted_score']);
  }

  Map<String, dynamic> toJson() {
    return {'predicted_score': predictedScore};
  }
}
