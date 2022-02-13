# Polygon Node DAppNode package

[![DAppNodeStore Available](https://img.shields.io/badge/DAppNodeStore-Available-brightgreen.svg)](http://my.dappnode/#/installer/polygon.public.dappnode.eth)

[![Polygon github](https://img.shields.io/badge/GithubRepo-blue.svg)](https://github.com/maticnetwork/launch) (Official)

Polygon (aka Matic) is a PoS EVM network. This package deploys a Polygon Full Node (Pruned) that will, by default, download the latest snapshot (at the time of publishing) the package and then sync to the tip of the chain.

The primary container in this package is `bor` which provides the RPC endpoint on `8545/tcp` - you can map this to a host port if you wish to access it without the VPN or expose it via HTTPS.

There is also the PoS container `heimdalld` which has an API at `26657/tcp` - you generally don't need to expose this at all, but if you want to query the status of heimdall remotely without the VPN you can map this port as well. e.g. `http://heimdalld:26657/status`

By default this package maps ports 40303 (tcp & udp) and 26656/tcp to the DAppNode Host for peering of bor and heimdall respectively.

## License

This project is licensed under the GNU General Public License v3.0 - see the [LICENSE](LICENSE) file for details
