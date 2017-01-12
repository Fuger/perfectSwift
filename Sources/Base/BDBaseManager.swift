//
//  BDBaseManager.swift
//  MyPerfectSwift
//
//  Created by ylongedu-macosx on 2016/12/8.
//
//

import Cocoa
import PerfectHTTP
import PerfectHTTPServer
import MySQL

let DB_HOST     = "192.168.0.140"
let DB_USERNAME = "wantal"
let DB_PASSWORD = "123456"
let DB_BASE     = "ylongedu_exam_record"
let mySQL = MySQL()
class BDBaseManager: NSObject {
    
  
    //连接数据库 
    public func connectionMySQL()->Bool{
        
        guard mySQL.connect(host: DB_HOST, user: DB_USERNAME, password: DB_PASSWORD,db: DB_BASE) else {
            print("连接数据库失败,\(mySQL.errorMessage())")
            return false
        }
        
        return true
    
    }
    
}
