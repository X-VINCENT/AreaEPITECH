<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;

// use Illuminate\Database\Console\Seeds\WithoutModelEvents;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        $this->call(ServiceSeeder::class);
        $this->call(UserSeeder::class);
        $this->call(ActionSeeder::class);
        $this->call(ReactionSeeder::class);
        $this->call(AreaSeeder::class);
        $this->call(AreaLogSeeder::class);
    }
}
