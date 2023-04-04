import adapter from '@sveltejs/adapter-cloudflare';

/** @type {import('@sveltejs/kit').Config} */
const config = {
	kit: {
		adapter: adapter({
			routes: {
				include: ['/*'],
				exclude: [
					'/_app/*',
					'/.DS_Store',
					'/css/*',
					'/generate/*',
					'/images/*',
					'/interfaces/*'
				]
			}
		})
	}
};

export default config;
