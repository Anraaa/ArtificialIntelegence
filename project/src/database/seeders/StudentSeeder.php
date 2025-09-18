<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use App\Models\Student; // Pastikan untuk mengimpor model Student

class StudentSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        // Siapkan data dummy dalam bentuk array
        $students = [
            [
                'name' => 'Budi Santoso',
                'weekly_self_study_hours' => 10,
                'attendance_percentage' => 95,
                'class_participation' => 7,
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'name' => 'Citra Lestari',
                'weekly_self_study_hours' => 18,
                'attendance_percentage' => 88,
                'class_participation' => 9,
                'created_at' => now(),
                'updated_at' => now(),
            ],
        ];

        // Masukkan data ke dalam tabel 'students'
        Student::insert($students);
    }
}