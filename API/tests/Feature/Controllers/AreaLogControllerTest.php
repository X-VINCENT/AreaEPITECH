<?php

namespace Tests\Feature\Controllers;

use App\Models\User;
use Tests\TestCase;

class AreaLogControllerTest extends TestCase
{
    protected $testUser;

    public function setUp(): void
    {
        parent::setUp();
        $this->testUser = User::findOrFail(1);
    }

    public function test_area_unit_get_all()
    {
        $this->actingAs($this->testUser);
        $response = $this->get("/api/areas/logs");
        $response
            ->assertStatus(200)
            ->assertJsonStructure([
                'success',
                'message',
                'data' => [
                    '*' => [
                        'id',
                        'area_id',
                        'created_at',
                        'updated_at',
                        'status',
                        'user_id',
                        'message',
                    ],
                ],
            ]);
    }

    public function test_area_unit_get_one()
    {
        $this->actingAs($this->testUser);
        $response = $this->get("/api/areas/1/logs");
        $response
            ->assertStatus(200)
            ->assertJsonStructure([
                'success',
                'message',
                'data' => [
                    '*' => [
                        'id',
                        'area_id',
                        'created_at',
                        'updated_at',
                        'status',
                        'user_id',
                        'message',
                    ],
                ],
            ]);
    }

}
