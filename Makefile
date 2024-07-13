-include .env

# deps
update:; forge update
build  :; forge build
size  :; forge build --sizes

# storage inspection
inspect :; forge inspect ${contract} storage-layout --pretty

FORK_URL := ${ETH_RPC_URL} 

# local tests without fork
test  :; forge test -vv --fork-url ${FORK_URL}
trace  :; forge test -vvv --fork-url ${FORK_URL}
gas  :; forge test --fork-url ${FORK_URL} --gas-report
test-contract  :; forge test -vv --match-contract $(contract) --fork-url ${FORK_URL}
test-contract-gas  :; forge test --gas-report --match-contract ${contract} --fork-url ${FORK_URL}
trace-contract  :; forge test -vvv --match-contract $(contract) --fork-url ${FORK_URL}
test-test  :; forge test -vv --match-test $(test) --fork-url ${FORK_URL}
trace-test  :; forge test -vvv --match-test $(test) --fork-url ${FORK_URL}
snapshot :; forge snapshot -vv --fork-url ${FORK_URL}
snapshot-diff :; forge snapshot --diff -vv --fork-url ${FORK_URL}
deploy	:; forge script src/script/deploy.s.sol:deployScript --fork-url ${SEPOLIA_RPC_URL} --broadcast --etherscan-api-key ${ETHERSCAN_API_KEY} --verifier-url ${ETHERSCAN_URL} --verify
deployToken	:; forge script src/script/mockCoin.s.sol:deployToken --fork-url ${SEPOLIA_RPC_URL} --broadcast --etherscan-api-key ${ETHERSCAN_API_KEY} --verifier-url ${ETHERSCAN_URL} --verify
runGame	:; forge script src/script/liveTest.s.sol:runGame --fork-url ${SEPOLIA_RPC_URL} --broadcast

deployAll :;
	forge script src/script/deploy.s.sol:deployScript --fork-url ${ARBI_RPC_URL} --broadcast --etherscan-api-key ${ETHERSCAN_API_KEY} --verifier-url ${ARBISCAN_URL} --verify
	forge script src/script/deploy.s.sol:deployScript --fork-url ${BASE_RPC_URL} --broadcast --etherscan-api-key ${ETHERSCAN_API_KEY} --verifier-url ${BASESCAN_URL} --verify
	forge script src/script/deploy.s.sol:deployScript --fork-url ${POLYGON_RPC_URL} --broadcast --etherscan-api-key ${ETHERSCAN_API_KEY} --verifier-url ${POLYGONSCAN_URL} --verify
	forge script src/script/deploy.s.sol:deployScript --fork-url ${SCROLL_RPC_URL} --broadcast --etherscan-api-key ${ETHERSCAN_API_KEY} --verifier-url ${SCROLLSCAN_URL} --verify

clean  :; forge clean
