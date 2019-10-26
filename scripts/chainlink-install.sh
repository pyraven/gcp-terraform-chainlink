docker pull ethereum/client-go:latest
mkdir ~/.geth
docker run -d --name eth -p 8546:8546 -v ~/.geth:/geth -it ethereum/client-go --syncmode fast --ws --ipcdisable --wsaddr 0.0.0.0 --wsorigins="*" --datadir /geth
mkdir ~/.chainlink
echo "ROOT=/chainlink
LOG_LEVEL=debug
ETH_CHAIN_ID=1
ALLOW_ORIGINS=*" > ~/.chainlink/.env
ETH_CONTAINER_IP=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' $(docker ps -f name=eth -q))
echo "ETH_URL=ws://$ETH_CONTAINER_IP:8546" >> ~/.chainlink/.env
mkdir ~/.chainlink/tls
printf "[dn]\nCN=localhost\n[req]\ndistinguished_name = dn\n[EXT]\nsubjectAltName=DNS:localhost\nkeyUsage=digitalSignature\nextendedKeyUsage=serverAuth" > tmp-ext-file
openssl req -x509 -out  ~/.chainlink/tls/server.crt  -keyout ~/.chainlink/tls/server.key -newkey rsa:2048 -nodes -sha256 -days 365 -subj '/CN=localhost' -extensions EXT -config tmp-ext-file
echo "TLS_CERT_PATH=/chainlink/tls/server.crt
TLS_KEY_PATH=/chainlink/tls/server.key" >> ~/.chainlink/.env
# enter api email
echo "" > ~/.chainlink/.api
# enter api password
echo "" >> ~/.chainlink/.api
# enter wallet password
echo "" > ~/.chainlink/.password
cd ~/.chainlink
docker run -d -p 6689:6689 -v ~/.chainlink:/chainlink -it --env-file=.env smartcontract/chainlink local n -p /chainlink/.password -a /chainlink/.api