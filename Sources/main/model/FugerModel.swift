//
//  FugerModel.swift
//  MyPerfectSwift
//
//  Created by ylongedu-macosx on 2016/12/28.
//
//

import Cocoa
import PerfectHTTP
import PerfectHTTPServer
import MySQL


let HOST     = "127.0.0.1"
let USERNAME = "root"
let PASSWORD = ""
let BASE     = "Fuger"

let fugerMySQL = MySQL()

class FugerModel: NSObject {
    
    //连接数据库 创建表
    private func connectionFuger()->Bool{
    
        //链接数据库
        guard fugerMySQL.connect(host: HOST, user: USERNAME, password: PASSWORD, db: BASE) else {
            print("连接失败")
            return false
        }
        //创建city表
        guard fugerMySQL.query(statement: "CREATE TABLE t1_city(id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,city VARCHAR(20) NOT NULL)AUTO_INCREMENT=10000") else {
            
            print("创建city表失败")
            return false
        }
        guard fugerMySQL.query(statement: "CREATE TABLE t1_user(id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,user_name VARCHAR(20) NOT NULL ,city_id INT UNSIGNED,FOREIGN KEY (city_id) REFERENCES t1_city(id))AUTO_INCREMENT=10000") else {
            print("创建user表失败")
            return false
        }
        return true
    }
    
    //插入数据
    private func insertData()->Bool{

        //链接数据库创建表成功
        guard connectionFuger() else {
            print("链接失败/创建表失败")
            return false
        }
        
        //插入数据
        guard fugerMySQL.query(statement: "INSERT t1_city (city) VALUES ('深圳');") else {
            print("city表插入失败")
            return false
        }
        
        guard fugerMySQL.query(statement: "INSERT t1_user (user_name,city_id)VALUES('fuger',10000);") else {
            print("user表插入失败")
            return false
        }
        
        return true
        
    }
    
    
    //查询数据
    public func findData(_ resquest: HTTPRequest,response: HTTPResponse){
    
        
        guard insertData() else {
            return
        }
        
        //查询数据
        guard fugerMySQL.query(statement: "SELECT t1_user.id,t1_user.user_name,t1_city.city FROM t1_user LEFT JOIN t1_city ON t1_user.city_id=t1_city.id ORDER BY ('id','DESC');") else {
            return
        }
        
        //保存查询结果
        let resutls = fugerMySQL.storeResults()
        
        
        //关闭数据库
        defer{
            fugerMySQL.close()
        }
        
        //创建一个字典数组用于存储结果
        var ary = [[String:Any]]()
        var dic = [String:Any]()
        while let row = resutls?.next() {
            
            dic["id"]        = row[0]
            dic["username"]  = row[1]
            dic["city"]      = row[2]
            ary.append(dic)
        }
        let jsonarray = ["result":ary]
        
        do {
            try response.setBody(json: jsonarray)
            response.completed()
        } catch  {
            //抛出异常
            print(error)
        }
    }
}
