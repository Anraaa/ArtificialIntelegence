from flask import Flask, request, jsonify
import joblib
import numpy as np
import os
import pandas as pd

app = Flask(__name__)

# Path model
model_path = os.path.expanduser('/home/anraaa/Perkuliahan/Semester 5/ArtificialIntelegence/project/model/training_model/student_score_model.pkl')
model = joblib.load(model_path)
print("Model berhasil dimuat.")

# Path dataset
data_path = os.path.expanduser('/home/anraaa/Perkuliahan/Semester 5/ArtificialIntelegence/project/model/training_model/student_performance.csv')
df = pd.read_csv(data_path)

# Tambahkan kolom grade
def assign_grade(score):
    if score >= 85:
        return 'A'
    elif score >= 70:
        return 'B'
    elif score >= 55:
        return 'C'
    elif score >= 40:
        return 'D'
    else:
        return 'F'

df['grade'] = df['total_score'].apply(assign_grade)

@app.route('/predict', methods=['POST'])
def predict():
    try:
        data = request.get_json(force=True)
        
        features_array = np.array([[ 
            data['weekly_self_study_hours'],
            data['attendance_percentage'],
            data['class_participation']
        ]])
        
        prediction = model.predict(features_array)
        return jsonify({'predicted_score': float(prediction[0])})

    except Exception as e:
        return jsonify({'error': str(e)}), 400

@app.route('/students', methods=['GET'])
def get_students():
    try:
        # Ambil parameter limit & offset dari query string
        limit = int(request.args.get('limit', 1000))   # default 50
        offset = int(request.args.get('offset', 0))  # default mulai dari 0

        # Ambil slice data
        subset = df[['student_id', 
                     'weekly_self_study_hours', 
                     'attendance_percentage', 
                     'class_participation', 
                     'total_score', 
                     'grade']].iloc[offset:offset+limit]

        result = subset.to_dict(orient='records')

        return jsonify({
            'count': len(result),
            'offset': offset,
            'limit': limit,
            'data': result
        })

    except Exception as e:
        return jsonify({'error': str(e)}), 400

if __name__ == '__main__':
    app.run(port=5000, debug=True)