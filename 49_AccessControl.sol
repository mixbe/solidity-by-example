// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;


// 权限控制合约

contract AccessControl {
    // 授权事件
    event GrantRole(bytes32 indexed role, address indexed account);
    // 撤销事件
    event RevokeRole(bytes32 indexed role,address indexed account);

    // role => account => bool
    mapping(bytes32 => mapping(address => bool)) public roles;

    // bytes32 public constant ADMIN = keccak256(abi.encodePacked("ADMIN"));
    // 0xdf8b4c520ffe197c5343c6f5aec59570151ef9a492f2c624fd45ddde6135ec42
    bytes32 private constant ADMIN = keccak256(abi.encodePacked("ADMIN"));

    // bytes32 public constant USER = keccak256(abi.encodePacked("USER"));
    // 0x2db9fd3d099848027c2383d0a083396f6c41510d7acfd92adc99b6cffcf31e96
    bytes32 private constant USER = keccak256(abi.encodePacked("USER"));

    // 构造函数，确保管理员有权限
    constructor() {
        _grantRole(ADMIN, msg.sender);
    }

    modifier onlyRole(bytes32 _role) {
        require(roles[_role][msg.sender], "not authorized");
        _;
    }

    function _grantRole(bytes32 _role, address _account) internal {
        roles[_role][_account] = true;
        emit GrantRole(_role, _account);
        
    }

    // 授权
    function grantRole(bytes32 _role, address _account) external onlyRole(ADMIN){
        _grantRole(_role, _account);
    }

    // 撤销
    function revokeRole(bytes32 _role, address _account) external onlyRole(ADMIN){
        roles[_role][_account] = false;
        emit RevokeRole(_role, _account);
    }


}