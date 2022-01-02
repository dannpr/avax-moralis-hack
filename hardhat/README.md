# Chainlink Hardhat Twitter Validation Consumer

Implementation of the following 3 Chainlink features using the [Hardhat](https://hardhat.org/) development environment:

- Twitter Validation using [Request & Receive data](https://docs.chain.link/docs/request-and-receive-data)

## Requirements

- [NPM](https://www.npmjs.com/) or [YARN](https://yarnpkg.com/)

## Installation

### Setting Environment Variables

Don't commit and push any changes to .env files that may contain sensitive information, such as a private key! If this information reaches a public GitHub repository, someone can use it to check if you have any Mainnet funds in that wallet address, and steal them!

`.env` example:

```
FUJI_RPC_URL='<https-moralis>'
PRIVATE_KEY='abcdef'
```

Then you can install all the dependencies

```bash
git clone https://github.com/smartcontractkit/hardhat-starter-kit/
cd hardhat-starter-kit
```

then

```bash
npm install
```

Or

```bash
yarn
```

## Auto-Funding

This Starter Kit is configured by default to attempt to auto-fund any newly deployed contract that uses Any-API or Chainlink VRF, to save having to manually fund them after each deployment. The amount in LINK to send as part of this process can be modified in the [Starter Kit Config](https://github.com/smartcontractkit/chainlink-hardhat-box/blob/main/helper-hardhat-config.js), and are configurable per network.

| Parameter  | Description                                       | Default Value |
| ---------- | :------------------------------------------------ | :------------ |
| fundAmount | Amount of LINK to transfer when funding contracts | 1 LINK        |

If you wish to deploy the smart contracts without performing the auto-funding, run the following command when doing your deployment:

```bash
npx hardhat deploy --tags main
```

To add fuji network, add to networkConfig in `@appliedblockchain/chainlink-plugins-fund-link/dist/src/config.js`:

```json
{
  "43113": {
    "name": "fuji",
    "linkToken": "0x0b9d5D9136855f6FEc3c0993feE6E9CE8a297846",
    "fundAmount": "10000000000000000"
  }
}
```

## Deploy

Deployment scripts are in the [deploy](https://github.com/smartcontractkit/hardhat-starter-kit/tree/main/deploy) directory. If required, edit the desired environment specific variables or constructor parameters in each script, then run the hardhat deployment plugin as follows. If no network is specified, it will default to the Kovan network.

This will deploy to a local hardhat network

This will deploy to a local hardhat network

```bash
npx hardhat deploy
```

To deploy to testnet:

```bash
npx hardhat deploy --network fuji
```

## Test

Tests are located in the [test](https://github.com/smartcontractkit/hardhat-starter-kit/tree/main/test) directory, and are split between unit tests and integration tests. Unit tests should only be run on local environments, and integration tests should only run on live environments.

To run unit tests:

```bash
yarn test
```

To run integration tests:

```bash
yarn test-integration
```

## Run

The deployment output will give you the contract addresses as they are deployed. You can then use these contract addresses in conjunction with Hardhat tasks to perform operations on each contract

### Request & Receive Data

The TwitterValidationConsumer contract has two tasks, one to request external validation based on a set of parameters, and one to check to see what the result of the validation request is. This contract needs to be funded with link first:

```bash
npx hardhat fund-link --contract insert-contract-address-here --network network
```

Once it's funded, you can request external validation by passing in a number of parameters to the request-data task. The contract parameter is mandatory, the rest are optional

```bash
npx hardhat request-data --contract insert-contract-address-here --network network
```

Once you have successfully made a request for external validation, you can see the result via the read-data task

```bash
npx hardhat read-data --contract insert-contract-address-here --network network
```
