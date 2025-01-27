<?php

declare(strict_types=1);

namespace App\Http\Controllers;

use App\Joke;
use Illuminate\Http\JsonResponse;

class ApiController
{
    public function __invoke(): JsonResponse
    {
        return response()->json(['joke' => Joke::random()]);
    }
}
