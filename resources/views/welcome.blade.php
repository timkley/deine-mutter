@use(App\Joke)

<x-layouts.app>
    <div class="mx-auto max-w-2xl px-4 text-center">
        <h1 class="inline bg-gradient-to-r from-emerald-500 to-emerald-800 bg-clip-text font-display text-5xl tracking-tight text-transparent">Deine-Mutter-API</h1>
        <p class="mt-3 text-2xl tracking-tight text-slate-500">
            Rufe einen von {{ count(Joke::all()) }} zufälligen Deine-Mutter-Witzen über eine simple API ab:
        </p>

        <pre class="mt-12 bg-slate-50 p-3 rounded shadow whitespace-normal"><code>https://deine-mutter.timkley.dev/api</code></pre>

        <pre class="mt-12 bg-slate-50 p-3 rounded shadow whitespace-normal"><code id="joke">{"joke": "Deine Mutter ist ein schöner Witz"}</code></pre>

        <button id="button" class="mt-8 text-lg px-3 py-2 rounded bg-emerald-700 hover:bg-emerald-800 focus:outline-none focus:ring-2 focus:ring-emerald-900 text-white inline-block">
            Neuer Witz, bitte!
        </button>

        <div class="mt-24 flex gap-8 justify-center">
            <a class="text-slate-500 hover:text-slate-700 underline" href="https://github.com/timkley/deine-mutter">GitHub</a>
        </div>

        <div class="mt-8 text-slate-500 text-sm">Inspiriert von <a class="hover:underline" href="https://yomomma.info/">yomomma.info</a></div>
    </div>

    <script>
        const button = document.getElementById('button')

        button.addEventListener('click', () => {
            fetch('/api')
                .then(response => response.json())
                .then(data => {
                    document.getElementById('joke').innerHTML = JSON.stringify(data)
                })
        })
    </script>

</x-layouts.app>
