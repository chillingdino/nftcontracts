/*
const TurtleTanksPass2 = artifacts.require("TurtleTanksPass2");
const Web3 = require('web3'); 

module.exports = async function(deployer, network, accounts) {
    console.log("address of deployer: " + String(accounts[0]));
    //let balance = await web3.eth.getBalance(accounts[0]);
    //console.log("address of deployer: " + String(balance));
    //console.log((await web3.eth.getAccounts()));

    const send = web3.utils.toWei('50000000000000', 'wei');

    await deployer.deploy(TurtleTanksPass2);
    const turtle = await TurtleTanksPass2.deployed();
    //await turtle.reserve(accounts[0],10);
    await turtle.flipSaleState();
    
     
    console.log((await turtle.totalSupply()).toString());
    await turtle.getReserve(10,  {value: send*10, from: accounts[0]});
    console.log((await turtle.totalSupply()).toString());

    await turtle.claim(6);

    console.log((await turtle.totalSupply()).toString());
    console.log((await turtle.turtleBoughtBy(accounts[0])).toString());
    console.log((await turtle.getClaimable()).toString());
    //await turtle.getReserve(11,  {value: send*11, from: accounts[0]});
     
    await turtle.addInfluencer(accounts[1], 10, {from: accounts[0]})
    await turtle.reserveTeam(accounts[1], 9, {from: accounts[1]})
    console.log((await turtle.totalSupply()).toString());
    await turtle.reserveTeam(accounts[1], 9, {from: accounts[1]})
    console.log((await turtle.totalSupply()).toString());
};
*/
const TurtleTanks = artifacts.require("TurtleTanks");
const Web3 = require('web3'); 

module.exports = async function(deployer, network, accounts) {
    console.log("address of deployer: " + String(accounts[0]));
    //let balance = await web3.eth.getBalance(accounts[0]);
    //console.log("address of deployer: " + String(balance));
    //console.log((await web3.eth.getAccounts()));

    const send = web3.utils.toWei('50000000000000', 'wei');

    await deployer.deploy(TurtleTanks);
    const turtle = await TurtleTanks.deployed();
    //await turtle.reserve(accounts[0],10);
    await turtle.flipSaleState();
    
    await turtle.reserveTeam(accounts[0], 8)
    await turtle.mint(1)
     

    console.log((await turtle.saleIsActive()).toString());

    
    //await turtle.getReserve(11,  {value: send*11, from: accounts[0]});
    
    await turtle.addInfluencer(accounts[1], 10, {from: accounts[0]})
    await turtle.reserveTeam(accounts[1], 9, {from: accounts[1]})
    console.log((await turtle.totalSupply()).toString());
    await turtle.reserveTeam(accounts[1], 1, {from: accounts[1]})
    console.log((await turtle.totalSupply()).toString());
    
};