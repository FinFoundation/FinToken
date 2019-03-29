var Token = artifacts.require("./FinToken.sol");
var BigNumber = require("bignumber.js");

var tokenContract;

module.exports = function(deployer) {

    var admin = "";
    var totalTokenAmount = new BigNumber(10).pow(18).times(1000000000);

    return Token.new(admin, totalTokenAmount.toFixed()).then(function(result) {
        tokenContract = result;
    });

};
