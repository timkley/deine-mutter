<?php

declare(strict_types=1);

namespace App;

class Joke
{
    /**
     * Get all jokes.
     *
     * @return array<string>
     */
    public static function all(): array
    {
        return cache()->rememberForever('jokes', function (): array {
            $fileContents = file_get_contents(resource_path('jokes.json')) ?: '[]';

            /** @var array<string> */
            return json_decode($fileContents, true);
        });
    }

    public static function random(): string
    {
        $jokes = self::all();

        return $jokes[array_rand($jokes)];
    }
}
