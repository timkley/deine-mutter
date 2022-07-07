# Deine-Mutter-API

Ever needed an easy way to get a random, german your-mom joke programmatically? Well, now you can!

This API features a list of over 30 hand-picked jokes. Every joke had to pass the high quality "at-least-made-me-exhale-a-little-more-than-usual" test.


## Usage

The endpoint is available at `https://deine-mutter.timkley.dev/api` and returns a random joke as JSON:

```json
{
	"joke": "Deine Mutter liebt diese API."
}
```

Now you can finally write that bot that messages your friend every hour to insult his/her mom.

## Contributing

PRs with good jokes are very welcome and I'm happy to merge them. Please keep in mind that every joke has to pass the same high quality standards that went into crafting the initial list of jokes.

Just add your joke to the file `jokes.json` and submit your PR.