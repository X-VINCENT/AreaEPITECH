<?php

namespace Database\Factories;

use App\Models\Area;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<Area>
 */
class AreaFactory extends Factory
{
    protected $model = Area::class;

    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'user_id' => 1,
            'name' => $this->faker->word,
            'description' => $this->faker->sentence,
            'active' => true,
            'action_id' => $this->faker->numberBetween(1, 15),
            'reaction_id' => $this->faker->numberBetween(1, 11),
            'action_config' => '[]',
            'reaction_config' => '[]',
            'refresh_delay' => 60,
        ];
    }
}
