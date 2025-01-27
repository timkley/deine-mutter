<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">

        <title>{{ $title ?? 'Deine Mutter Witze API' }}</title>
        <link rel="icon" href="https://fav.farm/🤱🏻"/>
        @vite(['resources/css/app.css', 'resources/js/app.js'])
    </head>
    <body class="bg-slate-100 py-12">
        {{ $slot }}

        <script async defer data-website-id="d272ca72-5b4a-40e1-8b80-1e22772779bf" src="https://c3po.wacg.dev/protocol.js"></script>
    </body>
</html>
