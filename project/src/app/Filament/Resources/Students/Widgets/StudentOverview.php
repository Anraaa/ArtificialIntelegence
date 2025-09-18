<?php

namespace App\Filament\Resources\Students\Widgets;

use App\Models\Student;
use Filament\Widgets\StatsOverviewWidget;
use Filament\Widgets\StatsOverviewWidget\Stat;

class StudentOverview extends StatsOverviewWidget
{
    protected function getStats(): array
    {
        // Menghitung rata-rata skor, bulatkan ke 2 desimal. 
        // Beri nilai 'N/A' jika belum ada data.
        $avgScore = Student::avg('predicted_score');
        $formattedAvgScore = $avgScore ? round($avgScore, 2) : 'N/A';

        return [
            // Stat #1: Total Siswa
            Stat::make('Total Siswa', Student::count())
                ->description('Jumlah semua siswa terdaftar')
                ->descriptionIcon('heroicon-m-users')
                ->color('primary'),

            // Stat #2: Rata-rata Skor Prediksi
            Stat::make('Rata-rata Skor Prediksi', $formattedAvgScore)
                ->description('Rata-rata dari semua skor yang telah diprediksi')
                ->descriptionIcon('heroicon-m-chart-bar')
                ->color('success'),

            // Stat #3: Siswa yang Belum Diprediksi
            Stat::make('Belum Diprediksi', Student::whereNull('predicted_score')->count())
                ->description('Siswa yang perlu diprediksi skornya')
                ->descriptionIcon('heroicon-m-clock')
                ->color('warning'),
        ];
    }
}