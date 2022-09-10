<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up()
    {
        Schema::create('search_histories', function (Blueprint $table) {
            $table->id();
            $table->foreignId("user_id")->references('id')->on('users')->onDelete('cascade');
            $table->integer("searched_id");
            $table->timestamps();
        });
    }

    public function down()
    {
        Schema::dropIfExists('search_histories');
    }
};
