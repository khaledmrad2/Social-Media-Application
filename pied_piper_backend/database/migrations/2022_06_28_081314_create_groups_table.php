<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up()
    {
        Schema::create('groups', function (Blueprint $table) {
            $table->id();
            $table->foreignId("user_id")->references('id')->on('users')->onDelete('cascade');
            $table->string("title");
            $table->string("cover")->default('https://res.cloudinary.com/dxntbhjao/image/upload/v1659863975/1/posts/oox0omtyvag3egnfq7h9.webp');
            $table->string('security')->default("public");
            $table->timestamps();
        });
    }

    public function down()
    {
        Schema::dropIfExists('groups');
    }
};
