**         -f, --fabric-version: FabricVersion (default: '2.5.2')
**         -c, --ca-version: Fabric CA Version (default: '1.5.6')

```bash

* Run this script to start the network then install, approve and commit the chaincode.

> ./start.sh


** Export this in order to run peer commands:

export PATH=$PATH:$(realpath ../bin)
export FABRIC_CFG_PATH=$(realpath ../config)

```