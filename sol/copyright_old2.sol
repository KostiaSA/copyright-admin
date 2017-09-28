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
    address  public storageAddress;

    string  public name;

    string  public id;

    address[]  public files;

    // constructor
    function CopyrightUser(address _owner, string _name, string _id) public {
        storageAddress = msg.sender;

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
    address  public storageAddress;

    // constructor
    function CopyrightFile(address _author, string _fileName, string _description, bytes32 _hash) public {
        storageAddress = msg.sender;

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
//    mapping (RightToUse => address) filesByHash;
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

    address  public author;  // адрес CopyrightUser
    address  public exclusiveRightsHolder;  // адрес CopyrightUser
    string  public fileName;

    string  public description;

    bytes32  public hash;

    Offer[] public offers;

    RightToUse[] public rights;

}


contract CopyrightStorage is owned {

    address[] public users;

    mapping (bytes32 => address) public filesByHash;

    address[] public filesByAddress;

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


