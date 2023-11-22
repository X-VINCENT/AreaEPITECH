<?php

namespace App\Jobs;

use App\Models\Area;
use App\Models\User;
use Exception;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;
use Log;

class AreaJob implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;

    protected $area;

    /**
     * Create a new job instance.
     */
    public function __construct(Area $area)
    {
        $this->area = $area;
    }

    /**
     * Execute the job.
     */
    public function handle(): void
    {
        User::where('id', $this->area->user_id)->get()->each(function (User $user) {
            try {
                if (!$this->area->active)
                    return;
                $res = $this->area->needUpdate($user);
                if ($res)
                    $this->area->execute($user, $res);

            } catch (Exception $e) {
                Log::error($e->getMessage());
                return;
            }
            Log::info($this->area);
        });
    }
}
