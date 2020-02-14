//
//  OTMClient.swift
//  On the map
//
//  Created by Anderson Rodrigues on 12/02/2020.
//  Copyright © 2020 Anderson Rodrigues. All rights reserved.
//

import Foundation

class OTMClient {
    
    fileprivate struct Auth {
        static var accountdId = ""
        static var sessionId = ""
    }
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case createSessionId
        case getUserProfile
        case studentLocation(String?)
        case setStudentLocation(String)
        case signUp
        case logout
        
        var stringValue: String {
            switch self {
            case .createSessionId:
                return Endpoints.base + "/session"
            case .getUserProfile:
                return Endpoints.base + "/users/\(Auth.accountdId)"
            case .studentLocation(.none):
                return Endpoints.base + "/StudentLocation"
            case .studentLocation(.some(let query)):
                return Endpoints.base + "/StudentLocation?\(query)"
            case .setStudentLocation(let value):
                return Endpoints.base + "/StudentLocation/\(value)"
            case .signUp:
                return "https://www.udacity.com/account/auth%23!/signup&sa=D&ust=1581606299136000"
            case .logout:
                return Endpoints.base + "/session"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(from url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping(ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let body = try JSONEncoder().encode(body)
            request.httpBody = body
        } catch {
            completion(nil, error)
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            guard var data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            if !url.absoluteString.contains("StudentLocation") {
                let range = (5..<data.count)
                data = data.subdata(in: range) /* subset response data! */
            }
            
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    let errorObject = try decoder.decode(ErrorResponse.self, from: data)
                    DispatchQueue.main.async {
                        completion(nil, errorObject)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        
        task.resume()
    }
    
    class func taskForGETRequest<ResponseType: Decodable>(from url: URL, responseType: ResponseType.Type, completion: @escaping(ResponseType?, Error?) -> Void) {
        
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data, response, error) in
            guard var data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            if !url.absoluteString.contains("StudentLocation") {
                let range = (5..<data.count)
                data = data.subdata(in: range) /* subset response data! */
            }
            
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    let errorObject = try decoder.decode(ErrorResponse.self, from: data)
                    DispatchQueue.main.async {
                        completion(nil, errorObject)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
                
            }
        }
        
        task.resume()
    }
    
    class func login(username: String, password: String, completion: @escaping(Bool, Error?) -> Void) {
        let body = LoginRequest(udacity: User(username: username, password: password))
        taskForPOSTRequest(from: Endpoints.createSessionId.url, responseType: SessionResponse.self, body: body) { (response, error) in
            if let response = response {
                Auth.accountdId = response.account.key
                Auth.sessionId = response.session.id
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    class func getStudentProfile(completion: @escaping(Bool, Error?) -> Void) {
        taskForGETRequest(from: Endpoints.getUserProfile.url, responseType: StudentProfile.self) { (response, error) in
            if let response = response {
                StudentModel.student = response
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    class func getStudentLocation(query: String?, completion: @escaping([StudentInformation], Error?) -> Void) {
        taskForGETRequest(from: Endpoints.studentLocation(query).url, responseType: StudentLocationResults.self) { (response, error) in
            if let response = response {
                completion(response.results, nil)
            } else {
                completion([], error)
            }
        }
    }
    
    class func checkStudentLocation(completion: @escaping([StudentInformation]?, Error?) -> Void) {
        taskForGETRequest(from: Endpoints.studentLocation("uniqueKey=\(Auth.accountdId)").url, responseType: StudentLocationResults.self) { (response, error) in
            if let response = response {
                completion(response.results, nil)
            } else {
                completion([], error)
            }
        }
    }
    
    class func createStudentLocation(address: String, link: String, lat: Double, long: Double, completion: @escaping(Bool, Error?) -> Void) {
        
        guard let student = StudentModel.student else {
            return
        }
        
        let body = StudentLocationRequest(uniqueKey: student.key, firstName: student.firstName, lastName: student.lastName, mapString: address, mediaURL: link, latitude: lat, longitude: long)
        taskForPOSTRequest(from: Endpoints.studentLocation(nil).url, responseType: CreateStudentLocationResponse.self, body: body) { (response, error) in
            if let _ = response {
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    class func logout(completion: @escaping() -> Void) {
        var request = URLRequest(url: Endpoints.logout.url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
          if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
          request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            Auth.accountdId = ""
            Auth.sessionId = ""
            
            completion()
        }
        task.resume()
    }
}
