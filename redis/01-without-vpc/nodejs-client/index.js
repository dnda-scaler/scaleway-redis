const {createClient}=require("redis")
const fs = require('fs');

const client=createClient({
    url: 'redis://root:Test1;234a@51.159.180.105:6379',
    socket: {
        tls: true,
       // servername: "51.159.180.105",
        ca:  fs.readFileSync("/home/damnda/Downloads/SSL_redis-test_redis_basic.pem") 
    }
});

client.on('error', (err) => console.log('Redis Client Error', err));

client.connect().then(()=>{
    console.log("server start fine")
});
