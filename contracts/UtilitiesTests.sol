pragma solidity ^0.5.0;

import "./libraries/Utilities.sol";
import "./libraries/BerryGettersLibrary.sol";
import "./BerryMaster.sol";

/**
* @title Utilities Tests
* @dev These are the getter function for the two assembly code functions in the
* Utilities library
*/
contract UtilitiesTests {
    address internal owner;
    BerryMaster internal berryMaster;
    address public berryMasterAddress;

    /**
    * @dev The constructor sets the owner
    */
    constructor() public {
        owner = msg.sender;
    }

    /**
    *@dev Set BerryMaster address
    *@param _BerryMasterAddress is the Berry Master address
    */
    function setBerryMaster(address payable _BerryMasterAddress) public {
        require(msg.sender == owner, "Sender is not owner");
        berryMasterAddress = _BerryMasterAddress;
        berryMaster = BerryMaster(_BerryMasterAddress);
    }

    function testgetMax() public view returns (uint256 _max, uint256 _index) {
        uint256[51] memory requests = berryMaster.getRequestQ();
        (_max, _index) = Utilities.getMax(requests);
    }

    function testgetMin() public view returns (uint256 _min, uint256 _index) {
        uint256[51] memory requests = berryMaster.getRequestQ();
        (_min, _index) = Utilities.getMin(requests);
    }

}
