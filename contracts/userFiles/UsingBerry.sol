pragma solidity ^0.5.0;

import "../Berry.sol";
import "../BerryMaster.sol";
import "./UserContract.sol";
/**
* @title UsingBerry
* This contracts creates for easy integration to the Berry Berry System
*/
contract UsingBerry {
    UserContract berryUserContract;
    address payable public owner;

    event OwnershipTransferred(address _previousOwner, address _newOwner);

    /*Constructor*/
    /**
    * @dev This function sents the owner and userContract address
    * @param _userContract is the UserContract.sol address
    */
    constructor(address _userContract) public {
        berryUserContract = UserContract(_userContract);
        owner = msg.sender;
    }

    /*Functions*/
    /**
    * @dev Allows the user to get the latest value for the requestId specified
    * @param _requestId is the requestId to look up the value for
    * @return bool true if it is able to retreive a value, the value, and the value's timestamp
    */
    function getCurrentValue(uint256 _requestId) public view returns (bool ifRetrieve, uint256 value, uint256 _timestampRetrieved) {
        return berryUserContract.getCurrentValue(_requestId);
    }

    //How can we make this one more efficient?
    /**
    * @dev Allows the user to get the first verified value for the requestId after the specified timestamp
    * @param _requestId is the requestId to look up the value for
    * @param _timestamp after which to search for first verified value
    * @return bool true if it is able to retreive a value, the value, and the value's timestamp, the timestamp after
    * which it searched for the first verified value
    */
    function getFirstVerifiedDataAfter(uint256 _requestId, uint256 _timestamp) public view returns (bool, uint256, uint256 _timestampRetrieved) {
        return berryUserContract.getFirstVerifiedDataAfter(_requestId, _timestamp);
    }

    /**
    * @dev Allows the user to get the first value for the requestId after the specified timestamp
    * @param _requestId is the requestId to look up the value for
    * @param _timestamp after which to search for first verified value
    * @return bool true if it is able to retreive a value, the value, and the value's timestamp
    */
    function getAnyDataAfter(uint256 _requestId, uint256 _timestamp)
        public
        view
        returns (bool _ifRetrieve, uint256 _value, uint256 _timestampRetrieved)
    {
        return berryUserContract.getAnyDataAfter(_requestId, _timestamp);
    }

    /**
    * @dev Allows the user to submit a request for data to the oracle using Tributes
    * Allowing this prevents us from increasing spread too high (since if we set the price too hight
    * users will just go to an exchange and get tokens from there)
    * @param _request string API being requested to be mined
    * @param _symbol is the short string symbol for the api request
    * @param _granularity is the number of decimals miners should include on the submitted value
    * @param _tip amount the requester is willing to pay to be get on queue. Miners
    * mine the onDeckQueryHash, or the api with the highest payout pool
    */
    function requestData(string calldata _request, string calldata _symbol, uint256 _granularity, uint256 _tip) external {
        Berry _berry = Berry(berryUserContract.berryStorageAddress());
        if (_tip > 0) {
            require(_berry.transferFrom(msg.sender, address(this), _tip), "Transfer failed");
        }
        _berry.requestData(_request, _symbol, _granularity, _tip);
    }

    /**
    * @dev Allows the user to submit a request for data to the oracle using ETH
    * @param _request string API being requested to be mined
    * @param _symbol is the short string symbol for the api request
    * @param _granularity is the number of decimals miners should include on the submitted value
    * @param _tip amount the requester is willing to pay to be get on queue. Miners
    * mine the onDeckQueryHash, or the api with the highest payout pool
    */
    function requestDataWithEther(string calldata _request, string calldata _symbol, uint256 _granularity, uint256 _tip) external payable {
        berryUserContract.requestDataWithEther.value(msg.value)(_request, _symbol, _granularity, _tip);
    }

    /**
    * @dev Allows the user to tip miners for the specified request using Tributes
    * @param _requestId to tip
    * @param _tip amount
    */
    function addTip(uint256 _requestId, uint256 _tip) public {
        Berry _berry = Berry(berryUserContract.berryStorageAddress());
        require(_berry.transferFrom(msg.sender, address(this), _tip), "Transfer failed");
        _berry.addTip(_requestId, _tip);
    }

    /**
    * @dev Allows user to add tip with Ether by sending the ETH to the userContract and exchanging it for Tributes
    * at the price specified by the userContract owner.
    * @param _requestId to tip
    */
    function addTipWithEther(uint256 _requestId) public payable {
        UserContract(berryUserContract).addTipWithEther.value(msg.value)(_requestId);
    }

    /**
    * @dev allows owner to set the user contract address
    * @param _userContract address
    */
    function setUserContract(address _userContract) public {
        require(msg.sender == owner, "Sender is not owner"); //who should this be?
        berryUserContract = UserContract(_userContract);
    }

    /**
    * @dev allows owner to transfer ownership
    * @param _newOwner address
    */
    function transferOwnership(address payable _newOwner) external {
        require(msg.sender == owner, "Sender is not owner");
        emit OwnershipTransferred(owner, _newOwner);
        owner = _newOwner;
    }
}
