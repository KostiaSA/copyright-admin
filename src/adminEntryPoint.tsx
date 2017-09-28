import * as  React from "react";
import * as  ReactDOM from "react-dom";
import {App} from "./App";
import {appState} from "./appState";

console.log("admin begin start...");

appState.start();

ReactDOM.render(<App/>, document.getElementById("content"));

console.log("admin started");
