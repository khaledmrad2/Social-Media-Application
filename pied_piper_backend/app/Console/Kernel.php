<?php

namespace App\Console;

use App\Repositories\Eloquent\StoryRepository;
use Carbon\Carbon;
use Illuminate\Console\Scheduling\Schedule;
use Illuminate\Foundation\Console\Kernel as ConsoleKernel;

class Kernel extends ConsoleKernel
{
    /**
     * Define the application's command schedule.
     *
     * @param  \Illuminate\Console\Scheduling\Schedule  $schedule
     * @return void
     */
    protected function schedule(Schedule $schedule)
    {

         $schedule->command('inspire')->hourly();
        $schedule->call(function () {
            $storyRepo = new StoryRepository();
            $stories = $storyRepo->all();
            foreach ($stories as $story){
                if(  Carbon::now()->hour == $story->created_at->hour)
                    $storyRepo->delete($story->id);
            }
        })->hourly();
    }

    /**
     * Register the commands for the application.
     *
     * @return void
     */
    protected function commands()
    {
        $this->load(__DIR__.'/Commands');

        require base_path('routes/console.php');
    }
}
