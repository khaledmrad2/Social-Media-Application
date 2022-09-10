<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up()
    {
        Schema::create('group_request_receivers', function (Blueprint $table) {
            $table->id();
            $table->foreignId("user_id")->references('id')->on('users')->onDelete('cascade');
            $table->foreignId("group_id")->references('id')->on('groups')->onDelete('cascade');
            $table->foreignId("requester_id");
            $table->string("type");
            $table->timestamps();
        });
    }

    public function down()
    {
        Schema::dropIfExists('group_request_receivers');
    }
};
