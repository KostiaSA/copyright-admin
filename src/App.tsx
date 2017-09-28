import * as React from "react";
import {appState} from "./appState";
import {buhtaAdminAccount, deployedCopyrightStorageAddress} from "./const";


export class App extends React.Component<any, any> {


    constructor(props: any, context: any) {
        super(props, context);
        this.props = props;
        this.context = context;
    }

//    socket: Socket;

    componentDidMount() {


    };


    render(): any {

        return (
            <div>
                <button onClick={() => {
                    this.handleDeployCopyrightStorage();
                }}>DeployCopyrightStorage
                </button>
                <br/>
                <button onClick={() => {
                    this.handle_show_CopyrightStorage_info();
                }}>show_CopyrightStorage_info
                </button>
                <br/>
                <button onClick={() => {
                    this.handle_test_registerNewUser();
                }}>test_registerNewUser
                </button>
                <br/>
                <button onClick={() => {
                    this.handle_show_user_info();
                }}>show_user_info
                </button>
                <br/>
                <button onClick={() => {
                    this.handle_test_registerNewFile();
                }}>test_registerNewFile
                </button>
            </div>

        )
    }


    async handleDeployCopyrightStorage() {
        console.log("handleDeployCopyrightStorage");

        let json = require("../sol/copyright.json");

        let bytecode = "0x" + json.contracts["copyright.sol:CopyrightStorage"].bin;
        let abi = JSON.parse(json.contracts["copyright.sol:CopyrightStorage"].abi);

        let web3 = appState.w3;

        web3.eth.defaultAccount = buhtaAdminAccount;

        const contract = web3.eth.contract(abi);

        contract.new(
            {
                from: buhtaAdminAccount,
                data: bytecode,
                gas: '1000000'
            }, function (e: any, contract: any) {
                console.log(e, contract);
                if (typeof contract.address !== 'undefined') {
                    console.log('Contract mined! address: ' + contract.address + ' transactionHash: ' + contract.transactionHash);
                }
            });


    };

    async handle_show_CopyrightStorage_info() {
        let contract = appState.getContractAtAddress(deployedCopyrightStorageAddress, appState.getContractAbi("CopyrightStorage"));
        console.log(contract);
        console.log("owner", (await contract.owner.call())[0]);

        console.log("users 0", (await contract.users(0)));
        console.log("users 1", (await contract.users(1)));
        console.log("users 2", (await contract.users(2)));

    };

    async handle_test_registerNewUser() {
        let contract = appState.getContractAtAddress(deployedCopyrightStorageAddress, appState.getContractAbi("CopyrightStorage"));
        console.log(contract);

        let tx = await contract.registerNewUser("Иван Драго", "id=9457839349", {
            from: buhtaAdminAccount,
            value: 0,
            gas: 1000000
        });
        console.log("new user contract", tx);

        let result = await appState.waitForTxToBeMined(tx);
        console.log("mined-result", result);
    };

    async handle_show_user_info() {
        let contract = appState.getContractAtAddress(deployedCopyrightStorageAddress, appState.getContractAbi("CopyrightStorage"));
        console.log(contract);

        let userContractAddr = (await contract.users(0))[0];
        let userContract = appState.getContractAtAddress(userContractAddr, appState.getContractAbi("CopyrightUser"));

        console.log("user name", (await userContract.name())[0]);
        console.log("user id", (await userContract.id())[0]);

    };

    async handle_test_registerNewFile() {
        let contract = appState.getContractAtAddress(deployedCopyrightStorageAddress, appState.getContractAbi("CopyrightStorage"));
        let userContractAddr = (await contract.users(0))[0];
        let userContract = appState.getContractAtAddress(userContractAddr, appState.getContractAbi("CopyrightUser"));

        //function registerNewFile(string _fileName, string _description, bytes32 _hash) public returns (address newFileContract){

        let tx = await userContract.registerNewFile(
            "Наполнение продвигаемых страниц buhta.ru с пометками.docx",
            "особь с врожденными недостатками тела, возможно, вследствие генетического дефекта или воздействия негативных факторов в эмбриональном периоде",
            "0x6f6652a0e5aa65b63bc7966961446b151b43dda423ee723d7fbe2cd49f7ab1cc",
            {
                from: buhtaAdminAccount,
                value: 0,
                gas: 2000000
            });
        console.log("new file", tx);

        let result = await appState.waitForTxToBeMined(tx);
        console.log("mined-result", result);
    };
}

