import "./styles.css";
import { Elm } from "./src/Main.elm";

const root = document.getElementById("app");
const app = Elm.Main.init({
    node: root,
});
