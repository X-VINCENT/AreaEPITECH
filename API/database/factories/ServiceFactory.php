<?php

namespace Database\Factories;

use App\Models\Service;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends Factory<Service>
 */
class ServiceFactory extends Factory
{
    protected $model = Service::class;

    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'key' => $this->faker->unique()->word,
            'name' => $this->faker->company,
            'logo_url' => $this->faker->url,
            'is_oauth' => $this->faker->boolean,
        ];
    }

    public function openMeteo(): ServiceFactory
    {
        return $this->state([
            'key' => 'openMeteo',
            'name' => 'Open Météo',
            'logo_url' => 'https://avatars.githubusercontent.com/u/86407831?s=280&v=4',
            'is_oauth' => false,
        ]);
    }

    public function github(): ServiceFactory
    {
        return $this->state([
            'key' => 'github',
            'name' => 'GitHub',
            'logo_url' => 'https://upload.wikimedia.org/wikipedia/commons/9/91/Octicons-mark-github.svg',
            'is_oauth' => true,
        ]);
    }

    public function google(): ServiceFactory
    {
        return $this->state([
            'key' => 'google',
            'name' => 'Google',
            'logo_url' => 'https://upload.wikimedia.org/wikipedia/commons/5/53/Google_%22G%22_Logo.svg',
            'is_oauth' => true,
        ]);
    }

    public function newsApi(): ServiceFactory
    {
        return $this->state([
            'key' => 'newsApi',
            'name' => 'News API',
            'logo_url' => 'https://t.ly/0tUtK',
            'is_oauth' => false,
        ]);
    }

    public function gitlab(): ServiceFactory
    {
        return $this->state([
            'key' => 'gitlab',
            'name' => 'GitLab',
            'logo_url' => 'https://upload.wikimedia.org/wikipedia/commons/3/35/GitLab_icon.svg',
            'is_oauth' => true,
        ]);
    }

    public function stackExchange(): ServiceFactory
    {
        return $this->state([
            'key' => 'stackexchange',
            'name' => 'Stack Exchange',
            'logo_url' => 'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e0/Stack_Exchange_icon.svg/1200px-Stack_Exchange_icon.svg.png',
            'is_oauth' => true,
        ]);
    }

    public function microsoft(): ServiceFactory
    {
        return $this->state([
            'key' => 'microsoft',
            'name' => 'Microsoft',
            'logo_url' => 'https://upload.wikimedia.org/wikipedia/commons/0/0e/Microsoft_365_%282022%29.svg',
            'is_oauth' => true,
        ]);
    }
}
