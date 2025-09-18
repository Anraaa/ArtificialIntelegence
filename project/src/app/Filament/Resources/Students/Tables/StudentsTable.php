<?php

namespace App\Filament\Resources\Students\Tables;

use Filament\Actions\BulkActionGroup;
use Filament\Actions\DeleteBulkAction;
use Filament\Actions\EditAction;
use Filament\Tables\Columns\TextColumn;
use Filament\Tables\Table;
use App\Models\Post;
use Filament\Actions\Action;
use Filament\Actions\DeleteAction;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Http;
use Filament\Notifications\Notification;

class StudentsTable
{
    public static function configure(Table $table): Table
    {
        return $table
            ->columns([
                TextColumn::make('name')->label('Nama Siswa')->searchable()->sortable(),
                TextColumn::make('weekly_self_study_hours')->label('Jam Belajar')->sortable(),
                TextColumn::make('attendance_percentage')->label('Kehadiran (%)')->sortable(),
                TextColumn::make('class_participation')->label('Partisipasi')->sortable(),
                TextColumn::make('predicted_score')
                    ->label('Prediksi Skor')
                    ->sortable()
                    ->formatStateUsing(fn ($state) => $state ? round($state, 2) : 'N/A'),
            ])
            ->filters([
                //
            ])
            ->recordActions([
                EditAction::make(),
                DeleteAction::make(),
                Action::make('predictScore')
                    ->label('Prediksi')
                    ->icon('heroicon-o-sparkles')
                    ->color('success')
                    ->requiresConfirmation()
                    ->action(function (Model $record) {
                        try {
                            $response = Http::timeout(10)
                                ->post('http://host.docker.internal:5000/predict', [
                                    'weekly_self_study_hours' => (float)$record->weekly_self_study_hours,
                                    'attendance_percentage' => (float)$record->attendance_percentage,
                                    'class_participation' => (float)$record->class_participation,
                                ]);

                            if ($response->successful()) {
                                $predictedScore = $response->json()['predicted_score'];
                                $record->update(['predicted_score' => $predictedScore]);
                                Notification::make()
                                    ->title('Prediksi Berhasil!')
                                    ->body('Prediksi skor untuk ' . $record->name . ' adalah: ' . round($predictedScore, 2))
                                    ->success()
                                    ->send();
                            } else {
                                Notification::make()
                                    ->title('Prediksi Gagal: Server Error')
                                    ->body('Detail: ' . ($response->json()['error'] ?? 'Terjadi error di server API.'))
                                    ->danger()
                                    ->send();
                            }
                        } catch (\Illuminate\Http\Client\ConnectionException $e) {
                            Notification::make()
                                ->title('Prediksi Gagal: Error Koneksi')
                                ->body('Tidak dapat terhubung ke API Python. Pastikan server API berjalan.')
                                ->danger()
                                ->send();
                        }
                    }),

            ])
            ->toolbarActions([
                BulkActionGroup::make([
                    DeleteBulkAction::make(),
                ]),
            ]);
    }
}
