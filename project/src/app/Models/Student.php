<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Student extends Model
{
    use HasFactory;

    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'name',
        'weekly_self_study_hours',
        'attendance_percentage',
        'class_participation',
        'predicted_score', // <-- Daftarkan kolom ini!
    ];
}