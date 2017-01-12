//
//  LoginModel.swift
//  MyPerfectSwift
//
//  Created by ylongedu-macosx on 2016/12/16.
//
//

import Cocoa
import PerfectHTTP
class LoginModel: BDBaseManager {
    
    public func login(_ request:HTTPRequest, response:HTTPResponse,username:String){
        
        guard connectionMySQL() else {
            print("连接数据库失败,\(mySQL.errorMessage())")
            return
        }
        
        guard mySQL.query(statement: "SELECT id,ylong_name,show_name,photo_url FROM t1_user where ylong_name = \(username)") else {
            return
        }
        //保存查询结果
        let results = mySQL.storeResults()
        
        defer{
            mySQL.close()
        }
        var ary = [[String:Any]]() //创建一个字典数组用于存储结果
        var dic = [String:Any]()
        while let row = results?.next() {
            
            dic["user_id"]    = row[0]
            dic["ylong_name"] = row[1]
            dic["show_name"]  = row[2]
            dic["photo_url"]  = row[3]
            ary.append(dic)
        }
        let jsonarray = ["result":ary]
        do {
            
            try response.setBody(json: jsonarray)
            response.completed()
        } catch  {
            
            print(error)
            
        }
        
    }
    


}
