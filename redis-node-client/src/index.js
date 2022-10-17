const express = require("express");
const bodyParser = require("body-parser");
const cors = require("cors");
const userService= require("./services/user-service");
(function initialize(){
    serverInit()
})();

function serverInit(){
    console.log("Web server initialization start")
    const app = express();
    app.use(cors());
    app.use(bodyParser.json());
    app.get("/user/:id",(req, res) => {
        userService.get(req.params.id).then((result)=>{
            res.send(result);
        });
    });

    app.post("/user",(req, res) => {
        userService.create(req.body).then((result)=>{
            res.send(result);
        });
    });
    const port=5000
    app.listen(port,(err) => {
        console.log("Web server initialization is over")
        console.log("server is currently listening on port ", port);
    });
}
//TODO Single Test
//TODO TLS Toogling Cluster