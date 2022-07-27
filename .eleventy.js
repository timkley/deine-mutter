module.exports = (eleventyConfig) => {
	eleventyConfig.addWatchTarget('src/css/bundle.css')
	eleventyConfig.addWatchTarget('tailwind.config.js')
	eleventyConfig.addWatchTarget('jokes.json')
	eleventyConfig.addPassthroughCopy({ img: 'img' })

	eleventyConfig.addShortcode('version', () => {
		return String(Date.now())
	})

	return {}
}
