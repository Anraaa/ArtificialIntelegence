<?php

namespace App\Filament\Resources\Students\Schemas;

use Filament\Forms\Components\TextInput;
use Filament\Schemas\Schema;

class StudentForm
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                TextInput::make('name')
                    ->label('Nama Siswa')
                    ->required()
                    ->maxLength(255),
                TextInput::make('weekly_self_study_hours')
                    ->label('Jam Belajar Mandiri per Minggu')
                    ->numeric()->required()->minValue(0)->maxValue(40),
                TextInput::make('attendance_percentage')
                    ->label('Persentase Kehadiran (%)')
                    ->numeric()->required()->minValue(50)->maxValue(100),
                TextInput::make('class_participation')
                    ->label('Partisipasi Kelas (0-10)')
                    ->numeric()->required()->minValue(0)->maxValue(10),
                TextInput::make('predicted_score')
                    ->label('Hasil Prediksi Skor')
                    ->numeric()
                    ->disabled()
                    ->placeholder('Hasil prediksi akan muncul di sini'),
            ]);
    }
}
