<?php

namespace Tests\Feature\Controllers;

use App\Models\User;
use Tests\TestCase;

class ActionControllerTest extends TestCase
{
    protected $testUser;

    public function setUp(): void
    {
        parent::setUp();
        $this->testUser = User::findOrFail(1);
    }

    public function test_action_unit_get_all()
    {
        $this->actingAs($this->testUser);
        $response = $this->get("/api/actions");
        $response
            ->assertStatus(200)
            ->assertJsonStructure([
                'success',
                'message',
                'data',
            ]);
    }

    public function test_action_unit_get_one()
    {
        $this->actingAs($this->testUser);
        $response = $this->get("/api/actions/2");
        $response
            ->assertStatus(200)
            ->assertJsonStructure([
                'success',
                'message',
                'data',
            ]);
    }

    public function test_action_unit_action_count()
    {
        $this->actingAs($this->testUser);
        $response = $this->get("/api/actions");
        $response
            ->assertStatus(200)
            ->assertJsonStructure([
                'success',
                'message',
                'data',
            ]);
        $this->assertTrue(count($response['data']) >= 15);
    }
}
