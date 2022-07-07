const jokes = [
	'Deine Mutter arbeitet bei Nordsee als Geruch.',
	'Deine Mutter krümelt beim Trinken.',
	'Deine Mutter läuft bei Super Mario nach links.',
	'Deine Mutter isst Kürbisjoghurt mit ganzen Früchten.'
]

exports.handler = async function (event, context) {
	const response = {
		'joke': jokes[Math.floor(Math.random() * jokes.length)]
	}
	
	const json = JSON.stringify(response)
	
	return {
		statusCode: 200,
		body: json,
	}
}