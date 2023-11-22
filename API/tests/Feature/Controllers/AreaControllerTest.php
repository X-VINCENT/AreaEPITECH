<?php

namespace Tests\Feature\Controllers;

use App\Models\Area;
use App\Models\User;
use Exception;
use Tests\TestCase;

class AreaControllerTest extends TestCase
{
    protected $testUser;

    public function setUp(): void
    {
        parent::setUp();
        $this->testUser = User::find(1);

        if (!$this->testUser) {
            throw new Exception('User with ID 0 not found.');
        }
    }

    public function test_area_unit_get_all()
    {
        $this->actingAs($this->testUser);
        $response = $this->get('/api/areas');
        $response
            ->assertStatus(200)
            ->assertJsonStructure([
                'data' => [
                    '*' => [
                        'id',
                        'user_id',
                        'name',
                        'description',
                        'active',
                        'action_id',
                        'reaction_id',
                        'created_at',
                        'updated_at',
                        'action_config',
                        'reaction_config',
                        'last_executed',
                        'refresh_delay',
                    ],
                ],
            ]);
    }

    public function test_area_unit_get_one()
    {
        $this->actingAs($this->testUser);
        $response = $this->get('/api/areas/1');
        $response
            ->assertStatus(200)
            ->assertJsonStructure([
                'data' => [
                    'id',
                    'user_id',
                    'name',
                    'description',
                    'active',
                    'action_id',
                    'reaction_id',
                    'created_at',
                    'updated_at',
                    'action_config',
                    'reaction_config',
                    'last_executed',
                    'refresh_delay'
                ],
            ]);
    }

    public function test_area_unit_post()
    {
        $postData = [
            'name' => 'Test Area',
            'description' => 'Test Description',
            'active' => true,
            'action_id' => 10,
            'reaction_id' => 1,
            'action_config' => ['keywords' => 'personal development, finance, money'],
            'reaction_config' => [
                'mail' => 'test.tes@test.com',
                'subject' => 'Latest Personal Development, finance, money news',
            ],
            'refresh_delay' => 120,
        ];

        $response = $this->actingAs($this->testUser)
            ->post('/api/areas', $postData);
        $response
            ->assertStatus(200)
            ->assertJsonStructure([
                'data' => [
                    'id',
                    'name',
                    'description',
                    'active',
                    'action_id',
                    'action_config',
                    'reaction_id',
                    'reaction_config',
                    'user_id',
                    'updated_at',
                    'created_at',
                ],
            ])
            ->assertJsonFragment([
                'name' => 'Test Area',
                'description' => 'Test Description',
                'active' => true,
                'user_id' => $this->testUser->id,
                'action_id' => 10,
                'reaction_id' => 1,
                'action_config' => $postData['action_config'],
                'reaction_config' => $postData['reaction_config'],
                'refresh_delay' => 120,
            ]);
    }

    public function test_area_unit_update()
    {
        $lastAreaId = Area::latest('id')->value('id');

        $postData = [
            'name' => 'Test Area',
            'description' => 'Test Description',
            'active' => true,
            'action_id' => 10,
            'reaction_id' => 1,
            'action_config' => ['keywords' => 'personal development, finance, money'],
            'reaction_config' => [
                'mail' => 'test.tes@test.com',
                'subject' => 'Latest Personal Development, finance, money news',
            ],
            'refresh_delay' => 120,
        ];

        $response = $this->actingAs($this->testUser)
            ->put("/api/areas/{$lastAreaId}", $postData);
        $response
            ->assertStatus(200)
            ->assertJsonStructure([
                'data' => [
                    'id',
                    'name',
                    'description',
                    'active',
                    'action_id',
                    'action_config',
                    'reaction_id',
                    'reaction_config',
                    'user_id',
                    'updated_at',
                    'created_at',
                ],
            ])
            ->assertJsonFragment([
                'name' => 'Test Area',
                'description' => 'Test Description',
                'active' => true,
                'user_id' => $this->testUser->id,
                'action_id' => 10,
                'reaction_id' => 1,
                'action_config' => $postData['action_config'],
                'reaction_config' => $postData['reaction_config'],
                'refresh_delay' => 120,
            ]);
    }

    public function test_area_unit_get_execute()
    {
        $lastAreaId = Area::latest('id')->value('id');

        $this->actingAs($this->testUser);
        $response = $this->get("/api/areas/{$lastAreaId}/execute");
        $response
            ->assertStatus(200)
            ->assertJsonStructure([
                'success',
                'message',
                'data',
            ]);
    }

    public function test_area_unit_delete()
    {
        $lastAreaId = Area::latest('id')->value('id');

        $this->actingAs($this->testUser);
        $response = $this->delete("/api/areas/{$lastAreaId}");
        $response
            ->assertStatus(200)
            ->assertJsonStructure([
                'success',
                'message',
                'data' => [
                    'id',
                    'user_id',
                    'name',
                    'description',
                    'active',
                    'action_id',
                    'reaction_id',
                    'created_at',
                    'updated_at',
                    'action_config',
                    'reaction_config',
                    'last_executed',
                    'refresh_delay',
                ],
            ]);
    }
}
