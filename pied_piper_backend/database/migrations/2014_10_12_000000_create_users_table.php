<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up()
    {
        Schema::create('users', function (Blueprint $table) {
            $table->id();
            $table->string('name')->unique();
            $table->string('email')->unique();
            $table->timestamp('email_verified_at')->nullable();
            $table->string('password');
            $table->string('picture')->default("https://res.cloudinary.com/dxntbhjao/image/upload/v1659863927/1/posts/pjfemlrvoh3dlokoccpp.jpg");
            $table->string('cover')->default('https://res.cloudinary.com/dxntbhjao/image/upload/v1659863975/1/posts/oox0omtyvag3egnfq7h9.webp');
            $table->boolean('available_to_hire')->default(0);
            $table->string('location')->nullable();
            $table->string('job_title')->nullable();
            $table->rememberToken();
            $table->timestamps();
        });
    }

    public function down()
    {
        Schema::dropIfExists('users');
    }
};
