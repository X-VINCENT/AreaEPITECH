<?php

namespace Tests\Feature\Controllers;

use Tests\TestCase;

class ServiceControllerTest extends TestCase
{
    /**
     * Test service controller.
     */
    public function test_services_get_all()
    {
        $response = $this->json('get', '/api/services');

        $response
            ->assertStatus(200)
            ->assertJsonStructure([
                'data' => [
                    '*' => [
                        'id',
                        'key',
                        'name',
                        'logo_url',
                        'created_at',
                        'updated_at',
                        'is_oauth',
                    ]
                ],
            ]);
    }

    public function test_services_get_one()
    {
        $response = $this->json('get', '/api/services/1');

        $response
            ->assertStatus(200)
            ->assertJsonStructure([
                'data' => [
                    'id',
                    'key',
                    'name',
                    'logo_url',
                    'created_at',
                    'updated_at',
                    'is_oauth',
                ],
            ]);
    }

    public function test_services_count()
    {
        $response = $this->json('get', '/api/services');

        $response->assertStatus(200);
        $this->assertTrue(count($response['data']) >= 7);
    }
}
