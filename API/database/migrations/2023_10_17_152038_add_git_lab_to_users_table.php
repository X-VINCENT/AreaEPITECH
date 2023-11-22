<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->string('gitlab_id')->nullable();
            $table->string('gitlab_token')->nullable();
            $table->string('gitlab_refresh_token')->nullable();
            $table->timestamp('gitlab_expires_at')->nullable();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->dropColumn([
                'gitlab_id',
                'gitlab_token',
                'gitlab_refresh_token',
                'gitlab_expires_at',
            ]);
        });
    }
};
