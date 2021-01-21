## Documentation <a name="Documentation"> </a>  
The documentation is broken down into four parts: steps for setting up, quick instructions for setting up and test using Truffle, users' and miners' functions, contracts' descriptions, and scripts' (javascript) descriptions.


### Operator Setup <a name="operator-setup"> </a>  
The setup documentation is noted for acting as the operator. Specific contract details are laid out for ease of use regardless of dev environment. 

**Step 1: Operator - Deploy Berry.sol**  
The first deployed Berry.sol.

```solidity
Berry();
BerryMaster(Berry.address); //where the berry.address is the address of the deployed Berry() above.
```
Congrats!!

<!---

  $ npm install berry

On contracts use “is usingBerry” to access these functions: requestData, retreiveData,  getLastQuery.
-->

### Instructions for quick start with Truffle Deployment <a name="Quick-Deployment"> </a> 
Follow the steps below to launch the Oracle contracts using Truffle. 

1. Open two terminals.

2. On one terminal run:
    Clone the repo, cd into it, and then run:

    $ npm install

    $ truffle compile

    $ truffle migrate

    $ truffle exec scripts/01_DeployBerry.js

#### Testing through Truffle<a name="testing"> </a>

3. On the second terminal run:
```solidity
   $ ganache-cli -m "nick lucian brenda kevin sam fiscal patch fly damp ocean produce wish"
```
4. On the first terminal run: 
```solidity
    $   truffle test
```
5. And wait for the message 'START MINING RIG!!'

6. Kick off the python miner file [./miner/testMinerB.py](./miner/testMinerB.py). If you are using Sublime text editor, open the python miner and press Ctrl + B at the same time to start the miner.

Production and test python miners are available under the miner subdirectory [here](./miner/). You will need to get at least 5 miners running.

### User functions <a name="user-fx"> </a>  
Once the operator deploys the Berry Oracle. Users can buy the ERC-20 Berry Tributes (TT) token via an exchange or mine them.

To request data, users will need Tributes to call this function:
* <b>requestData</b> function allows the user to specify the API, timestamp and tip (this can be thought of as “gas”, the higher the tip/payout the higher the probability it will get mined next) for the value they are requesting.  If multiple parties are requesting the same data at the same time, their tips are combined to further incentivize miners at that time period and/or API. 

```javascript
oracle.requestData(string calldata _c_sapi,string calldata _c_symbol,uint _requestId,uint _granularity, uint _tip)
```
where:
   * \_c_sapi string API being requested be mined
   * \_c_symbol is the short string symbol for the api request
   * \_requestId being requested be mined if it exist otherwise use zero(0)
   * \_granularity is the number of decimals miners should include on the submitted value
   * \_tip amount the requester is willing to pay to be get on queue. Miners mine the onDeckQueryHash, or the api with the highest payout pool


To read data, users will need to call these two functions: 
* <b>retreiveData</b> function allows the user to read the data for the given API and timestamp
```javascript
oracle.retrieveData(uint _requestId, uint _timestamp)
```
where:
  * \_requestId -- is the request ID
  * \_timestamp -- is the unix timestamp to retrieve a value from

* <b>getLastQuery</b> function allows the user to read data from the latest API and timestamp mined. 
```javascript
oracle.getLastNewValue()
```

This is an example of a function that would need to be added to a contract so that it can read data from an oracle contact if the contract holds Tributes:
```Solidity
contract Oracle is usingBerry {
             ...
  function getLastNewValue() public returns(uint,bool) {
    (value,ifRetrieve)  = getLastNewValue();
                           return (value, ifRetreive);
             ...
  }
```
### Miner functions <a name="miner-fx"> </a>  
Miners engage in a POW competition to find a nonce which satisfies the requirement of the challenge.  The first five miners who solve the PoW puzzle provide the nonce, requestId, and value and receive native tokens in exchange for their work.  The oracle data submissions are stored in contract memory as an array - which is subsequently operated upon to derive the median value and the miner payout. 

Miners need to extract the current challenge, requestId and difficulty by calling the getCurrentVariables function before they can begin solving the PoW.

```javascript
oracle.getCurrentVariables()
```

The getCurrentVariables solidity function returns all the necessary variables. 
```solidity
    function getCurrentVariables(BerryStorageStruct storage self) internal view returns(bytes32, uint, uint,string memory,uint,uint){    
        return (self.currentChallenge,self.uintVars[keccak256("currentRequestId")],self.uintVars[keccak256("difficulty")],self.requestDetails[self.uintVars[keccak256("currentRequestId")]].queryString,self.requestDetails[self.uintVars[keccak256("currentRequestId")]].apiUintVars[keccak256("granularity")],self.requestDetails[self.uintVars[keccak256("currentRequestId")]].apiUintVars[keccak256("totalTip")]);
    }
```

Miners can use the submitMiningSolution function to submit the PoW, requestId, and off-chain value. Production and test python miners are available under the miner subdirectory [here](./miner/).  The PoW challenge is different than the regular PoW challenge used in Bitcoin. 

```javascript
oracle.submitMiningSolution(string nonce, uint _requestId, uint value)
```
where 
  * nonce -- is the solution string submitted by miner
  * \_requestId -- is the requestId for the request on queue
  * value -- is the value of api query


### Contracts Description <a name="Contracts-Description"> </a>
* <b>Berry.sol</b> -- is the Berry oracle contract and it allows miners to submit the proof of work, requestId, and value, sorts the values, pays the miners, allows the data users to request data and "tip" the miners to incentivize them to provide values, allows the users to retrieve and dispute the values.
    * <b>Berry.sol</b> --contains all the functions
       * <b>BerryDispute.sol</b> --contains the dispute functions' logic for the functions in Berry.sol
       * <b>BerryLibrary.sol</b> --contains the logic for the functions in Berry.sol relating to requesting data and submitting mined values.
       * <b>BerryStake.sol</b> --contains the staking functions' logic for the functions in Berry.sol
       * <b>BerryStorage.sol</b> --contains the storage variables used in Berry.sol
       * <b>BerryTransfer.sol</b> --contains the transfer and ERC20 functions' logic for the functions in Berry.sol
    * <b>BerryMaster.sol</b> -- contains the delegate calls to allow Berry.sol to write to the BerryGetters.sol. BerryMaster is BerryGetters.sol
       * <b>BerryGetters.sol</b> -- stores all the Berry.sol variables 
       * <b>BerryGettersLibrary.sol</b> --contains the logic for the functions in BerryGetters.sol


### Scripts Description <a name="Scripts-Description"> </a>

* <b>01_DeployBerry.js</b> -- deploys and connects Berry.sol and BerryMaster.sol


#### Copyright

Berry Data 2021
DDA Inc. 2018