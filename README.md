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
2) Set the values.
3) Run:

```shell
$ make deploy
```

### Usage

1) Get the price of the current coin using the `PriceFeed` deployed contract. Call `getChainlinkDataFeedLatestAnswer` to get the value in weis.
2) Multiply the value obtained by the value of the token defined in the `NFTravell` contract, and convert it to ethers.
3) Call mint function in `NFTravell`, passing the calculated value as `value`.
4) You will get a nft to use as a pass in you vacations 😁.