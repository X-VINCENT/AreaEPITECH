<?php

namespace Database\Seeders;

use App\Models\Service;
use Illuminate\Database\Seeder;

class ServiceSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        Service::factory()->openMeteo()->create();
        Service::factory()->github()->create();
        Service::factory()->google()->create();
        Service::factory()->newsApi()->create();
        Service::factory()->gitlab()->create();
        Service::factory()->stackExchange()->create();
        Service::factory()->microsoft()->create();
    }
}
