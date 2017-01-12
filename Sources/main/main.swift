

import PerfectLib
import PerfectHTTP
import PerfectHTTPServer


// 创建HTTP服务器
let server = HTTPServer()
let loginModel = LoginModel()
let answerCommentMdoel = AnswerCommentModel()
// 注册您自己的路由和请求／响应句柄
var routes = Routes()
routes.add(method: .get, uri: "/home/**") { (request, response) in
    
    // 获得符合通配符的请求路径
    request.path = request.urlVariables[routeTrailingWildcardKey]!
    
    // 用文档根目录初始化静态文件句柄
    StaticFileHandler(documentRoot:request.documentRoot).handleRequest(request: request, response: response)
    
}

routes.add(method: .post, uri: "/login", handler: {
    request, response in
    response.setHeader(.contentType, value: "application/x-www-form-urlencoded")

    guard let username = request.param(name:"username") else{

        do{
            try response.setBody(json: ["error":"参数错误","code":300])
                response.completed()
        }catch{
            print(error)
        }
        return
    }
    loginModel.login(request, response: response,username: username)
    
})

//获取评论
routes.add(method: .get, uri: "/comments") { (request, response) in
    
    answerCommentMdoel.getComments(request, response: response)
}


//let fugerModel = FugerModel()
//routes.add(method: .get, uri: "/fuger") { (resquest, response) in
    
  //  fugerModel.findData(resquest, response: response)
    
//}

// 将路由注册到服务器上
server.addRoutes(routes)

// 监听8181端口
server.serverPort = 8181

server.documentRoot = "./webroot"



do {
    // 启动HTTP服务器
    try server.start()
} catch PerfectError.networkError(let err, let msg) {
    print("网络出现错误：\(err) \(msg)")
}
