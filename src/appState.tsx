const Eth = require("ethjs-query");
const EthContract = require("ethjs-contract");

declare var web3: any;
declare var Web3: any;


export class AppState {
    web3Provider: any;
    w3: any;

    start() {
        console.log("app started");
        this.initWeb3();
    }

    private initWeb3() {
// Initialize web3 and set the provider to the testRPC.
        //debugger
        if (web3 !== undefined) {
            this.web3Provider = web3.currentProvider;
            this.w3 = new Web3(this.web3Provider);
            console.log("web3 Ok ");
        } else {
            console.error("web3 error, no MetaMask");
            // // set the provider you want from Web3.providers
            // this.web3Provider = new web3.providers.HttpProvider("http://localhost:8545");
            // this.w3 = new Web3(web3.web3Provider);
        }
        //return App.initContract();

        //this.web3Provider = new web3.providers.HttpProvider("http://localhost:8545");
        //this.w3 = new Web3(web3.web3Provider);
    }


    async getBalance(address: string): Promise<any> {
        return new Promise((resolve, reject) => {
            this.w3.eth.getBalance(address, (error: any, result: any) => {
                if (error) {
                    reject(error);
                } else {
                    resolve(result);
                }
            })
        })
    }

    getContractAtAddress(address: string, abi: any): any {

        const eth = new Eth(web3.currentProvider);
        const contract = new EthContract(eth);
        const MiniToken = contract(abi);
        const miniToken = MiniToken.at(address);
        return miniToken;

    }

    getContractAbi(contractName: string): any {
        let json = require("../sol/copyright.json");
        let abi = JSON.parse(json.contracts["copyright.sol:" + contractName].abi);
        return abi;
    }

    getContractBin(contractName: string): string {
        let json = require("../sol/copyright.json");
        let bin = "0x" + json.contracts["copyright.sol:" + contractName].bin;
        return bin;
    }


    async waitForTxToBeMined(txHash: any): Promise<any> {
        const eth = new Eth(web3.currentProvider);
        let txReceipt;
        while (!txReceipt) {
            txReceipt = await eth.getTransactionReceipt(txHash)
        }
        return txReceipt;
    }
}

//export var app: AppState;
export var appState: AppState = new AppState();

// window.onload = () => {
//     console.log("onload");
//     app = new AppState();
//     app.start();
//     app.test1();
// };
