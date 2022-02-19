import "./styles.css";
import { Elm } from "./src/Main.elm";

const airportCodeUrl = "https://pkgstore.datahub.io/core/airport-codes/airport-codes_json/data/9ca22195b4c64a562a0a8be8d133e700/airport-codes_json.json";
const rawAirportCodes = await (await fetch(airportCodeUrl)).json();
const airportCodes = rawAirportCodes.filter(element => element["ident"].length == 4 && element["ident"].split('').every(element => isNaN(element)));
const airport = airportCodes[Math.floor(Math.random() * airportCodes.length)]
console.log(airport);

const root = document.getElementById("app");
const app = Elm.Main.init({
    node: root,
    flags: {
        ident: airport.ident,
        country: airport.iso_country,
        name: airport.name,
        continent: airport.continent,
        aType: airport.type,
    }
});
