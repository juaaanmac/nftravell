-include .env

clean :; forge clean

fmt :; forge fmt

install :; forge install foundry-rs/forge-std --no-commit && forge install openzeppelin/openzeppelin-contracts@v5.0.2 --no-commit && forge install openzeppelin/openzeppelin-contracts@v5.0.2 --no-commit && forge install smartcontractkit/foundry-chainlink-toolkit --no-commit

update:; forge update

build:; forge build

test :; forge test 

deploy :; forge script --chain sepolia script/Deploy.s.sol:DeployScript --rpc-url ${RPC_URL} --broadcast --verify -vvvv