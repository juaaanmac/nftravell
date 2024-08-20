## NFT Travell

This is a project to demonstrate the use of [Chainlink Data Feeds](https://docs.chain.link/data-feeds).

## Usage

### Clone repository

```shell
$ cd your-path
$ git clone https://github.com/juaaanmac/nftravell.git
$ cd nftravell
```

### Install dependencies

```shell
$ make install
```

### Build

```shell
$ make build
```

### Test

```shell
$ make test
```

### Deploy

1) Create a copy of .env.example file and rename it as .env. 
2) Set the values. Contract addresses will be completed soon.
3) Deploy PriceFeed contract if you haven't done so before:

```shell
$ make deploy-price-feed
```

4) Set PRICE_FEED_ADDR in .env file.

5) Deploy NFTravell contract:

```shell
$ make deploy-nft
```

* Change the values in NFTravell deploy script if you want. 

### Usage

1) Get the price of the current coin using the `PriceFeed` deployed contract. Call `getChainlinkDataFeedLatestAnswer` to get the value in weis.

```shell
$ make price
```

2) Multiply the value obtained by the value of the token defined in the `NFTravell` contract (the value used during deployment is 2, see the script), and convert it to ethers.
3) Call mint function in `NFTravell`, passing the calculated value as `value`.

```shell
$ make mint AMOUNT=value
```

4) You will get a nft to use as a pass in you vacations 😁.

### Reactive Network Features

To test the benefits of Reactive network you must deploy two more contracts:

1) RewardsToken: an ERC20 token contract to give rewards to user who acquires NFTravells.

```shell
$ make deploy-rewards
```
* Change the values in NFTravell deploy script if you want. 

2) RewardsManager: reactive smart contract to be deployed on RVMs and on Reactive Network used to react to spcecified events:

```shell
$ make deploy-react 
```

If everything went well, when you get new NFTravell tokens, you should also have the corresponding reward tokens in your wallet.

