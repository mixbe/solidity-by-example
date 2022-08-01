// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;



/*
# Siging
1. create message to sign
2. Hash to message
3. Sign the hash (off chain, keep your private key secret)


# verify
1. recreate hash from the original message;
2. recover signer from signature and hash;
3. compare recovered signer to claimed signer


# chrome console generage signature
1. ethereum.enable()
2. hash = "0x9c97d796ed69b7e69790ae723f51163056db3d55a7a6a82065780460162d4812"
   account = "xxxxxx"
3. ethereum.request({method:"personal_sign", params:[account, hash]})
*/


contract VerifySignature {

    function verify(address _signer, string memory _message, bytes memory signature) 
    public pure returns(bool){

        bytes32 messageHash = getMessageHash(_message);
        bytes32 ethSignedMessageHash = getEthSignedMessageHash(messageHash);

        return recoverSigner(ethSignedMessageHash, signature) == _signer;

    }

    function getMessageHash(string memory _message) public pure  returns(bytes32){
        return keccak256(abi.encodePacked(_message));
    }

    function getEthSignedMessageHash(bytes32 _messageHash) public pure returns(bytes32) {
        return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", _messageHash));
    }

    function recoverSigner(bytes32 _ethSignedMessageHash, bytes memory _signature) public pure returns(address){
        (bytes32 r, bytes32 s, uint8 v) = splitSignature(_signature);
        return ecrecover(_ethSignedMessageHash, v, r, s);

    }

    function splitSignature(bytes memory sig) public pure returns(bytes32 r, bytes32 s, uint8 v){
        require(sig.length == 65, "invalid signature length");
        assembly {
            r:= mload(add(sig, 32))
            s:= mload(add(sig, 64))
            v:= byte(0, mload(add(sig, 96)))
        }
    }

}




