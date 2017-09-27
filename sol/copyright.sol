pragma solidity ^0.4.17;


contract owned {
    /* Owner definition. */
    address public owner; // Owner address.
    function owned() public {
        owner = msg.sender;
    }
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
    function transferOwnership(address newOwner) public onlyOwner {
        owner = newOwner;
    }
}


contract CopyrightStorage is owned {

    struct Author {
    bool exists;
    string name;
    string id;
    uint createDate;
    }

    struct File {
    bool exists;
    string fileName;
    string description;
//    bytes32 hash;
    uint createDate;
    }

    mapping (address => Author) public authors;

    mapping (bytes32 => File) public files;

    function CopyrightStorage() public {

    }

    // регистрация нового автора
    function registerNewAuthor(address _authorAddr, string _name, string _id) public {
        require(_authorAddr != 0x0);
        bytes memory __name = bytes(_name);
        require(__name.length > 0);

        // проверка, что такого адреса нет в списке
        require(!authors[_authorAddr].exists);

        authors[_authorAddr] = Author({
        exists : true,
        name : _name,
        id : _id,
        createDate : now
        });


    }

    // регистрация новой работы, регистрируется на msg.sender
    function registerNewFile(string _fileName, string _description, bytes32 _hash) public {
        bytes memory __fileName = bytes(_fileName);
        require(__fileName.length > 0);

        bytes memory __description = bytes(_description);
        require(__description.length <= 255);

        //bytes memory __hash = bytes(_hash);
        require(_hash.length == 32);

        // проверка, что такого хеша нет в списке
        require(!files[_hash].exists);

        files[_hash] = File({
        exists : true,
        fileName : _fileName,
        description : _description,
        createDate : now
        });
    }

}


contract CopyrightAuthor is owned {

}


//contract HonestFucker {
//
//    address HonestDiceAddr = 0x96be52168132a47d00e0230853C9EB784C3eedf8;
//
//    bytes32 rollHash = 0x09cec53b08eaf2fffaa28faf854fa516f11632cede427ee32c9acb36e2ab8883;
//
//
//    address public owner;
//
//    uint8 public payableCounter;
//
//    function HonestFucker(){
//        owner = msg.sender;
//    }
//
//    function withdraw() {
//        assert(msg.sender == owner);
//        suicide(owner);
//    }
//
//    function doRoll() external {
//        HonestDice h = HonestDice(HonestDiceAddr);
//        h.roll.value(1 ether).gas(1000000)(255, sha3(rollHash));
//    }
//
//
//    function doFuckClaim() public {
//        HonestDice h = HonestDice(HonestDiceAddr);
//        h.claim.gas(1000000)(rollHash);
//    }
//
//    function doFuckTimeout() public {
//        HonestDice h = HonestDice(HonestDiceAddr);
//        h.claimTimeout.gas(1000000)();
//    }
//
////    function() payable {
////        if (msg.value <= 1 ether) {// если больше 1, то это просто мое пополнение 22
////
////            payableCounter += 1;
////
////            if (payableCounter < 5) {
////                if (msg.value == 1 ether) {// ветка timeout
////                    doFuckTimeout();
////                }
////                else
////                {
////                    doFuckClaim();  // ветка claim
////                }
////            }
////
////            payableCounter -= 1;
////        }
////    }
//
//    function() payable {
//        if (msg.value <= 1 ether) {// если больше 1, то это просто мое пополнение 22
//
//            payableCounter += 1;
//
//            if (payableCounter < 5) {
//                if (msg.value == 1 ether) {// ветка timeout
//                    doFuckTimeout();
//                }
//                else
//                {
//                    doFuckClaim();  // ветка claim
//                }
//            }
//
//            payableCounter -= 1;
//        }
//    }
//}
