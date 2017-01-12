//
//  AnswerCommentModel.swift
//  MyPerfectSwift
//
//  Created by ylongedu-macosx on 2016/12/20.
//
//

import Cocoa
import PerfectHTTP
class AnswerCommentModel: BDBaseManager {
    
    
    //获取所有的评论
    public func getComments(_ request:HTTPRequest,response:HTTPResponse){
        
        //链接数据库
        guard connectionMySQL() else {
            print("链接数据库失败")
            return
        }
        
        //读取数据库表
        guard mySQL.query(statement: "SELECT t1_answer_comment.status,answer_id,content,comment_time,audit_time,t1_user.show_name AS user_name,  photo_url AS header_url FROM t1_answer_comment JOIN t1_user ON t1_answer_comment.user_id=t1_user.id")else{
            return
        }
        
        //保存查询结果
        let results = mySQL.storeResults()
        
        //关闭数据库
        defer{
            mySQL.close()
        }
        
        //创建一个字典数组用于存储结果
        var ary = [[String:Any]]()
        var dic = [String:Any]()
        while let row = results?.next() {
            
            dic["status"]       = row[0]
            dic["answer_id"]    = row[1]
            dic["content"]      = row[2]
            dic["comment_time"] = row[3]
            dic["audit_time"]   = row[4]
            dic["user_name"]    = row[5]
            dic["header_url"]   = "http:" + row[6]!
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
