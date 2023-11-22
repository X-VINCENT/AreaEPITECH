<?php

namespace Tests\Feature;

use Tests\TestCase;

class AuthFeatureTest extends TestCase
{
    /**
     * Test auth routes.
     */
    public function test_auth_google_features()
    {
        $response = $this->get('/api/auth/google');

        $response->assertStatus(200);
    }

    public function test_auth_github_features()
    {
        $response = $this->get('/api/auth/github');

        $response->assertStatus(200);
    }

    public function test_auth_gitlab_features()
    {
        $response = $this->get('/api/auth/gitlab');

        $response->assertStatus(200);
    }
}
