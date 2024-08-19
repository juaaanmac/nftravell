-include .env

clean :; forge clean

fmt :; forge fmt

install :; forge install foundry-rs/forge-std --no-commit && forge install openzeppelin/openzeppelin-contracts@v5.0.2 --no-commit && forge install openzeppelin/openzeppelin-contracts@v5.0.2 --no-commit && forge install smartcontractkit/foundry-chainlink-toolkit --no-commit

update:; forge update

build:; forge build

test :; forge test 

deploy-nft :; forge script script/Deploy.NFT.s.sol:DeployNFTScript --rpc-url sepolia --broadcast --verify -vvvv

deploy-rewards :; forge script script/Deploy.Rewards.s.sol:DeployRewardsScript --rpc-url sepolia --broadcast --verify -vvvv

deploy-react :; forge create --rpc-url ${REACTIVE_RPC_URL} --private-key ${REACTIVE_PRIVATE_KEY} src//RewardsManager.sol:RewardsManager --constructor-args ${REACTIVE_SYSTEM_CONTRACT_ADDR} ${NFT_ADDR} 0x96234cb3d6c373a1aaa06497a540bc166d4b0359243a088eaf95e21d7253d0be ${REWARDS_ADDR}

mint :; cast send ${NFT_ADDR} --private-key ${ADMIN_PRIVATE_KEY} --rpc-url ${SEPOLIA_RPC_URL} "mint()" --value ${AMOUNT}