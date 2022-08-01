// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;


contract TestCall{
    string public message;

    uint public x;

    event Log(string message);

    // fallback() external payable {
    //     emit Log("fallback was called");
    // }

    function foo(string memory _message, uint _x) external payable returns(bool,uint) {
        message = _message;
        x = _x;
        return(true, 999);
    }
}


contract Call {
    bytes public data;

    function callFool(address _adr) external payable {
        //(bool success, bytes memory _data) =  _adr.call{value: 111, gas: 5000}(abi.encodeWithSignature("foo(string,uint256)", "call foo", 123));
        (bool success, bytes memory _data) =  _adr.call{value: 111}(abi.encodeWithSignature("foo(string,uint256)", "call foo", 123));
        require(success, "call failed");
        data = _data;
    }

    function callDoesNotExit(address _adr) external {
        (bool success,)= _adr.call(abi.encodeWithSignature("doesNotExit()"));
        require(success, "call failed");
    }

}

