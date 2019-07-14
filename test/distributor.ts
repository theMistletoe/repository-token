contract('Distributor', ([deployer]) => {
	const reposioryFactoryContract = artifacts.require('ReposioryFactory')
	const stateContract = artifacts.require('State')
	const distridutorContract = artifacts.require('Distributor')
	const {
		PREFIX,
		waitForEvent
	} = require('./utils')

	const Web3 = require('web3')
	// const youtubeViews = artifacts.require('./YoutubeViews.sol')
	const web3 = new Web3(new Web3.providers.WebsocketProvider('ws://localhost:9545'))
	const gasAmt = 2000000000000000000
	let loggedViews

	// beforeEach(async function() {
	// 	const distributor = await distridutorContract.deployed();
	// 	const { methods, events } = new web3.eth.Contract(
	// 		distributor._jsonInterface,
	// 		distributor._address
	// 	);
	// }



	describe('setMintVolumePerDay', () => {
		it('Change the value of mint volume per day')

		it(
			'Should fail to change the value of mint volume per day when sent from the non-owner account'
		)
	})

	describe('distribute', () => {
		describe('Fetch the number of downloads', () => {
			it('Fetch the specify Repository Contract mapped OSS number of downloads', async () => {


				const contract = await reposioryFactoryContract.new({from: deployer})
				const state = await stateContract.new({from: deployer})
				await state.addOperator(contract.address, {from: deployer})
				await contract.changeStateAddress(state.address, {from: deployer})
				await contract.createRepository('yarn', {from: deployer})
				const pkgAddress = await state.getRepository('yarn', {from: deployer})

				console.log(pkgAddress)
				const distributor = await distridutorContract.deployed();
				// const distributor = await distridutorContract.new({from: deployer})

				// console.log(distributor)
				// console.log(distributor.abi)
				// console.log(distributor.address)
				const { methods, events } = new web3.eth.Contract(
				distributor.abi,
				distributor.address
			);

			// const distributor = await distridutorContract.new({from: deployer})
			// const distributor = await distridutorContract.deployed()
			// const { methods, events } = new web3.eth.Contract(
			// 	distributor._jsonInterface,
			// 	distributor._address
			// )
			// console.log(distributor._jsonInterface)
			// console.log(distributor._address
			// const result = distridutorContract.distribute(pkgAddress, {from: deployer})
			// console.log(result)

			// console.log(methods)

			const expErr = 'revert'
			try {
				await methods
				// .distribute(pkgAddress)
				.update()
				.send({
					from: deployer,
					// gasPrice: "5500000",
					gas: 3e6,
					value: 100
				})
				// assert.fail('Update transaction should not have succeeded!')
				assert.strictEqual(0,0,'xxxx')
			} catch (e) {
				assert.isTrue(
					e.message.startsWith(`${PREFIX}${expErr}`),
					`Expected ${expErr} but got ${e.message} instead!`
				)
			}



			const aaaa = await methods.mintVolumePerDay().call({from: deployer})
			console.log('sdfhisdbiajdbiajbdcasbdiq:',aaaa)

			const bbbb = await methods.xxxxx().call({from: deployer})
			console.log('res:',bbbb)
			// const results = await contract
			// 	.createRepository('pkg', {from: deployer})
			// 	.catch((err: Error) => err)
			// expect(results).to.instanceOf(Error)
			// expect((results as any).reason).to.be.equal(
			// 	'Repository is already created'
			// )
		})

		it('Callback should have logged a new YouTube views event', async () => {
			const distributor = await distridutorContract.deployed();
			// const distributor = await distridutorContract.new({from: deployer})

			// console.log(distributor)
			// console.log(distributor.abi)
			// console.log(distributor.address)
			const { methods, events } = new web3.eth.Contract(
			distributor.abi,
			distributor.address
		);
		const {
			returnValues: {
				views
			}
		} = await waitForEvent(events.LogYoutubeViewCount)
		loggedViews = views
		assert.strictEqual(
			parseInt(views),
			316223,
			'A view count should have been retrieved from Oraclize call!'
		)
		const bbbb = await methods.xxxxx().call({from: deployer})
		console.log('res:',bbbb)
	})

	it(
		'Should fail to fetch the number of downloads when not exists Repository Contract'
	)
})

describe('Target period', () => {
	it('Target period is from the last run to yesterday')

	it('Should fail to re-run if within one day from the last run date')
})

describe('Increment dividends', () => {
	it(
		`
		'totalDownloadsPerDay' is 100,
		the target period is 1 day,
		the previous download count is x,
		the current download count is y,
		and 'mintVolumePerDay' is 5;
		the result is (y ÷ (100 - x + y) * 5)`
	)

	it(
		"When after increment, change the value of 'totalDownloadsPerDay' is (100 - x + y)"
	)
})

describe('Timestamp', () => {
	it('Change the value of seconds per block')

	it(
		'Should fail to change the value of seconds per block when sent from the non-owner account'
	)
})

it('The sent ETH will be returned to the sender')
})

describe('withdraw', () => {
	describe('Withdraw is mint', () => {
		it('Withdraw mints an ERC20 token specified in the State Contract')
	})

	describe('Withdrawable amount', () => {
		it(
			'The withdrawable amount each holder is the number multiplied the balance of the price per Repository Contract and the Repository Contract of the sender'
		)

		it(
			'The withdrawal amount is always the full amount of the withdrawable amount'
		)

		it('When the withdrawable amount is 0, the withdrawal amount is 0')

		it("When 'increment' is executed, the withdrawable amount increases")
	})

	describe('Alice has sent 800 out of 1000 tokens to Bob. Bob has increased from 200 tokens to 1000 tokens. Price is 100', () => {
		describe('Before increment', () => {
			it("Alice's withdrawable amount is (1000 * 100)")

			it("Bob's withdrawable amount is (200 * 100)")
		})

		describe('After increment; New price is 120', () => {
			it("Alice's withdrawable amount is (1000 * 100 + 200 * 120)")

			it("Bob's withdrawable amount is (200 * 100 + 1000 * 120)")
		})

		it(
			"Should fail to execute 'beforeBalanceChange' when sent from the not Repository Contract address"
		)
	})
})

describe('kill', () => {
	it('Destruct this contract')

	it(
		'Should fail to destruct this contract when sent from the non-owner account'
	)
})
})
