<?php

namespace Database\Seeders;

use App\Models\Action;
use Illuminate\Database\Seeder;

class ActionSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $serviceKeyToId = Action::factory()->get_services_id();

        $openMeteo_id = $serviceKeyToId['openMeteo'];
        $github_id = $serviceKeyToId['github'];
        $google_id = $serviceKeyToId['google'];
        $newsApi_id = $serviceKeyToId['newsApi'];
        $gitlab_id = $serviceKeyToId['gitlab'];
        $stackexchange_id = $serviceKeyToId['stackexchange'];
        $microsoft_id = $serviceKeyToId['microsoft'];

        Action::factory()->receiveMail($google_id)->create();
        Action::factory()->higherTemp($openMeteo_id)->create();
        Action::factory()->lowerTemp($openMeteo_id)->create();
        Action::factory()->higherHumidity($openMeteo_id)->create();
        Action::factory()->lowerHumidity($openMeteo_id)->create();
        Action::factory()->higherWindSpeed($openMeteo_id)->create();
        Action::factory()->lowerWindSpeed($openMeteo_id)->create();
        Action::factory()->higherPrecipitation($openMeteo_id)->create();
        Action::factory()->lowerPrecipitation($openMeteo_id)->create();
        Action::factory()->lastHourNews($newsApi_id)->create();
        Action::factory()->commitMadeOnGitLabRepo($gitlab_id)->create();
        Action::factory()->assignedToGitlabIssue($gitlab_id)->create();
        Action::factory()->commitMadeOnGitHubRepo($github_id)->create();
        Action::factory()->assignedToGitHubIssue($github_id)->create();
        Action::factory()->receiveMailOutlook($microsoft_id)->create();
    }
}
