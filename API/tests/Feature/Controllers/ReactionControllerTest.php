<?php

namespace Tests\Feature\Controllers;

use App\Models\User;
use Tests\TestCase;

class ReactionControllerTest extends TestCase
{
    protected $testUser;

    public function setUp(): void
    {
        parent::setUp();
        $this->testUser = User::findOrFail(1);
    }

    public function test_reaction_unit_get_all()
    {
        $this->actingAs($this->testUser);
        $response = $this->get("/api/reactions");
        $response
            ->assertStatus(200)
            ->assertJsonStructure([
                'success',
                'message',
                'data',
            ]);
    }

    public function test_reaction_unit_get_one()
    {
        $this->actingAs($this->testUser);
        $response = $this->get("/api/reactions/2");
        $response
            ->assertStatus(200)
            ->assertJsonStructure([
                'success',
                'message',
                'data',
            ]);
    }

    public function test_reaction_unit_count()
    {
        $this->actingAs($this->testUser);
        $response = $this->get("/api/reactions");
        $response
            ->assertStatus(200)
            ->assertJsonStructure([
                'success',
                'message',
                'data',
            ]);

        $this->assertTrue(count($response['data']) >= 11);
    }
}
