pragma solidity ^0.4.24;

import "./Ownable.sol";

// currently no math is used
// import "./SafeMath.sol";

contract StockPriceOracle is Ownable {
    // currently no math is used
    // using SafeMath for uint256;

    // trigger event when a stock price is updated
    event StockUpdate(uint stockId, string name, uint price, uint updateTime);

    event NewStockAdded(uint stockId, string name);

    // totalStocks is stocks.length

    struct Stock {
        string name;
        uint price; // in USD ct
        uint updateTime; // seconds since 1970
    }

    Stock[] public stocks;

    // list is maintained outside the blockchain
    string listedStocks;

    constructor(string _listedStocks) public{
        listedStocks = _listedStocks;
    }

    function priceOf(uint _stockId) public view returns (string _stockName, uint _price, uint _timestamp){
        require (_stockId < stocks.length);
        // get stock as copy of values
        Stock memory myStock = stocks[_stockId];
        return(myStock.name, myStock.price, myStock.updateTime);
    }


    function updateValue(uint _stockId, uint _stockPrice) public onlyOwner {
        require (_stockId < stocks.length);

        // get stock from array as pointer
        Stock storage myStock = stocks[_stockId];

        // write new Value and use timestamp of the block ("now") 
        myStock.price = _stockPrice;
        myStock.updateTime = now;

        // trigger event StockUpdate
        emit StockUpdate(_stockId, myStock.name, _stockPrice, myStock.updateTime);
    }

    // must be called by the owner before updating a stock the first time
    function createListEntry(string _newStock) public onlyOwner {
        // add empty entry to global stock array
        stocks.push(Stock(_newStock, 0, 0));
        // trigger event NewStockAdded(id, name)
        emit NewStockAdded(stocks.length-1, _newStock);
    }

    function nameToId(string _name) public view returns (uint _id){
        // find the Id of given stock name
        for(uint id=0; id<stocks.length; id++){
            if(keccak256(abi.encodePacked(stocks[id].name))==keccak256(abi.encodePacked(_name))){
                return id;
            }
        }
        revert("no Id for the name was found");
    }

    function viewListedStocks() public view returns (string){
        // return the global variable
        return listedStocks;
    }

    function setListedStocks(string _listedStocks) public onlyOwner(){
        // set the global variable
        listedStocks = _listedStocks;
    }

}

