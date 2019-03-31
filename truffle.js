module.exports = {
	networks: {
		development: {
			host: 'localhost',
			port: 8545,
			network_id: '*'
		}
	},
	compilers: {
		solc: {
			version: '0.5.2',
			settings: {
				optimizer: {
					enabled: true,
					runs: 4500
				}
			}
		}
	}
}
