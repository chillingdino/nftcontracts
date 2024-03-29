/**
 * Use this file to configure your truffle project. It's seeded with some
 * common settings for different networks and features like migrations,
 * compilation and testing. Uncomment the ones you need or modify
 * them to suit your project as necessary.
 *
 * More information about configuration can be found at:
 *
 * truffleframework.com/docs/advanced/configuration
 *
 * To deploy via Infura you'll need a wallet provider (like truffle-hdwallet-provider)
 * to sign your transactions before they're sent to a remote public node. Infura accounts
 * are available for free at: infura.io/register.
 *
 * You'll also need a mnemonic - the twelve word phrase the wallet uses to generate
 * public/private key pairs. If you're publishing your code to GitHub make sure you load this
 * phrase from a file you've .gitignored so it doesn't accidentally become public.
 *
 */

// const HDWallet = require('truffle-hdwallet-provider');
// const infuraKey = "fj4jll3k.....";
//
// const fs = require('fs');
// const mnemonic = fs.readFileSync(".secret").toString().trim();
const HDWalletProvider = require('@truffle/hdwallet-provider');

const mnemonic = ""; //new deployment account 
module.exports = {
  /**
   * Networks define how you connect to your ethereum client and let you set the
   * defaults web3 uses to send transactions. If you don't specify one truffle
   * will spin up a development blockchain for you on port 9545 when you
   * run `develop` or `test`. You can ask a truffle command to use a specific
   * network from the command line, e.g
   *
   * $ truffle test --network <network-name>
   */

  networks: {
    // Useful for testing. The `development` name is special - truffle uses it by default
    // if it's defined here and no other network is specified at the command line.
    // You should run a client (like ganache-cli, geth or parity) in a separate terminal
    // tab if you use this network and you must also set the `host`, `port` and `network_id`
    // options below to some value.
    //
    // development: {
    //  host: "127.0.0.1",     // Localhost (default: none)
    //  port: 8545,            // Standard Ethereum port (default: none)
    //  network_id: "*",       // Any network (default: none)
    // },
    
    development: {
      host: "127.0.0.1",     // Localhost (default: none)
      port: 8545,            // Standard Ethereum port (default: none)
      network_id: "*",       // Any network (default: none)
      gas: 90090000000, 
     },

    mumbai: {
      networkCheckTimeout: 10000,
    provider: () => new HDWalletProvider(mnemonic, ""),
    network_id: 80001,       // Ropsten's id
    //chainId: 80001,
    //gas: 1000000,        // Ropsten has a lower block limit than mainnet
    //confirmations: 1,    // # of confs to wait between deployments. (default: 0)
    //timeoutBlocks: 200,  // # of blocks before a deployment times out  (minimum/default: 50)
    //skipDryRun: false     // Skip dry run before migrations? (default: false for public nets )
    gasPrice: 10000000000,
    
    },
    matic: {
      networkCheckTimeout: 1000000,
      timeoutBlocks: 2000,
      provider: () => new HDWalletProvider(mnemonic, ""),
      network_id: 137,       // Ropsten's id
      //chainId: 80001,
      //gas: 1000000,        // Ropsten has a lower block limit than mainnet
      confirmations: 1,    // # of confs to wait between deployments. (default: 0)
      //timeoutBlocks: 200,  // # of blocks before a deployment times out  (minimum/default: 50)
      //skipDryRun: false     // Skip dry run before migrations? (default: false for public nets )
      gas: 6700000, 
      gasPrice:50000000000,
      skipDryRun: true,
    },
    mainnet: {
      networkCheckTimeout: 10000000,
      timeoutBlocks: 200,
      provider: () => new HDWalletProvider(mnemonic, ""),
      network_id: 1,      // Ropsten's id
      //chainId: 80001,
      //gas: 1000000,        // Ropsten has a lower block limit than mainnet
      confirmations: 1,    // # of confs to wait between deployments. (default: 0)
      //timeoutBlocks: 200,  // # of blocks before a deployment times out  (minimum/default: 50)
      //skipDryRun: false     // Skip dry run before migrations? (default: false for public nets )
      gasPrice:130000000000,
      gas: 2406748,
      skipDryRun: true,
    },

    rinkeby: {
      provider: () => new HDWalletProvider(mnemonic, ""),
      network_id: 4,       // Ropsten's id
      gas: 5500000,        // Ropsten has a lower block limit than mainnet
      confirmations: 1,    // # of confs to wait between deployments. (default: 0)
      timeoutBlocks: 200,  // # of blocks before a deployment times out  (minimum/default: 50)
      skipDryRun: true     // Skip dry run before migrations? (default: false for public nets )
    },
    

  },

  // Set default mocha options here, use special reporters etc.
  mocha: {
    // timeout: 100000
  },

  // Configure your compilers
  compilers: {
    solc: {
      version: "0.8.0",
      settings: {
        optimizer: {
          enabled: true,
          runs: 200   // Optimize for how many times you intend to run the code
        },
      },
    },
  },
}

