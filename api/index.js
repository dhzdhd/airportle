const express = require('express');
const fs = require('fs');
const cors = require('cors');

let airportList;

const app = express();

const allowedOrigins = ['http://localhost:3000'];
const options = {
  origin: allowedOrigins
};

app.use(cors(options));

app.get('/api', async (req, res) => {
    res.setHeader('Content-Type', 'application/json');
    res.setHeader('Cache-Control', 's-max-age=1, stale-while-revalidate');

    if (!airportList) {
        const res = fs.readFileSync('./public/airports.json', 'utf8');
        airportList = JSON
            .parse(res)
            .filter(element =>
                element["ident"].length == 4 && element["ident"].split('').every(element =>
                    isNaN(element)
                )
            );
    }

    const airport = airportList[Math.floor(Math.random() * airportList.length)];

    res.json({
        ident: airport.ident,
        country: airport.iso_country,
        name: airport.name,
        continent: airport.continent,
        type_: airport.type,
    });
})

app.listen(5000, () => {
    console.log('Listening on http://localhost:5000/');
})

module.exports = app;
