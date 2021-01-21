/**
* Deploy Libraries
*/

function sleep_s(secs) {
  secs = (+new Date) + secs * 1000;
  while ((+new Date) < secs);
}
// truffle-flattener ./contracts/Berry.sol > ./flat_files/Berry_flat.sol
// truffle exec scripts/01_DeployBerry.js --network rinkeby

var BerryTransfer = artifacts.require("./libraries/BerryTransfer.sol");
var BerryDispute = artifacts.require("./libraries/BerryDispute.sol");
var BerryStake = artifacts.require("./libraries/BerryStake.sol");
var BerryLibrary = artifacts.require("./libraries/BerryLibrary.sol");
var BerryGettersLibrary = artifacts.require("./libraries/BerryGettersLibrary.sol");
var Berry = artifacts.require("./Berry.sol");
var BerryMaster = artifacts.require("./BerryMaster.sol");



module.exports =async function(callback) {
	let transfer;
	let dispute;
	let stake;
	let getters;
	let berryLib;
    let berry;
    let berryMaster;
    

  // deploy transfer
  tranfer = await BerryTransfer.new();
  console.log('BerryTransfer address:', transfer.address);
  console.log('Use BerryTransfer address(without the 0x) to link library in BerryDispute json file');
  sleep_s(10);

  // // deploy dispute
  // dispute = await BerryDispute.new();
  // console.log('BerryDispute address:', dispute.address);
  // console.log('Use BerryTransfer and BerryDispute addresses to link library in BerryStake json file');
  // sleep_s(10);

  // // deploy stake
  // stake = await BerryStake.new();
  // console.log('BerryStake address:', stake.address);
  // sleep_s(10);

  // // deploy getters lib
  // getters = await BerryGettersLibrary.new();
  // console.log('BerryGettersLibrary address:', getters.address);
  // console.log('Use BerryTransfer, BerryDispute and BerryStake addresses to link library in BerryLibrary json file');
  // sleep_s(10);

  // // deploy lib

  // berryLib = await BerryLibrary.new();
  // console.log('BerryLib address:', berryLib.address);
  // console.log('Use BerryTransfer, BerryDispute,BerryStake, BerryLibrary addresses to link library in Berry json file');
  // sleep_s(10);

  // // deploy berry
  // berry = await Berry.new();
  // console.log('Berry address:', berry.address);
  // console.log('Use BerryTransfer, BerryGettersLibrary,BerryStake addresses to link library in BerryMaster json file');
  // sleep_s(10);

  // // deploy berry master
  // berryMaster = await BerryMaster(Berry.address);
  // console.log('BerryMaster address:', berryMaster.address);

}
