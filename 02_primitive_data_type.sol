// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;


contract Primitives {
    bool public boo = true;

/*
    uint stands for unsigned integer, meaning non negative integers
    different sizes are available
    uint8   ranges from 0 to 2 ** 8 - 1
    uint16  ranges from 0 to 2 ** 16 - 1
        ...
    uint256 ranges from 0 to 2 ** 256 - 1
    */
    uint8 public u8 = 1;
    uint public u256 = 456;
    uint public u = 123;

    int8 public i8 = -1;
    int public i256 = 456;
    int public i = -123;

    int public minInt = type(int).min;
    int public maxInt = type(int).max;

    address public addr = 0xCA35b7d915458EF540aDe6068dFe2F44E8fa733c;
        /*
    In Solidity, the data type byte represent a sequence of bytes. 
    Solidity presents two type of bytes types :

     - fixed-sized byte arrays
     - dynamically-sized byte arrays.
     
     The term bytes in Solidity represents a dynamic array of bytes. 
     It’s a shorthand for byte[] .
    */

    bytes1 a = 
}