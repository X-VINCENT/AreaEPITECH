<?php

namespace Database\Seeders;

use App\Models\Reaction;
use Illuminate\Database\Seeder;

class ReactionSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $serviceKeyToId = Reaction::factory()->get_services_id();

        $github_id = $serviceKeyToId['github'];
        $google_id = $serviceKeyToId['google'];
        $gitlab_id = $serviceKeyToId['gitlab'];
        $stackexchange_id = $serviceKeyToId['stackexchange'];
        $microsoft_id = $serviceKeyToId['microsoft'];

        Reaction::factory()->sendMail($google_id)->create();
        Reaction::factory()->addEventToGoogleCalendar($google_id)->create();
        Reaction::factory()->writeGoogleDoc($google_id)->create();
        Reaction::factory()->addIssueToGitHubRepo($github_id)->create();
        Reaction::factory()->addIssueToGitLabRepo($gitlab_id)->create();
        Reaction::factory()->createStackExchangeComment($stackexchange_id)->create();
        Reaction::factory()->sendOutlookMail($microsoft_id)->create();
        Reaction::factory()->addEventToMicrosoftCalendar($microsoft_id)->create();
        Reaction::factory()->addMicrosoftNote($microsoft_id)->create();
        Reaction::factory()->addMicrosoftTask($microsoft_id)->create();
        Reaction::factory()->sendMicrosoftChatMessage($microsoft_id)->create();
    }
}
