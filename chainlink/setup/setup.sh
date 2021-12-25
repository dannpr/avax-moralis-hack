echo "ROOT=/chainlink
LOG_LEVEL=debug
ETH_CHAIN_ID=43113
MIN_OUTGOING_CONFIRMATIONS=2
LINK_CONTRACT_ADDRESS=0x0b9d5D9136855f6FEc3c0993feE6E9CE8a297846
CHAINLINK_TLS_PORT=0
SECURE_COOKIES=false
GAS_UPDATER_ENABLED=true
ALLOW_ORIGINS=*
ETH_URL=$MORALIS_AVALANCHE_SPEEDY_NODE_ENDPOINT_WS
DATABASE_URL=postgresql://chainlink:chainlink@pgchainlink:5432/chainlink?sslmode=disable" > chainlink/.env
echo "test@test.com
U2EWSifVqfDBiAynNJW86LAQzAt8ENUK" > ~/.chainlink-avalanche/.api
echo "U2EWSifVqfDBiAynNJW86LAQzAt8ENUK" > ~/.chainlink-avalanche/.password
docker network create chainlink
docker run --name pgchainlink --network chainlink -e POSTGRES_PASSWORD=chainlink -e POSTGRES_USER=chainlink -d -p 5432:5432 -v /root/postgres-data/:/var/lib/postgresql/data postgres
docker run -d --name chainlink-avalanche-node --network chainlink -p 6688:6688 -v ~/.chainlink-avalanche:/chainlink -it --env-file=chainlink/.env smartcontract/chainlink:0.10.3 local n -p /chainlink/.password -a /chainlink/.api
docker build ./chainlink/external-adaptors/twitter-verifier/ -t twitter-verifier
docker run --name twitter-verifier --network chainlink -p 8081:8081 -it twitter-verifier:latest