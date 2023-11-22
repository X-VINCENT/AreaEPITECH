<?php

namespace App\Console;

use App\Jobs\AreaJob;
use App\Models\Area;
use Illuminate\Console\Scheduling\Schedule;
use Illuminate\Foundation\Bus\DispatchesJobs;
use Illuminate\Foundation\Console\Kernel as ConsoleKernel;

class Kernel extends ConsoleKernel
{
    use DispatchesJobs;

    /**
     * The Artisan commands provided by your application.
     *
     * @var array
     */
    protected $commands = [
    ];

    /**
     * Define the application's command schedule.
     */
    protected function schedule(Schedule $schedule): void
    {
        $schedule->call(function () use ($schedule) {
            $areas = Area::where(function($query) {
                $query->whereRaw('EXTRACT(EPOCH FROM (NOW() - last_executed)) > refresh_delay')
                    ->orWhereNull('last_executed');
            })->get();

            foreach ($areas as $area) {
                $this->dispatch(new AreaJob($area));
            }
        })->everyMinute();
    }

    /**
     * Register the commands for the application.
     */
    protected function commands(): void
    {
        $this->load(__DIR__.'/Commands');

        require base_path('routes/console.php');
    }
}
