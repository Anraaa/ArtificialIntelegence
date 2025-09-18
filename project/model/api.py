# api.py
from flask import Flask, request, jsonify
import joblib
import numpy as np

app = Flask(__name__)

# Muat model saat API pertama kali dijalankan
model = joblib.load('/home/anraaa/Perkuliahan/Semester 5/ArtificialIntelegence/project/model/training_model/student_score_model.pkl')
print("Model berhasil dimuat.")

@app.route('/predict', methods=['POST'])
def predict():
    try:
        # Ambil data JSON dari request yang dikirim Laravel
        data = request.get_json(force=True)
        
        # Susun data menjadi array numpy sesuai urutan fitur saat training
        features_array = np.array([[
            data['weekly_self_study_hours'],
            data['attendance_percentage'],
            data['class_participation']
        ]])
        
        # Lakukan prediksi
        prediction = model.predict(features_array)
        
        # Kembalikan hasil dalam format JSON
        return jsonify({'predicted_score': prediction[0]})

    except Exception as e:
        return jsonify({'error': str(e)}), 400

if __name__ == '__main__':
    # Jalankan server API di port 5000
    app.run(port=5000, debug=True)