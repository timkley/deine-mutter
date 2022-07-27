module.exports = function () {
	jokes = require('../jokes.json')
	return {
		environment: process.env.ELEVENTY_ENV || 'development',
		jokesCount: jokes.length,
	}
}
