<?php

declare(strict_types=1);

use function Pest\Laravel\get;

test('it returns a random joke', function () {
get('/api')
->assertJsonStructure(['joke']);
    });
