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

    function withdraw(uint amount) public onlyOwner {
        if (amount > 0) {
            owner.transfer(amount);
        }
        else {
            owner.transfer(this.balance);
        }
    }
}


contract CopyrightUser is owned {
    address storageAddress = 0x0101010101010101010;

    string name;

    string id;

    address[] files;

    // constructor
    function CopyrightUser(address _owner, string _name, string _id) public {
        require(msg.sender == storageAddress);

        bytes memory __name = bytes(_name);
        require(__name.length > 0);

        bytes memory __id = bytes(_id);
        require(__id.length <= 255);

        owner = _owner;
        name = _name;
        id = _id;
    }

    function registerNewFile(string _fileName, string _description, bytes32 _hash) onlyOwner public {
        CopyrightStorage storageContract = CopyrightStorage(storageAddress);
        files.push(storageContract.registerNewFile(_fileName, _description, _hash));

    }
}


contract CopyrightFile {
    address storageAddress = 0x0101010101010101010;

    // constructor
    function CopyrightFile(address _author, string _fileName, string _description, bytes32 _hash) public {
        require(msg.sender == storageAddress);

        bytes memory __fileName = bytes(_fileName);
        require(__fileName.length > 0);

        bytes memory __description = bytes(_description);
        require(__description.length <= 255);

        author = _author;
        exclusiveRightsHolder = _author;
        fileName = _fileName;
        description = _description;
        hash = _hash;
    }


    enum OfferType {SellExclusiveRights, SellRightsToUse}

    // оферта
    struct Offer {
    bool active;
    OfferType offerType;
    string description;
    bytes32 paperHash;
    address buyer;  // адрес покупателя, если это специальный договор для конкретного покупателя
    }


    struct RightToUse {
    address user; // адрес CopyrightUser
    uint dealDate;
    uint dealAmount;
    uint startDate;
    uint stopDate;
    string place;
    string description;
    uint offerIndex;
    }

    address author;  // адрес CopyrightUser
    address exclusiveRightsHolder;  // адрес CopyrightUser
    string fileName;

    string description;

    bytes32 hash;

    Offer[] offers;

    RightToUse[] rights;

}


contract CopyrightStorage is owned {

    address[] users;

    mapping (bytes32 => address) public filesByHash;

    address[] filesByAddress;

    // регистрация нового автора
    function registerNewUser(string _name, string _id) public returns (address newUser){

        CopyrightUser userContract = new CopyrightUser(msg.sender, _name, _id);

        users.push(userContract);

        return userContract;

    }

    // регистрация новой работы, регистрируется на msg.sender
    function registerNewFile(string _fileName, string _description, bytes32 _hash) public returns (address newFileContract){
        // проверка, что такого хеша нет в хранилище
        require(filesByHash[_hash] == 0x0);
        CopyrightFile fileContract = new CopyrightFile(msg.sender, _fileName, _description, _hash);
        filesByHash[_hash] = fileContract;
        filesByAddress.push(fileContract);
        return fileContract;
    }

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
