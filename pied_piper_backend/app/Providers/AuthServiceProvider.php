<?php

namespace App\Providers;

use App\Models\Chat;
use App\Models\Comment;
use App\Models\Message;
use App\Models\Post;
use App\Models\Saved_Post;
use App\Models\Shared_Post;
use App\Models\Story;
use App\Policies\ChatPolicy;
use App\Policies\CommentPolicy;
use App\Policies\MessagePolicy;
use App\Policies\PostPolicy;
use App\Policies\Saved_PostPolicy;
use App\Policies\Shared_PostPolicy;
use App\Policies\StoryPolicy;
use Illuminate\Foundation\Support\Providers\AuthServiceProvider as ServiceProvider;
use Illuminate\Support\Facades\Gate;

class AuthServiceProvider extends ServiceProvider
{
    /**
     * The model to policy mappings for the application.
     *
     * @var array<class-string, class-string>
     */
    protected $policies = [
        // 'App\Models\Model' => 'App\Policies\ModelPolicy',
        Post::class => PostPolicy::class,
        Comment::class => CommentPolicy::class,
        Shared_Post::class =>Shared_PostPolicy::class,
        Saved_Post::class =>Saved_PostPolicy::class,
        Story::class =>StoryPolicy::class,
        Chat::class =>ChatPolicy::class,
        Message::class =>MessagePolicy::class,
    ];

    /**
     * Register any authentication / authorization services.
     *
     * @return void
     */
    public function boot()
    {
        $this->registerPolicies();

        //
    }
}
