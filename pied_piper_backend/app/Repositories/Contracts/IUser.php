<?php

namespace App\Repositories\Contracts;

interface IUser
{
    public function forceFillPassword($email, $data);
    public function findAndVerify($email);
    public function searchUsers();
}
