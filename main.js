import "./styles.css";
import { Elm } from "./src/Main.elm";

const airportCodeUrl = "https://pkgstore.datahub.io/core/airport-codes/airport-codes_json/data/9ca22195b4c64a562a0a8be8d133e700/airport-codes_json.json";

// ? Top level awaits do not work in vercel :(
// const rawAirportCodes = await (await fetch(airportCodeUrl)).json();

const fetchAirportInfo = async () => {
    const rawAirportList = await (await fetch(airportCodeUrl)).json();
    const airportList = rawAirportList.filter(element => element["ident"].length == 4 && element["ident"].split('').every(element => isNaN(element)));
    const airport = airportList[Math.floor(Math.random() * airportList.length)]

    console.log(airport);

    return airport;
};

fetchAirportInfo().then(airport => {
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
}).catch(err => console.log(err));
