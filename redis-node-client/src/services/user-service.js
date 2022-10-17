const { v4: uuidv4 } = require('uuid');
const redisManager=require("../manager/redis-manager")
class UserService {

    async create(user){
        console.log("Push user data within the REDIS Database start");
        user.id=uuidv4();
        await redisManager.getRedisClient().set(user.id,JSON.stringify(user));
        console.log("Push user data within the REDIS Database is over");
        return user;
    }
    async get(userId){
        console.log("Get user data within the REDIS Database start");
        console.log("Get user data within the REDIS Database is over");
        return JSON.parse(await redisManager.getRedisClient().get(userId));
    }

}
module.exports = new UserService();