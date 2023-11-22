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
            $table->string('github_id')->nullable()->after('google_refresh_token');
            $table->text('github_token')->nullable()->after('github_id');
            $table->text('github_refresh_token')->nullable()->after('github_token');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
    }
};
