<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('complaints_replies', function (Blueprint $table) {
            $table->id();
            $table->foreignId('complaint_id')->references('id')->on('complaints')->onDelete('cascade');
            $table->foreignId('admin_id')->references('id')->on('admins')->onDelete('cascade');
            $table->string('text');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('complaints_replies');
    }
};
