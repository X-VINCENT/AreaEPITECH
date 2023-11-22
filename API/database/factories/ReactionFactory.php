<?php

namespace Database\Factories;

use App\Models\Reaction;
use App\Models\Service;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Reaction>
 */
class ReactionFactory extends Factory
{
    protected $model = Reaction::class;

    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */

    public function get_services_id(): array
    {
        return Service::select('key', 'id')->get()->pluck('id', 'key')->toArray();
    }

    public function definition(): array
    {
        return [
            'key' => $this->faker->unique()->word,
            'name' => $this->faker->sentence,
            'description' => $this->faker->paragraph,
            'service_id' => 1,
        ];
    }

    public function sendMail(int $service_id): ReactionFactory
    {
        return $this->state([
            'key' => 'sendMail',
            'name' => 'Send mail',
            'description' => 'Send mail',
            'service_id' => $service_id,
            'config_keys' => '[{"id":"mail","type":"string"},{"id":"subject","type":"string"}]'
        ]);
    }

    public function addEventToGoogleCalendar(int $service_id): ReactionFactory
    {
        return $this->state([
            'key' => 'addEventToGoogleCalendar',
            'name' => 'Add an event to Google Calendar',
            'description' => 'Add an event to Google Calendar',
            'service_id' => $service_id,
            'config_keys' => '[{"id":"calendarId","type":"string"},{"id":"title","type":"string"},{"id":"start","type":"dateTime"},{"id":"end","type":"dateTime"}]'
        ]);
    }

    public function writeGoogleDoc(int $service_id): ReactionFactory
    {
        return $this->state([
            'key' => 'writeGoogleDoc',
            'name' => 'Write on a Google Doc',
            'description' => 'Write on a Google Doc document',
            'service_id' => $service_id,
            'config_keys' => '[{"id":"documentName","type":"string"}]'
        ]);
    }

    public function addIssueToGitHubRepo(int $service_id): ReactionFactory
    {
        return $this->state([
            'key' => 'addIssueToGitHubRepo',
            'name' => 'Add an issue to GitHub repository',
            'description' => 'Add an issue to GitHub repository',
            'service_id' => $service_id,
            'config_keys' => '[{"id":"owner","type":"string"},{"id":"repo","type":"string"},{"id":"title","type":"string"}]'
        ]);
    }

    public function addIssueToGitLabRepo(int $service_id): ReactionFactory
    {
        return $this->state([
            'key' => 'addIssueToGitLabRepo',
            'name' => 'Add an issue to GitLab repository',
            'description' => 'Add an issue to GitLab repository',
            'service_id' => $service_id,
            'config_keys' => '[{"id":"owner","type":"string"},{"id":"repo","type":"string"},{"id":"title","type":"string"}]'
        ]);
    }

    public function createStackExchangeComment(int $service_id): ReactionFactory
    {
        return $this->state([
            'key' => 'createStackExchangeComment',
            'name' => 'Create a Stack Exchange comment',
            'description' => 'Create a Stack Exchange comment',
            'service_id' => $service_id,
            'config_keys' => '[{"id":"postId","type":"string"}]'
        ]);
    }

    public function sendOutlookMail(int $service_id): ReactionFactory
    {
        return $this->state([
            'key' => 'sendOutlookMail',
            'name' => 'Send a mail with Outlook',
            'description' => 'Send a mail with Outlook',
            'service_id' => $service_id,
            'config_keys' => '[{"id":"mail","type":"string"},{"id":"subject","type":"string"}]'
        ]);
    }

    public function addEventToMicrosoftCalendar(int $service_id): ReactionFactory
    {
        return $this->state([
            'key' => 'addEventToMicrosoftCalendar',
            'name' => 'Add an event to Microsoft calendar',
            'description' => 'Add an event to Microsoft calendar',
            'service_id' => $service_id,
            'config_keys' => '[{"id":"calendarId","type":"string"},{"id":"title","type":"string"},{"id":"start","type":"dateTime"},{"id":"end","type":"dateTime"}]'
        ]);
    }

    public function addMicrosoftNote(int $service_id): ReactionFactory
    {
        return $this->state([
            'key' => 'addMicrosoftNote',
            'name' => 'Add a Microsoft note',
            'description' => 'Add a note to Microsoft OneNote',
            'service_id' => $service_id,
            'config_keys' => '[{"id":"notebookName","type":"string"},{"id":"sectionName","type":"string"},{"id":"pageName","type":"string"}]'
        ]);
    }

    public function addMicrosoftTask(int $service_id): ReactionFactory
    {
        return $this->state([
            'key' => 'addMicrosoftTask',
            'name' => 'Add a Microsoft task',
            'description' => 'Add a task to Microsoft To-Do',
            'service_id' => $service_id,
            'config_keys' => '[{"id":"taskListName","type":"string"},{"id":"title","type":"string"}]'
        ]);
    }

    public function sendMicrosoftChatMessage(int $service_id): ReactionFactory
    {
        return $this->state([
            'key' => 'sendMicrosoftChatMessage',
            'name' => 'Send a message in Microsoft chat',
            'description' => 'Send a message in Microsoft chat',
            'service_id' => $service_id,
            'config_keys' => '[{"id":"chatId","type":"string"}]'
        ]);
    }

}
