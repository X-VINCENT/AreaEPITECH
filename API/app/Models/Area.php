<?php

namespace App\Models;

use Exception;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Area extends Model
{
    use HasFactory;

    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'user_id',
        'name',
        'description',
        'active',
        'action_id',
        'reaction_id',
        'action_config',
        'reaction_config',
        'refresh_delay',
    ];

    public function needUpdate(User $user): ?string
    {
        $action = Action::find($this->action_id);

        if (!isset($action))
            throw new Exception('Action not found.');

        $action_config = json_decode($this->action_config);
        $actionResult = $action->execute($user, $action_config, $this->last_executed);

        if (!$actionResult)
            throw new Exception('No Update needed');

        return $actionResult;
    }

    /**
     * @throws Exception
     */
    public function execute(User $user, string $actionResult): void
    {
        $reaction = Reaction::find($this->reaction_id);
        if (!isset($reaction)) {
            throw new Exception('Reaction not found.');
        }

        $reaction_config = json_decode($this->reaction_config);

        $area_log_input = [
            'user_id' => $user->id,
            'area_id' => $this->id,
            'status' => 'pending',
        ];
        $area_log = AreaLog::create($area_log_input);

        try {
            $reactionResult = $reaction->execute($user, $reaction_config, $actionResult);
            $this->last_executed = now();
            $this->save();
            if (!$reactionResult) {
                $area_log->message = 'Reaction failed.';
                $area_log->save();
                throw new Exception('Reaction failed.');
            }
        } catch (Exception $e) {
            $area_log->status = 'error';
            $area_log->message = $e->getMessage();
            $area_log->save();
            throw $e;
        }
        $area_log->status = 'success';
        $area_log->save();
    }
}
