<?php

namespace App\Repositories\Contracts;

interface IReaction
{
    public function isReaction($type,$id):bool;
    public function myReactionType($type,$id):string;
    public function reactionsType($post) : array;
}
