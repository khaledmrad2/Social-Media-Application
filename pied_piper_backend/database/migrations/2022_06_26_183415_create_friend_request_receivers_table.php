<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up()
    {
        Schema::create('friend_request_receivers', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->references('id')->on('users')->onDelete('cascade');
            $table->integer("requester_id");
            $table->timestamps();
        });
    }

    public function down()
    {
        Schema::dropIfExists('friend_request_receivers');
    }
};
