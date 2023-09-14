// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {DeployOurToken} from "../script/DeployOurToken.s.sol";
import {OurToken} from "../src/OurToken.sol";

contract TestOurToken is Test {
    DeployOurToken deployer;
    OurToken ourToken;
    address public deployerAddress;

    address bob = makeAddr("bob");
    address alice = makeAddr("alice");

    uint256 public constant INITIAL_BALANCE = 100 ether;
    uint256 public constant INITIAL_SUPPLY = 1_000_000 ether;

    function setUp() public {
        deployer = new DeployOurToken();
        ourToken = deployer.run();

        vm.prank(msg.sender);
        ourToken.transfer(bob, INITIAL_BALANCE);
    }

    function testInitialBalanceTransferedToBob() public {
        assertEq(INITIAL_BALANCE, ourToken.balanceOf(bob));
    }

    function testInitialSupply() public {
        assertEq(INITIAL_SUPPLY, ourToken.totalSupply());
    }

    function testAllowance() public {
        uint256 initial_allowance = 1000;

        vm.prank(bob);
        ourToken.approve(alice, initial_allowance);
        assertEq(initial_allowance, ourToken.allowance(bob, alice));
    }

    function testTransferFrom() public {
        uint256 initial_allowance = 1000;

        vm.prank(bob);
        ourToken.approve(alice, initial_allowance);

        uint256 transfer_amount = 500;
        vm.prank(alice);
        ourToken.transferFrom(bob, alice, transfer_amount);

        assertEq(ourToken.balanceOf(alice), transfer_amount);
        assertEq(ourToken.balanceOf(bob), INITIAL_BALANCE - transfer_amount);
    }
}
