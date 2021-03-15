# Useful commands

Delete logs older than 1 day
```bash
find /opt/cardano/cnode/logs/archive/ -mtime +1 -name "*.json" -print -exec /bin/rm {} \;
```

# Epoch Nonce
```
cardano-cli query protocol-state --mainnet --mary-era | jq -r .csTickn.ticknStateEpochNonce.contents
```

# Block multiple connections to the node from the same IP Address (possible attacks)
Edit the ufw before.rules file:
```
sudo nano /etc/ufw/before.rules
```
Add:
```
...

# Block too many connections to node from the same IP
-A ufw-before-input -p tcp -m tcp -m connlimit --connlimit-above 3 --connlimit-mask 32 --connlimit-saddr  --dport <NODE_PORT> -j DROP

...
```
Reload the ufw to apply:
```
sudo ufw reload
```

# Setting up cardano-graphQL

After setting-up db-sync/-extended:

1) Install Nix
```bash
curl -L https://nixos.org/nix/install | sh
```

2) Build cardano-graphQL server and Hasura
```bash
git clone https://github.com/input-output-hk/cardano-graphql
cd cardano-graphql
```

graphQL
```bash
nix-build -A cardano-graphql -o nix-build/cardano-graphql
```

Hasura
```bash
nix-build -A graphql-engine -o nix-build/graphql-engine # this one takes many hours

nix-build -A hasura-cli -o nix-build/hasura-cli
```

Now in separate terminals (tmux), run (from same directory as above - cardano-graphql):

1)
```bash
./nix-build/graphql-engine/bin/graphql-engine \
  --host "localhost" \
  -u "someUsername" \
  --password "somePassword" \
  -d "cexplorer" \
  --port 5432 \
  serve \
  --server-port 8090 \
  --enable-telemetry=false
```

2)
```bash
HASURA_URI=http://localhost:8090 \
GENESIS_FILE_BYRON=${PWD}/config/network/mainnet/genesis/byron.json \
GENESIS_FILE_SHELLEY=${PWD}/config/network/mainnet/genesis/shelley.json \
POSTGRES_DB=cexplorer \
POSTGRES_HOST=localhost \
POSTGRES_PASSWORD=postgres \
POSTGRES_PORT=5432 \
POSTGRES_USER=node \
HASURA_CLI_PATH=./nix-build/hasura-cli/bin/hasura \
./nix-build/cardano-graphql/bin/cardano-graphql
```
