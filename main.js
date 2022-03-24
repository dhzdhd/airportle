import "./styles.css";
import { Elm } from "./src/Main.elm";

const fetchAirportInfo = async () => {
    const headers = new Headers()
    headers.append('Content-Type', 'application/json');
    headers.append('Accept', 'application/json');

    const res = await fetch(
        'https://airportle.vercel.app:5000/api/',
        { headers: headers }
    );
    const airport = await res.json();

    console.log(airport);
    return airport;
};

fetchAirportInfo().then(airport => {
    const root = document.getElementById("app");
    const app = Elm.Main.init({
        node: root,
        flags: {
            ident: airport.ident,
            country: airport.country,
            name: airport.name,
            continent: airport.continent,
            type_: airport.type_,
        }
    });
}).catch(err => console.error(err));
