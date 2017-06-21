import Foundation
import Kitura
import HeliumLogger
import LoggerAPI

HeliumLogger.use()

let router = Router()

let userData = User()

extension String {
    func removeHTMLEncoding() -> String {
        let result = self.replacingOccurrences(of: "+", with: " ")
        return result.removingPercentEncoding ?? result
    }
}

func getPost(for request: RouterRequest, fields: [String]) -> [String:String]? {
    guard let values = request.body else {
        
        Log.error("cannot parse url")
        return nil }
    
    guard case .urlEncoded(let body) = values else { return nil }
    
    var result = [String : String]()
    
    for field in fields {
        if let value = body[field]?.trimmingCharacters(in: .whitespacesAndNewlines) {
            if value.characters.count > 0 {
                result[field] = value.removeHTMLEncoding()
                continue
            }
        }
        
        return nil
    }
    return result
}


router.post("/", middleware: BodyParser())
router.get("/") {
    request, response, next in
    defer { next() }
    
    
}

router.post("/user/login") {
    request, response, next in
    defer { next() }
    
    var message = ""
    
    if let results = getPost(for: request, fields: ["username", "password"]) {
        if let username = results["username"], let password = results["password"] {
            do {
                
                let loginResult = try userData.loginUser(name: username, pass: password, completion: { (text) in
                    message = text
                })

                
                if loginResult {
                    response.status(.OK).send(message)
                } else {
                    try response.status(.badRequest).send(message).end()
                }
            } catch {
                try response.status(.badRequest).send(message).end()
            }
            
        } else {
            try response.status(.internalServerError).send("CANNOT LOGIN").end()
        }
    }
    
}

router.post("/user/create") {
    request, response, next in
    defer { next() }
    
    var message = ""
    
    if let results = getPost(for: request, fields: ["username", "password"]) {
        if let username = results["username"], let password = results["password"] {
            do {
                
                let loginResult = try userData.createUser(name: username, pass: password, completion: { (text) in
                    message = text
                })

                
                if loginResult {
                    response.status(.OK).send(message)
                } else {
                    try response.status(.badRequest).send(message).end()
                }
            } catch {
                try response.status(.badRequest).send(message).end()
            }
            
        } else {
            try response.status(.internalServerError).send("CANNOT LOGIN").end()
        }
    }
    
}

Kitura.addHTTPServer(onPort: 8090, with: router)
Kitura.run()
