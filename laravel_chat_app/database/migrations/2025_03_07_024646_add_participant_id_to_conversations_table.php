<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up()
    {
        Schema::table('conversations', function (Blueprint $table) {
            $table->foreignId('participant_id')->after('user_id')->constrained('users')->onDelete('cascade');
        });
    }
    
    public function down()
    {
        Schema::table('conversations', function (Blueprint $table) {
            $table->dropForeign(['participant_id']);
            $table->dropColumn('participant_id');
        });
    }
};
