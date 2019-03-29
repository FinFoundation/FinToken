
const HDWalletProvider = require('truffle-hdwallet-provider');
const infuraKey = "";
const mnemonic = "";
const gas = 6000000;
const gasPrice = 20000000000; // 20

module.exports = {
  networks: {
    development: {
      host: "localhost",
      port: 8545,
      network_id: "*", // Match any network id,
      gas: 3000000
    },
    ropsten: {
      provider: () => new HDWalletProvider(mnemonic, "https://ropsten.infura.io/v3/" + infuraKey),
      network_id: 3,       // Ropsten's id
      gas: gas,
      gasPrice: gasPrice
      // gas: 5500000,        // Ropsten has a lower block limit than mainnet
      // confirmations: 2,    // # of confs to wait between deployments. (default: 0)
      // timeoutBlocks: 200,  // # of blocks before a deployment times out  (minimum/default: 50)
      // skipDryRun: true     // Skip dry run before migrations? (default: false for public nets )
    },
    live: {
      provider: () => new HDWalletProvider(mnemonic, "https://mainnet.infura.io/v3/" + infuraKey),
      network_id: 1,
      gas: gas,
      gasPrice: gasPrice
    }
  },
  compilers: {
    solc: {
      version: "0.4.18"  // ex:  "0.4.20". (Default: Truffle's installed solc)
    }
  }
};
