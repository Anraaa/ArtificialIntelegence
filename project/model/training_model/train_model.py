import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestRegressor
from sklearn.metrics import mean_squared_error
import joblib

# ---> Impor BARU untuk Preprocessing <---
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import StandardScaler
from sklearn.impute import SimpleImputer

print("Memulai proses training model...")

# 1. Muat Dataset
df = pd.read_csv('/home/anraaa/Perkuliahan/Semester 5/ArtificialIntelegence/project/model/training_model/student_performance.csv')
df = df.head(1000)
print(f"Dataset dibatasi hanya {df.shape[0]} baris pertama.")

# 2. Definisikan Fitur (X) dan Target (y)
# Fitur-fitur ini kita asumsikan semuanya numerik
numeric_features = ['weekly_self_study_hours', 'attendance_percentage', 'class_participation']
target = 'total_score'

X = df[numeric_features]
y = df[target]

# 3. Bagi Data Menjadi Data Latih dan Uji
# (Penting: Selalu split data SEBELUM menerapkan preprocessing)
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)
print(f"Ukuran data latih: {X_train.shape[0]} baris")
print(f"Ukuran data uji: {X_test.shape[0]} baris")

# 4. ---> Buat Pipeline Preprocessing <---
# Ini adalah pipeline HANYA untuk fitur numerik
numeric_transformer = Pipeline(steps=[
    ('imputer', SimpleImputer(strategy='median')),  # Mengisi nilai kosong dengan median
    ('scaler', StandardScaler())                   # Menyamakan skala data
])

# 5. ---> Buat Pipeline Model Utama <---
# Kita gabungkan langkah preprocessing dengan model Regressor-nya
model_pipeline = Pipeline(steps=[
    ('preprocessor', numeric_transformer),
    ('regressor', RandomForestRegressor(n_estimators=100, random_state=42, n_jobs=-1))
])

# 6. Latih Pipeline
# Cukup panggil .fit() pada pipeline utama. 
# Data akan otomatis di-impute, di-scale, BARU dilatih ke model.
model_pipeline.fit(X_train, y_train)
print("Pipeline (Preprocessor + Model) berhasil dilatih.")

# 7. (Opsional) Evaluasi Pipeline
# Pipeline akan otomatis mentransformasi X_test sebelum melakukan prediksi
predictions = model_pipeline.predict(X_test)
mse = mean_squared_error(y_test, predictions)
print(f"Mean Squared Error pada data uji: {mse:.2f}")
print(f"Skor R^2: {model_pipeline.score(X_test, y_test):.2f}")

# 8. Simpan SELURUH Pipeline
# Ini sangat penting! Kita menyimpan preprocessor DAN model yang sudah dilatih.
# Jadi, saat nanti dipakai untuk prediksi, data baru akan otomatis diproses dengan benar.
joblib.dump(model_pipeline, 'student_score_model.pkl')
print("Pipeline lengkap (preprocessor + model) berhasil disimpan sebagai 'student_score_model.pkl'.")