const { v4: uuidv4 } = require('uuid');
const config = require('config');
const Redis = require("ioredis");
const fs = require('fs');
class UserService {

    async create(user){
        console.log("Push user data within the REDIS Database start");
        const redisCLient=getClusterClient();
        user.id=uuidv4();
        await redisCLient.set(user.id,JSON.stringify(user));
        console.log("Push user data within the REDIS Database is over");
        return user;
    }
    async get(userId){
        console.log("Get user data within the REDIS Database start");
        const redisCLient=getClusterClient();
        console.log("Get user data within the REDIS Database is over");
        return JSON.parse(await redisCLient.get(userId));
    }

}
let redisCLient=null;
function getRedisClient(){
    if(!redisCLient){
        const isCLusterMode=config.get(redis_cluster_mode);
        redisCLient= isCLusterMode?getClusterClient():getSingleNodeClient();
    }
    return redisCLient;
}
function getClusterClient(){
    const nodes=config.get("redis_host");
    const server_port=config.get("redis_port");
    
 return new Redis.Cluster(nodes.map(host=> {return{
        port: server_port,
        host: host
    }}),{
        redisOptions: {
          password: config.get("redis_password"),
          username:config.get("redis_username"),       
          tls: {
            ca: fs.readFileSync(config.get("cert_location"))
          }
        },
    });

}
function getSingleNodeClient(){
    throw new Error("Not yet implemented !!!")
}
module.exports = new UserService();