# train_model.py
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestRegressor
from sklearn.metrics import mean_squared_error
import joblib

print("Memulai proses training model...")

# 1. Muat Dataset
# Ganti 'path/to/your/student_data.csv' dengan lokasi file Anda
df = pd.read_csv('/home/anraaa/Perkuliahan/Semester 5/ArtificialIntelegence/project/model/training_model/student_performance.csv')

# 2. Definisikan Fitur (X) dan Target (y)
features = ['weekly_self_study_hours', 'attendance_percentage', 'class_participation']
target = 'total_score'

X = df[features]
y = df[target]

# 3. Bagi Data Menjadi Data Latih dan Uji
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)
print(f"Ukuran data latih: {X_train.shape[0]} baris")
print(f"Ukuran data uji: {X_test.shape[0]} baris")

# 4. Pilih dan Latih Model
# RandomForestRegressor adalah pilihan yang baik karena kuat dan fleksibel
model = RandomForestRegressor(n_estimators=100, random_state=42, n_jobs=-1)
model.fit(X_train, y_train)
print("Model berhasil dilatih.")

# 5. (Opsional) Evaluasi Model
predictions = model.predict(X_test)
mse = mean_squared_error(y_test, predictions)
print(f"Mean Squared Error pada data uji: {mse:.2f}")
print(f"Skor R^2: {model.score(X_test, y_test):.2f}")

# 6. Simpan Model yang Sudah Dilatih
joblib.dump(model, 'student_score_model.pkl')
print("Model berhasil disimpan sebagai 'student_score_model.pkl'.")