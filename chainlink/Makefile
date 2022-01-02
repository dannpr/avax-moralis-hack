all: link twt

config:
	source config.sh

link:
	docker network create chainlink
	docker run --name pgchainlink --network chainlink -e POSTGRES_PASSWORD=chainlink -e POSTGRES_USER=chainlink -d -p 5432:5432 -v /root/postgres-data/:/var/lib/postgresql/data postgres
	docker run -d --name chainlink-avalanche-node --network chainlink -p 6688:6688 -v ~/.chainlink-avalanche:/chainlink -it --env-file=.env smartcontract/chainlink:0.10.3 local n -p /chainlink/.password -a /chainlink/.api

twt:
	docker build ./external-adapters/twitter-verifier/ -t twitter-verifier
	docker run --name twitter-verifier --network chainlink -p 8081:8081 -it twitter-verifier:latest
