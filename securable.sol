// SPDX-License-Identifier: MIT

pragma solidity ^0.8.11;

contract Securable {

    mapping(address => bool) registered;
    mapping(bytes32 => bool) approvedHash;
    mapping(address => mapping(bytes32 => bool)) passCode;

    error WrongHash(bytes32 sentHash, bytes32 savedHash);

    // Magic word is "Solidity"
    function getHash(string memory word, bytes32 senderHash, bytes32 newHashA, bytes32 newHashB) public returns (bool) {

        bytes32 hash = keccak256(abi.encodePacked(word));

        require(registered[msg.sender] == false);
        require(approvedHash[hash] == true);

        registered[msg.sender] = true;
        passCode[msg.sender][senderHash] = true;
        approvedHash[newHashA] = true;
        approvedHash[newHashB] = true;

        return true;
    }

    function checkHash(string memory word, bytes32 newHash) public returns (bool) {

        bytes32 oldHash = keccak256(abi.encodePacked(word));

        require(registered[msg.sender] == true);
        require(passCode[msg.sender][oldHash] == true);

        passCode[msg.sender][oldHash] = false;
        passCode[msg.sender][newHash] = true;

        return true;
    }

    function addHash(bytes32 newHashA, bytes32 newHashB) public returns (bool) {

        approvedHash[newHashA] = true;
        approvedHash[newHashB] = true;

        return true;
    }

    function removeHash(bytes32 oldHash) public returns (bool) {

        require(approvedHash[oldHash] == true);

        approvedHash[oldHash] = false;

        return true;
    }

    function isHash(bytes32 hash) public view returns (bool) {
        return approvedHash[hash];
    }

    function isRegistered() public view returns (bool) {
        return registered[msg.sender];
    }

    function isPassCode(bytes32 hash) public view returns (bool) {
        return passCode[msg.sender][hash];
    }

}
