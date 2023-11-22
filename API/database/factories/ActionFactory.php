<?php

namespace Database\Factories;

use App\Models\Action;
use App\Models\Service;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Action>
 */
class ActionFactory extends Factory
{
    protected $model = Action::class;

    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'key' => $this->faker->unique()->word,
            'name' => $this->faker->sentence,
            'description' => $this->faker->paragraph,
            'service_id' => 1,
        ];
    }

    public function get_services_id(): array
    {
        return Service::select('key', 'id')->get()->pluck('id', 'key')->toArray();
    }

    public function receiveMail(int $service_id): ActionFactory
    {
        return $this->state([
            'key' => 'receiveMail',
            'name' => 'Receive mail',
            'description' => 'Receive mail',
            'service_id' => $service_id,
        ]);
    }

    public function commitMadeOnGitLabRepo(int $service_id): ActionFactory
    {
        return $this->state([
            'key' => 'commitMadeOnGitLabRepo',
            'name' => 'A commit has been made on a GitLab repo',
            'description' => 'If a commit has been made on a repository since the last execution of the action, an action is triggered',
            'service_id' => $service_id,
            'config_keys' => '[{"id":"projectId","type":"string"}]'
        ]);
    }

    public function higherTemp(int $service_id): ActionFactory
    {
        return $this->state([
            'key' => 'higherTemp',
            'name' => 'Temperature higher than...',
            'description' => 'When the temperature is higher than... °C, the action is triggered',
            'service_id' => $service_id,
            'config_keys' => '[{"id":"latitude","type":"number"},{"id":"longitude","type":"number"},{"id":"temperature","type":"number"}]'
        ]);
    }

    public function higherHumidity(int $service_id): ActionFactory
    {
        return $this->state([
            'key' => 'higherHumidity',
            'name' => 'Humidity higher than...',
            'description' => 'When the humidity is higher than... °C, the action is triggered',
            'service_id' => $service_id,
            'config_keys' => '[{"id":"latitude","type":"number"},{"id":"longitude","type":"number"},{"id":"humidity","type":"number"}]'
        ]);
    }

    public function lowerHumidity(int $service_id): ActionFactory
    {
        return $this->state([
            'key' => 'lowerHumidity',
            'name' => 'Humidity lower than...',
            'description' => 'When the humidity is lower than... °C, the action is triggered',
            'service_id' => $service_id,
            'config_keys' => '[{"id":"latitude","type":"number"},{"id":"longitude","type":"number"},{"id":"humidity","type":"number"}]'
        ]);
    }

    public function lowerTemp(int $service_id): ActionFactory
    {
        return $this->state([
            'key' => 'lowerTemp',
            'name' => 'Temperature lower than...',
            'description' => 'When the temperature is lower than... °C, the action is triggered',
            'service_id' => $service_id,
            'config_keys' => '[{"id":"latitude","type":"number"},{"id":"longitude","type":"number"},{"id":"temperature","type":"number"}]'
        ]);
    }

    public function higherWindSpeed(int $service_id): ActionFactory
    {
        return $this->state([
            'key' => 'higherWindSpeed',
            'name' => 'Wind speed higher than...',
            'description' => 'When the wind speed is higher than... km/h, the action is triggered',
            'service_id' => $service_id,
            'config_keys' => '[{"id":"latitude","type":"number"},{"id":"longitude","type":"number"},{"id":"windSpeed","type":"number"}]'
        ]);
    }

    public function lowerWindSpeed(int $service_id): ActionFactory
    {
        return $this->state([
            'key' => 'lowerWindSpeed',
            'name' => 'Wind speed lower than...',
            'description' => 'When the wind speed is lower than... km/h, the action is triggered',
            'service_id' => $service_id,
            'config_keys' => '[{"id":"latitude","type":"number"},{"id":"longitude","type":"number"},{"id":"windSpeed","type":"number"}]'
        ]);
    }

    public function higherPrecipitation(int $service_id): ActionFactory
    {
        return $this->state([
            'key' => 'higherPrecipitation',
            'name' => 'Precipitation higher than...',
            'description' => 'When the precipitation is higher than... mm, the action is triggered',
            'service_id' => $service_id,
            'config_keys' => '[{"id":"latitude","type":"number"},{"id":"longitude","type":"number"},{"id":"precipitation","type":"number"}]'
        ]);
    }

    public function lowerPrecipitation(int $service_id): ActionFactory
    {
        return $this->state([
            'key' => 'lowerPrecipitation',
            'name' => 'Precipitation lower than...',
            'description' => 'When the precipitation is lower than... mm, the action is triggered',
            'service_id' => $service_id,
            'config_keys' => '[{"id":"latitude","type":"number"},{"id":"longitude","type":"number"},{"id":"precipitation","type":"number"}]'
        ]);
    }

    public function lastHourNews(int $service_id): ActionFactory
    {
        return $this->state([
            'key' => 'lastHourNews',
            'name' => 'The latest news of the hour',
            'description' => 'Get the latest news with the given keywords in the hour. If there are news, the action is triggered.',
            'service_id' => $service_id,
            'config_keys' => '[{"id":"keywords","type":"string","maxLength":"400"}]'
        ]);
    }

    public function assignedToGitlabIssue(int $service_id): ActionFactory
    {
        return $this->state([
            'key' => 'assignedToGitlabIssue',
            'name' => 'Assigned to a GitLab issue that ends in less than...',
            'description' => 'When you are assigned to a GitLab issue that ends in less than... an action is triggered',
            'service_id' => $service_id,
            'config_keys' => '[{"id":"projectId","type":"string"}]'
        ]);
    }

    public function commitMadeOnGitHubRepo(int $service_id): ActionFactory
    {
        return $this->state([
            'key' => 'commitMadeOnGitHubRepo',
            'name' => 'A commit has been made on a GitHub repo',
            'description' => 'If a commit has been made on a repository since the last execution of the action, an action is triggered',
            'service_id' => $service_id,
            'config_keys' => '[{"id":"owner","type":"string"},{"id":"repo","type":"string"}]'
        ]);
    }

    public function assignedToGitHubIssue(int $service_id): ActionFactory
    {
        return $this->state([
            'key' => 'assignedToGitHubIssue',
            'name' => 'Assigned to a GitHub issue that ends in less than...',
            'description' => 'When you are assigned to a GitHub issue that ends in less than... an action is triggered',
            'service_id' => $service_id,
            'config_keys' => '[{"id":"owner","type":"string"},{"id":"repo","type":"string"}]'
        ]);
    }

    public function receiveMailOutlook(int $service_id): ActionFactory
    {
        return $this->state([
            'key' => 'receiveMailOutlook',
            'name' => 'Receive mail from Outlook',
            'description' => 'If a mail has been received from Outlook, the action is triggered',
            'service_id' => $service_id,
            'config_keys' => null
        ]);
    }

}
