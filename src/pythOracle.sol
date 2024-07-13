// SPDX-License-Identifier: AGPL-3.0
pragma solidity 0.8.18;

interface IPythOracle {
    struct Price {
        // Price
        int64 price;
        // Confidence interval around the price
        uint64 conf;
        // Price exponent
        int32 expo;
        // Unix timestamp describing when the price was published
        uint publishTime;
    }
    function getPrice(bytes32 _tokenId) external view returns(Price memory _price);
    function getPriceUnsafe(bytes32 _tokenId) external view returns(Price memory _price);

}

contract pythOracleReader {

    IPythOracle public oracle;

    constructor(address _oracle) {
        oracle = IPythOracle(_oracle);
    }

    mapping(address => bytes32) public tokenIds;


    function addToken(address _token, bytes32 _tokenId) external {
        tokenIds[_token] = _tokenId;
    }


    function getValue(address _token, uint256 _amount) external view returns(uint256) {

        bytes32 tokenId = tokenIds[_token];
        
        //IPythOracle.Price memory price = oracle.getPrice(tokenId);
        // NOTE we use this function to bypass the check for the price being stale in case testnet data not available
        IPythOracle.Price memory price = oracle.getPriceUnsafe(tokenId);

        uint256 uintPrice = uint256(int256(price.price));
        // TODO : Fix logic for handling exponents + making units consistent
        return uintPrice * _amount * (10 ** uint256(8 + int256(price.expo)));


    }

}