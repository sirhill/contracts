pragma solidity ^0.6.0;

import "@c-layer/common/contracts/interface/IERC20.sol";
import "../interface/ITokenCore.sol";
import "../interface/ITokenProxy.sol";
import "../interface/ITokenAccessDefinitions.sol";


/**
 * @title ITokenFactory
 *
 * @author Cyril Lapinte - <cyril.lapinte@openfiz.com>
 * SPDX-License-Identifier: MIT
 *
 * Error messages
 **/
abstract contract ITokenFactory is ITokenAccessDefinitions {

  uint256 internal constant TOKEN_PROXY = 0;

  // The definitions below should be considered as a constant
  // Solidity 0.6.x do not provide ways to have arrays as constants
  bytes4[] public requiredCorePrivileges = [
    ASSIGN_PROXY_OPERATORS_PRIV,
    DEFINE_TOKEN_PRIV
  ];
  bytes4[] public requiredProxyPrivileges = [
    MINT_PRIV,
    FINISH_MINTING_PRIV,
    DEFINE_LOCK_PRIV,
    DEFINE_RULES_PRIV
  ];

  function hasCoreAccess(ITokenCore _core) virtual public view returns (bool access);

  function defineProxyCode(bytes memory _code) virtual public returns (bool);
  function deployToken(
    ITokenCore _core,
    uint256 _delegateId,
    string memory _name,
    string memory _symbol,
    uint256 _decimals,
    uint256 _lockEnd,
    bool _finishMinting,
    address[] memory _vaults,
    uint256[] memory _supplies,
    address[] memory _proxyOperators
  ) virtual public returns (IERC20);
  function approveToken(ITokenCore _core,
    ITokenProxy _token) virtual public returns (bool);
  function configureTokensales(
    ITokenProxy _token,
    address[] memory _tokensales,
    uint256[] memory _allowances) virtual public returns (bool);
  function updateAllowances(
    ITokenProxy _token,
    address[] memory _spenders,
    uint256[] memory _allowances) virtual public returns (bool);

  event TokenDeployed(IERC20 token);
  event TokenApproved(IERC20 token);
  event TokensalesConfigured(IERC20 token, address[] tokensales);
  event AllowanceUpdated(IERC20 token, address spender, uint256 allowance);
}
