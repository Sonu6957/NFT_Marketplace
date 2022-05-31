// SPDX-License-Identifier: Unlicensed

pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


contract NewToken is ERC20 {
    uint initial_supply = 100*(10**6)*10**9;
    constructor() ERC20("NewToken", "NTK") {
        _mint(msg.sender, initial_supply);
    }
}
