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
            $table->string('stackexchange_id')->nullable();
            $table->string('stackexchange_token')->nullable();
            $table->string('stackexchange_refresh_token')->nullable();
            $table->dateTime('stackexchange_expires_at')->nullable();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->dropColumn([
                'stackexchange_id',
                'stackexchange_token',
                'stackexchange_refresh_token',
                'stackexchange_expires_at',
            ]);
        });
    }
};
