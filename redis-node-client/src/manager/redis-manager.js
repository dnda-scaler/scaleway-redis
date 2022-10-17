const config = require('config');
const Redis = require("ioredis");
const fs = require('fs');
class RedisManager {
    redisCLient=null;
    getRedisClient(){
        if(!this.redisCLient){
            const isCLusterMode=config.get("redis_cluster_mode");
            this.redisCLient= isCLusterMode?getClusterClient():getSingleNodeClient();
        }
        return this.redisCLient;
    }
}

function getClusterClient(){
    const nodes=config.get("redis_host");
    const server_port=config.get("redis_port");
 return new Redis.Cluster(nodes.map(host=> {return{
        port: server_port,
        host: host
    }}),{
        redisOptions: getRedisOptions()
    });

}
function getSingleNodeClient(){
    const host=config.get("redis_host")[0];
    const server_port=config.get("redis_port");
    const redisOptions={...getRedisOptions(),...{
        port: server_port,
        host: host
    }};
    return new Redis(redisOptions);
}

function getRedisOptions(){
    let redisOptions= {
        password: config.get("redis_password"),
        username:config.get("redis_username")
    }
    //We add TLS Option if 
    if(config.get("redis_tls_enabled")){
        redisOptions={... redisOptions,...{
            tls: {
            ca: fs.readFileSync(config.get("cert_location"))
          }
        }
    }
  }

  return redisOptions;
}
module.exports = new RedisManager();