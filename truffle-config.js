/* eslint-disable @typescript-eslint/camelcase */
require('ts-node/register')

module.exports = {
	test_file_extension_regexp: /.*\.ts$/,
	networks: {
		development: {
			host: "127.0.0.1",
			port: 9545,
			network_id: "*",
			websockets: true
		}
	},
	compilers: {
		solc: {
			version: '^0.5.9'
		}
	}
}
