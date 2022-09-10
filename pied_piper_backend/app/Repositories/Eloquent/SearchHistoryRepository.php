<?php

namespace App\Repositories\Eloquent;

use App\Models\SearchHistory;
use App\Repositories\Contracts\ISearchHistory;

class SearchHistoryRepository extends BaseRepository implements ISearchHistory
{
    public function model(): string
    {
        return SearchHistory::class;
    }
}
