## Adding Amazon to the test network

You can use the `addAmazon.sh` script to add another organization to the Fabric test network. The `addAmazon.sh` script generates the Amazon crypto material, creates an Amazon organization definition, and adds Amazon to a channel on the test network.

You first need to run `./network.sh up createChannel` in the `test-network` directory before you can run the `addAmazon.sh` script.

```
./network.sh up createChannel
cd addAmazon
./addAmazon.sh up
```

If you used `network.sh` to create a channel other than the default `mychannel`, you need pass that name to the `addamazon.sh` script.
```
./network.sh up createChannel -c channel1
cd addAmazon
./addAmazon.sh up -c channel1
```

You can also re-run the `addAmazon.sh` script to add Amazon to additional channels.
```
cd ..
./network.sh createChannel -c channel2
cd addAmazon
./addAmazon.sh up -c channel2
```

For more information, use `./addAmazon.sh -h` to see the `addAmazon.sh` help text.
