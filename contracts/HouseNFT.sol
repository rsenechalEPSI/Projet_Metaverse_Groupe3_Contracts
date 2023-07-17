// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract HouseNFT is ERC721Enumerable {
    struct House {
        string location;
        uint256 size;
        address owner;
    }

    House[] public houses;
    uint256 public cost;
    uint256 public maxSupply;
    uint256 totalSup;

    event HouseMinted(uint256 indexed tokenId, address indexed owner, string location);

    constructor(uint256 _cost, uint256 _maxSupply) ERC721("HouseNFT", "HNFT") {
        cost = _cost;
        maxSupply = _maxSupply;
        totalSup = 0;
    }

    function mint(string memory _location) public payable {
        require(totalSup < maxSupply, "Nombre maximal de maisons atteint");
        require(msg.value >= cost, "Montant d'ETH insuffisant pour acheter une maison");

        House memory newHouse = House({
            location: _location,
            size: 0, // Remplir la taille de la maison avec une valeur appropriée
            owner: msg.sender
        });

        houses.push(newHouse);
        totalSup++;

        uint256 tokenId = totalSup - 1;
        _mint(msg.sender, tokenId);

        emit HouseMinted(tokenId, msg.sender, _location);
    }

    function getHouseLocation(uint256 _tokenId) public view returns (string memory) {
        require(_tokenId < totalSup, "L'ID de la maison n'existe pas");

        return houses[_tokenId].location;
    }

    function getHouseSize(uint256 _tokenId) public view returns (uint256) {
        require(_tokenId < totalSup, "L'ID de la maison n'existe pas");

        return houses[_tokenId].size;
    }

    function isHouseOwner(uint256 _tokenId) public view returns (bool) {
        require(_tokenId < totalSup, "L'ID de la maison n'existe pas");

        return houses[_tokenId].owner == msg.sender;
    }
}