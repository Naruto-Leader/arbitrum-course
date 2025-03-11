source .env

forge create \
    --constructor-args "[Pitolomeu, Copernico]" \
    --rpc-url http://127.0.0.1:8449 \
    --private-key $PRVTK \
    src/Election.sol:Election

