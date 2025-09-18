<?php

namespace App\Filament\Widgets;

use App\Models\Student;
use Filament\Widgets\ChartWidget;
use Filament\Support\RawJs;

class PredictedScoreDistributionChart extends ChartWidget
{
    protected ?string $heading = 'Analisis Performa Siswa (dengan Filter & Aksi)';

    protected int | string | array $columnSpan = 'full';

    protected function getData(): array
    {
        $query = Student::whereNotNull('predicted_score');
        
        $students = $query->get();

        if ($students->isEmpty()) {
            return ['datasets' => [], 'labels' => []];
        }

        $labels = [];
        for ($i = 0; $i <= 90; $i += 10) { $labels[] = "{$i}-" . ($i + 9); }
        
        $scoreCounts = array_fill(0, count($labels), 0);
        $studyHoursSum = array_fill(0, count($labels), 0);
        $averageStudyHours = array_fill(0, count($labels), 0);
        
        foreach ($students as $student) {
            $index = floor($student->predicted_score / 10);
            if (isset($scoreCounts[$index])) {
                $scoreCounts[$index]++;
                $studyHoursSum[$index] += $student->weekly_self_study_hours;
            }
        }
        foreach ($studyHoursSum as $index => $totalHours) {
            if ($scoreCounts[$index] > 0) {
                $averageStudyHours[$index] = round($totalHours / $scoreCounts[$index], 2);
            }
        }

        return [
            'datasets' => [
                ['type' => 'bar', 'label' => 'Jumlah Siswa', 'data' => $scoreCounts, 'yAxisID' => 'y'],
                ['type' => 'line', 'label' => 'Rata-rata Jam Belajar', 'data' => $averageStudyHours, 'borderColor' => '#FF6384', 'backgroundColor' => '#FFB1C1', 'yAxisID' => 'y1', 'tension' => 0.3],
            ],
            'labels' => $labels,
        ];
    }
    
    protected function getType(): string { return 'bar'; }

    protected function getChartJsOptions(): ?array
    {
        $labels = $this->getData()['labels'];
        return [
            'borderRadius' => 5,
            'scales' => [
                'y' => ['display' => true, 'position' => 'left', 'title' => ['display' => true, 'text' => 'Jumlah Siswa']],
                'y1' => ['display' => true, 'position' => 'right', 'title' => ['display' => true, 'text' => 'Rata-rata Jam Belajar'], 'grid' => ['drawOnChartArea' => false]],
            ],
            'plugins' => [
                'tooltip' => [
                    'callbacks' => [
                        'label' => new RawJs("
                            function (context) {
                                let label = context.dataset.label || '';
                                if (label) { label += ': '; }
                                if (context.parsed.y !== null) {
                                    if (context.dataset.type === 'line') {
                                        label += context.parsed.y + ' jam';
                                    } else {
                                        label += context.parsed.y + ' siswa';
                                    }
                                }
                                return label;
                            }
                        "),
                    ],
                ],
            ],
            'backgroundColor' => new RawJs("
                (ctx) => {
                    const chart = ctx.chart;
                    const {ctx: context, chartArea} = chart;
                    if (!chartArea) { return; }
                    const gradient = context.createLinearGradient(0, chartArea.bottom, 0, chartArea.top);
                    gradient.addColorStop(0, 'rgba(54, 162, 235, 0.2)');
                    gradient.addColorStop(1, 'rgba(54, 162, 235, 0.8)');
                    return gradient;
                }
            "),
        ];
    }
}