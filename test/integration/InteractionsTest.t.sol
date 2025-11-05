// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

contract IntegrationTest is Test {
    FundMe fundMe;
    address USER = makeAddr("user");
    uint256 constant SEND_VALUE = 0.1 ether;
    uint256 constant STARTING_BALANCE = 10 ether;

    function setUp() external {
        // Deploy FundMe using the deployment script
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER, STARTING_BALANCE);
    }

    function testUserCanFundInteractions() public {
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();

        // Debugging info
        console.log("Contract balance:", address(fundMe).balance);

        // Check that the FundMe contract actually received ETH
        assertGt(
            address(fundMe).balance,
            0,
            "FundMe should have received funds"
        );

        // Optionally check mapping data
        uint256 amountFunded = fundMe.getAddressToAmountFunded(USER);
        assertEq(amountFunded, SEND_VALUE, "Fund amount mismatch");
    }
}
