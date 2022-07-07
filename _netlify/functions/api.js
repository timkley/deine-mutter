exports.handler = async function (event, context) {
	const jokes = require("../../jokes.json");
	const response = {
		joke: jokes[Math.floor(Math.random() * jokes.length)],
	};

	const json = JSON.stringify(response);

	return {
		statusCode: 200,
		headers: {
			"Access-Control-Allow-Origin": "*",
			"Content-Type": "application/json; charset=utf-8",
		},
		body: json,
	};
};
