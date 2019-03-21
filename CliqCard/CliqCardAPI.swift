//
//  APIService.swift
//  CliqCard
//
//  Created by Sam Ober on 6/14/18.
//  Copyright © 2018 Sam Ober. All rights reserved.
//

import Foundation
import Alamofire
import SwiftKeychainWrapper
import SwiftyJSON

final class CliqCardAPI {
    
    static let shared = CliqCardAPI()
    
    let host = "https://api.getcliqcard.com"
    let clientId = "ai7fiau3hfihiwufhseuhkaueyf"
    let clientSecret = "aiuhfiouhsfoi3ahsflsudhguiowhfalksdflauhfljkshafkjwe"
    
//    let host = "http://192.168.1.229:5000"
//    let clientId = "784awhflkusdfhoawhpwjcwo4hf"
//    let clientSecret = "afhow874afhoirsujcauowh47hrvldfkjaow4hgasroiiasuhddfhiusaow47h"
    
    let clientCredentials: String
    
    private var _currentUser: CCAccount? {
        get {
            if let data = UserDefaults.standard.object(forKey: "api_current_user") as? Data {
                return NSKeyedUnarchiver.unarchiveObject(with: data) as? CCAccount
            }
            return nil
        }
        set {
            if let newValue = newValue {
                // encode and save in user defaults
                let data = NSKeyedArchiver.archivedData(withRootObject: newValue)
                UserDefaults.standard.set(data, forKey: "api_current_user")
            } else {
                // remove the value from user defaults
                UserDefaults.standard.removeObject(forKey: "api_current_user")
            }
        }
    }
    
    private var _token: CCToken? {
        get {
            if let data = KeychainWrapper.standard.data(forKey: "api_token") {
                return NSKeyedUnarchiver.unarchiveObject(with: data) as? CCToken
            }
            return nil
        }
        set {
            if let newValue = newValue {
                // encode and save in user defaults
                let data = NSKeyedArchiver.archivedData(withRootObject: newValue)
                KeychainWrapper.standard.set(data, forKey: "api_token")
            } else {
                // remove the value from user defaults
                KeychainWrapper.standard.removeObject(forKey: "api_token")
            }
        }
    }

    var currentUser: CCAccount? {
        get {
            return self._currentUser
        }
    }
    
    private init() {
        // set client credentials
        clientCredentials = "\(clientId):\(clientSecret)".data(using: .utf8)!.base64EncodedString()
        
        // check to see if we are logged in
        if self.isLoggedIn() {
            // reload the user account
            self.getAccount(responseHandler: nil)
        }
    }
    
    func isLoggedIn() -> Bool {
        return _currentUser != nil && _token != nil
    }
    
    private func _headers() -> HTTPHeaders {
        var headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        
        if let token = _token {
            headers["Authorization"] = "\(token.tokenType) \(token.accessToken)"
        }
        
        return headers
    }
    
    private func _request(_ url: String, method: HTTPMethod, parameters: Parameters?, responseHandler: @escaping (Int?, Any?, APIError?) -> Void) {
        // make the request
        Alamofire.request("\(host)\(url)", method: method, parameters: parameters, encoding: JSONEncoding.default, headers: self._headers()).responseJSON { response in
            switch response.result {
            case .success(let json):
                // get the status code
                guard let statusCode = response.response?.statusCode else { return responseHandler(nil, nil, APIError.UnknownError()) }
                
                // check if authorized
                if statusCode == 401 {
                    // try to refresh the access token
                    self._refreshToken(callback: { (error) in
                        if let error = error {
                            // send back the error
                            responseHandler(nil, nil, error)
                        } else {
                            // refresh successful - try again
                            self._request(url, method: method, parameters: parameters, responseHandler: responseHandler)
                        }
                    })
                } else {
                    // send back the status code and json data
                    responseHandler(statusCode, json, nil)
                }
            case .failure(_):
                // send back an unknown error
                responseHandler(nil, nil, APIError.UnknownError())
            }
        }
    }
    
    private func _refreshToken(callback: ((APIError?) -> Void)?) {
        if let token = self._token {
            let parameters = [
                "refresh_token": token.refreshToken,
                "grant_type": "refresh_token"
            ]
            let headers = [
                "Authorization": "Basic \(clientCredentials)",
                "Content-Type": "application/x-www-form-urlencoded",
                "Accept": "application/json"
            ]
            
            Alamofire.request("\(host)/oauth/token", method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { response in
                switch response.result {
                case .success(let json):
                    guard let statusCode = response.response?.statusCode else {
                        // send back an unknown error
                        callback?(APIError.UnknownError())
                        return
                    }
                    switch statusCode {
                    case 200:
                        // get the json
                        guard let json = json as? [String: AnyObject] else {
                            // send back an unknown error
                            callback?(APIError.UnknownError())
                            return
                        }
                        // set the token
                        self._token = CCToken(modelDictionary: json)
                        // get the account
                        self.getAccount(responseHandler: { (account, error) in
                            // send back the error if there is one
                            callback?(error)
                        })
                    case 401:
                        // user no longer has valid credentials - logout completely
                        self.logout()
                        // send unauthorized error
                        callback?(APIError.UnauthorizedError())
                    default:
                        // send back an unknown error
                        callback?(APIError.UnknownError())
                    }
                case .failure(_):
                    // send back an unknown error
                    callback?(APIError.UnknownError())
                }
            }
        } else {
            callback?(APIError.UnauthorizedError())
        }
    }
    
    func verifyPhone(phoneNumber: String, responseHandler: @escaping (String?, APIError?) -> Void) {
        let parameters = [
            "phone_number": phoneNumber
        ]
        
        self._request("/oauth/phone", method: .post, parameters: parameters) { (statusCode, json, error) in
            if let json = json as? [String: AnyObject] {
                // parse the phone number registered value
                guard let phoneNumberRegistered: Bool = json["phone_number_registered"] as? Bool else { return responseHandler(nil, APIError.UnknownError()) }
                if phoneNumberRegistered, let user = json["user"] as? [String: String] {
                    // if the phone number is registered send back the name of the user
                    responseHandler(user["first_name"], nil)
                } else {
                    // otherwise send a blank errorless response
                    responseHandler(nil, nil)
                }
            } else {
                // send back the error
                responseHandler(nil, error)
            }
        }
    }
    
    func login(phoneNumber: String, validationCode: String, responseHandler: @escaping (CCAccount?, APIError?) -> Void) {
        let parameters = [
            "phone_number": phoneNumber,
            "code": validationCode,
            "grant_type": "phone_token"
        ]
        let headers = [
            "Authorization": "Basic \(clientCredentials)",
            "Content-Type": "application/x-www-form-urlencoded",
            "Accept": "application/json"
        ]
        
        Alamofire.request("\(host)/oauth/token", method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let json):
                guard let statusCode = response.response?.statusCode else { return responseHandler(nil, APIError.UnknownError()) }
                switch statusCode {
                case 200:
                    // parse json
                    guard let json = json as? [String: AnyObject] else { return responseHandler(nil, APIError.UnknownError()) }
                    // set the token
                    self._token = CCToken(modelDictionary: json)
                    // get the account
                    self.getAccount(responseHandler: { (account, error) in
                        if let account = account {
                            // send a notification
                            NotificationCenter.default.post(name: .kCliqCardAPILoggedInNotification, object: nil)
                            // send back the account
                            responseHandler(account, nil)
                        } else {
                            // send back the error
                            responseHandler(nil, error)
                        }
                    })
                case 400:
                    // return an unauthorized error
                    responseHandler(nil, APIError.UnauthorizedError())
                default:
                    // return an unknown error
                    responseHandler(nil, APIError.UnknownError())
                }
            case .failure(_):
                // return an unknown error
                responseHandler(nil, APIError.UnknownError())
            }
        }
    }
    
    func register(phoneNumber: String, code: String, responseHandler: @escaping (String?, APIError?) -> Void) {
        let parameters = [
            "phone_number": phoneNumber,
            "code": code
        ]
        
        self._request("/oauth/register", method: .post, parameters: parameters) { (statusCode, json, error) in
            if let statusCode = statusCode, let json = json as? [String: AnyObject] {
                switch statusCode {
                case 200:
                    // get the registration token
                    guard let token = json["registration_token"] as? String else { return responseHandler(nil, APIError.UnknownError()) }
                    // return the token
                    responseHandler(token, nil)
                case 400:
                    // get the error message
                    guard let message = json["message"] as? String else { return responseHandler(nil, APIError.UnknownError()) }
                    // return an invalid request error
                    responseHandler(nil, APIError.InvalidRequestError(message: message))
                default:
                    // return an unknown error
                    responseHandler(nil, APIError.UnknownError())
                }
            } else {
                // send back the error
                responseHandler(nil, error)
            }
        }
    }
    
    func logout() {
        // null the current user and token
        _currentUser = nil
        _token = nil
        
        // send a notification
        NotificationCenter.default.post(name: .kCliqCardAPILoggedOutNotification, object: nil)
    }
    
    func getAccount(responseHandler: ((CCAccount?, APIError?) -> Void)?) {
        self._request("/account", method: .get, parameters: nil) { (statusCode, json, error) in
            if let statusCode = statusCode, let json = json as? [String: AnyObject] {
                if statusCode == 200 {
                    // serialize account model
                    let user = CCAccount(modelDictionary: json)
                    // set the current user
                    self._currentUser = user
                    // send the new user back
                    responseHandler?(user, nil)
                } else {
                    // send back an unknown error
                    responseHandler?(nil, APIError.UnknownError())
                }
            } else {
                // send back the error
                responseHandler?(nil, error)
            }
        }
    }
    
    func createAccount(phoneNumber: String, token: String, firstName: String, lastName: String, email: String?, responseHandler: @escaping (CCAccount?, APIError?) -> Void) {
        let parameters: Parameters = [
            "client_id": clientId,
            "client_secret": clientSecret,
            "phone_number": phoneNumber,
            "registration_token": token,
            "first_name": firstName,
            "last_name": lastName,
            "email": email ?? NSNull()
        ]
        
        self._request("/account", method: .post, parameters: parameters) { (statusCode, json, error) in
            if let statusCode = statusCode, let json = json as? [String: AnyObject] {
                switch statusCode {
                case 201:
                    // extract the token and user json
                    guard let tokenJson = json["token"] as? [String: AnyObject] else { return responseHandler(nil, APIError.UnknownError()) }
                    guard let accountJson = json["user"] as? [String: AnyObject] else { return responseHandler(nil, APIError.UnknownError()) }
                    // serialize and save
                    self._token = CCToken(modelDictionary: tokenJson)
                    self._currentUser = CCAccount(modelDictionary: accountJson)
                    // send a notification
                    NotificationCenter.default.post(name: .kCliqCardAPILoggedInNotification, object: nil)
                    // return the account
                    responseHandler(self._currentUser, nil)
                case 400:
                    // get the message
                    guard let message = json["message"] as? String else { return responseHandler(nil, APIError.UnknownError()) }
                    // return an invalid request error
                    responseHandler(nil, APIError.InvalidRequestError(message: message))
                case 401:
                    // return an unauthorized error
                    responseHandler(nil, APIError.UnauthorizedError())
                default:
                    // return an unknown error
                    responseHandler(nil, APIError.UnknownError())
                }
            } else {
                // return the error
                responseHandler(nil, error)
            }
        }
    }
    
    func updateAccount(account: CCAccount, responseHandler: @escaping (CCAccount?, APIError?) -> Void) {
        let parameters: Parameters = [
            "first_name": account.firstName,
            "last_name": account.lastName
        ]
        
        self._request("/account", method: .put, parameters: parameters) { (statusCode, json, error) in
            if let statusCode = statusCode, let json = json as? [String: AnyObject] {
                if statusCode == 200 {
                    // serialize the new account
                    let account = CCAccount(modelDictionary: json)
                    // set the current user
                    self._currentUser = account
                    // execute the callback
                    responseHandler(account, nil)
                } else {
                    // send back an unknown error
                    responseHandler(nil, APIError.UnknownError())
                }
            } else {
                // send back the error
                responseHandler(nil, error)
            }
        }
    }
    
    func uploadProfilePicture(image: UIImage, responseHandler: @escaping (CCAccount?, APIError?) -> Void) {
        // make sure we have an access token
        guard let accessToken = self._token?.accessToken else {
            responseHandler(nil, APIError.NullTokenError())
            return
        }
        
        // get image data as jpeg
        guard let imageData = UIImageJPEGRepresentation(image, 0.4) else {
            responseHandler(nil, APIError.UnknownError())
            return
        }
        
        // specify the upload url and headers
        let url = "\(host)/account/picture"
        let headers: HTTPHeaders = [
            "Content-Type": "multipart/form-data",
            "Accept": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        // upload
        Alamofire.upload(multipartFormData: { multipartFormData in
            // append the image data with the name 'file'
            multipartFormData.append(imageData, withName: "file", fileName: "file.jpg", mimeType: "image/jpeg")
        }, usingThreshold: UInt64.init(), to: url, method: .post, headers: headers) { result in
            switch result {
            case .success(let upload, _, _):
                upload.responseJSON(completionHandler: { response in
                    // get the status code and json data
                    if let statusCode = response.response?.statusCode, let json = response.value as? [String: AnyObject], statusCode == 200 {
                        // serialize the new account
                        let account = CCAccount(modelDictionary: json)
                        // set the current user
                        self._currentUser = account
                        // execute the callback
                        responseHandler(account, nil)
                    } else {
                        // send back an unknown error
                        responseHandler(nil, APIError.UnknownError())
                    }
                })
            case .failure(_):
                // send back an unknown error
                responseHandler(nil, APIError.UnknownError())
            }
        }
    }
    
    func removeProfilePicture(responseHandler: @escaping (CCAccount?, APIError?) -> Void) {
        self._request("/account/picture", method: .delete, parameters: nil) { (statusCode, json, error) in
            if let statusCode = statusCode, let json = json as? [String: AnyObject], statusCode == 200 {
                // serialize the new account
                let account = CCAccount(modelDictionary: json)
                // set the current user
                self._currentUser = account
                // execute the callback
                responseHandler(account, nil)
            } else {
                // send back an unknown error
                responseHandler(nil, APIError.UnknownError())
            }
        }
    }
    
    func getPhones(responseHandler: @escaping ([CCPhone]?, APIError?) -> Void) {
        self._request("/phones", method: .get, parameters: nil) { (statusCode, json, error) in
            if let statusCode = statusCode, let json = json as? [[String: AnyObject]] {
                if statusCode == 200 {
                    // serialize the phones
                    let phones = json.map({ phoneJson -> CCPhone in
                        return CCPhone(modelDictionary: phoneJson)
                    })
                    // send back the phone list
                    responseHandler(phones, nil)
                } else {
                    // send back an unknown error
                    responseHandler(nil, APIError.UnknownError())
                }
            } else {
                // send back the error
                responseHandler(nil, error)
            }
        }
    }
    
    func createPhone(type: String, number: String, ext: String?, responseHandler: @escaping (CCPhone?, APIError?) -> Void) {
        let parameters: Parameters = [
            "type": type,
            "number": number,
            "extension": ext ?? NSNull()
        ]
        
        self._request("/phones", method: .post, parameters: parameters) { (statusCode, json, error) in
            if let statusCode = statusCode, let json = json as? [String: AnyObject] {
                if statusCode == 200 {
                    // serialize the phone
                    let phone = CCPhone(modelDictionary: json)
                    // send back the phone
                    responseHandler(phone, nil)
                } else {
                    // send back an unknown error
                    responseHandler(nil, APIError.UnknownError())
                }
            } else {
                // send back the error
                responseHandler(nil, error)
            }
        }
    }
    
    func updatePhone(phone: CCPhone, responseHandler: @escaping (CCPhone?, APIError?) -> Void) {
        let parameters: Parameters = [
            "number": phone.number,
            "extension": phone.extension ?? NSNull()
        ]
        
        self._request("/phones/\(phone.identifier)", method: .put, parameters: parameters) { (statusCode, json, error) in
            if let statusCode = statusCode, let json = json as? [String: AnyObject] {
                if statusCode == 200 {
                    // serialize the phone
                    let phone = CCPhone(modelDictionary: json)
                    // send back the phone
                    responseHandler(phone, nil)
                } else {
                    // send back an unknown error
                    responseHandler(nil, APIError.UnknownError())
                }
            } else {
                // send back the error
                responseHandler(nil, error)
            }
        }
    }
    
    func deletePhone(phone: CCPhone, responseHandler: @escaping (APIError?) -> Void) {
        self._request("/phones/\(phone.identifier)", method: .delete, parameters: nil) { (statusCode, json, error) in
            if let statusCode = statusCode {
                if statusCode == 204 {
                    // send back success
                    responseHandler(nil)
                } else {
                    // send back an unknown error
                    responseHandler(APIError.UnknownError())
                }
            } else {
                // send back the error
                responseHandler(error)
            }
        }
    }
    
    func getEmails(responseHandler: @escaping ([CCEmail]?, APIError?) -> Void) {
        self._request("/emails", method: .get, parameters: nil) { (statusCode, json, error) in
            if let statusCode = statusCode, let json = json as? [[String: AnyObject]] {
                if statusCode == 200 {
                    // serialize the emails
                    let emails = json.map({ emailJson -> CCEmail in
                        return CCEmail(modelDictionary: emailJson)
                    })
                    // send back the email list
                    responseHandler(emails, nil)
                } else {
                    // send back an unknown error
                    responseHandler(nil, APIError.UnknownError())
                }
            } else {
                // send back the error
                responseHandler(nil, error)
            }
        }
    }
    
    func createEmail(type: String, address: String, responseHandler: @escaping (CCEmail?, APIError?) -> Void) {
        let parameters: Parameters = [
            "type": type,
            "address": address
        ]
        
        self._request("/emails", method: .post, parameters: parameters) { (statusCode, json, error) in
            if let statusCode = statusCode, let json = json as? [String: AnyObject] {
                if statusCode == 200 {
                    // serialize the email
                    let email = CCEmail(modelDictionary: json)
                    // send back the email
                    responseHandler(email, nil)
                } else {
                    // send back an unknown error
                    responseHandler(nil, APIError.UnknownError())
                }
            } else {
                // send back the error
                responseHandler(nil, error)
            }
        }
    }
    
    func updateEmail(email: CCEmail, responseHandler: @escaping (CCEmail?, APIError?) -> Void) {
        let parameters: Parameters = [
            "address": email.address
        ]
        
        self._request("/emails/\(email.identifier)", method: .put, parameters: parameters) { (statusCode, json, error) in
            if let statusCode = statusCode, let json = json as? [String: AnyObject] {
                if statusCode == 200 {
                    // serialize the email
                    let email = CCEmail(modelDictionary: json)
                    // send back the email
                    responseHandler(email, nil)
                } else {
                    // send back an unknown error
                    responseHandler(nil, APIError.UnknownError())
                }
            } else {
                // send back the error
                responseHandler(nil, error)
            }
        }
    }
    
    func deleteEmail(email: CCEmail, responseHandler: @escaping (APIError?) -> Void) {
        self._request("/emails/\(email.identifier)", method: .delete, parameters: nil) { (statusCode, json, error) in
            if let statusCode = statusCode {
                if statusCode == 204 {
                    // send back success
                    responseHandler(nil)
                } else {
                    // send back an unknown error
                    responseHandler(APIError.UnknownError())
                }
            } else {
                // send back the error
                responseHandler(error)
            }
        }
    }
    
    func getGroups(responseHandler: @escaping ([CCGroup]?, APIError?) -> Void) {
        self._request("/groups", method: .get, parameters: nil) { (statusCode, json, error) in
            if let statusCode = statusCode, let json = json as? [[String: AnyObject]] {
                if statusCode == 200 {
                    // serialize the groups
                    let groups = json.map({ groupJson -> CCGroup in
                        return CCGroup(modelDictionary: groupJson)
                    })
                    // send back the group list
                    responseHandler(groups, nil)
                } else {
                    // send back an unknown error
                    responseHandler(nil, APIError.UnknownError())
                }
            } else {
                // send back the error
                responseHandler(nil, error)
            }
        }
    }
    
    func getGroup(id: Int, responseHandler: @escaping (CCGroup?, APIError?) -> Void) {
        self._request("/groups/\(id)", method: .get, parameters: nil) { (statusCode, json, error) in
            if let statusCode = statusCode, let json = json as? [String: AnyObject] {
                switch statusCode {
                case 200:
                    // serialize the group
                    let group = CCGroup(modelDictionary: json)
                    // return the group
                    responseHandler(group, nil)
                case 404:
                    // send back an unauthorized error
                    responseHandler(nil, APIError.UnauthorizedError())
                default:
                    // send back an unknown error
                    responseHandler(nil, APIError.UnknownError())
                }
            } else {
                // send back the error
                responseHandler(nil, error)
            }
        }
    }
    
    func getGroupSharing(id: Int, responseHandler: @escaping ([CCPhone]?, [CCEmail]?, APIError?) -> Void) {
        self._request("/groups/\(id)/sharing", method: .get, parameters: nil) { (statusCode, json, error) in
            if let statusCode = statusCode, let json = json as? [String: AnyObject] {
                switch statusCode {
                case 200:
                    // serialize
                    let result = JSON(json)
                    guard let phones = (result["phones"].arrayObject as? [[String: AnyObject]])?.map({ phoneJson -> CCPhone in
                        return CCPhone(modelDictionary: phoneJson)
                    }), let emails = (result["emails"].arrayObject as? [[String: AnyObject]])?.map({ emailJson -> CCEmail in
                        return CCEmail(modelDictionary: emailJson)
                    }) else {
                        responseHandler(nil, nil, APIError.UnknownError())
                        return
                    }
                    // return the phones and emails
                    responseHandler(phones, emails, nil)
                case 404:
                    // send back an unauthorized error
                    responseHandler(nil, nil, APIError.UnauthorizedError())
                default:
                    // send back an unknown error
                    responseHandler(nil, nil, APIError.UnknownError())
                }
            } else {
                // send back the error
                responseHandler(nil, nil, error)
            }
        }
    }
    
    func createGroup(name: String, phoneIds: [Int], emailIds: [Int], responseHandler: @escaping (CCGroup?, APIError?) -> Void) {
        let parameters: Parameters = [
            "name": name,
            "phone_ids": phoneIds,
            "email_ids": emailIds
        ]
        
        self._request("/groups", method: .post, parameters: parameters) { (statusCode, json, error) in
            if let statusCode = statusCode, let json = json as? [String: AnyObject] {
                switch statusCode {
                case 200:
                    // serialize the group
                    let group = CCGroup(modelDictionary: json)
                    // return the group
                    responseHandler(group, nil)
                case 400:
                    // send back an invalid error
                    responseHandler(nil, APIError.InvalidRequestError(message: "Invalid request"))
                case 401:
                    // send back an unauthorized error
                    responseHandler(nil, APIError.UnauthorizedError())
                default:
                    // send back an unknown error
                    responseHandler(nil, APIError.UnknownError())
                }
            } else {
                // send back the error
                responseHandler(nil, error)
            }
        }
    }
    
    func updateGroup(group: CCGroup, phoneIds: [Int], emailIds: [Int], responseHandler: @escaping (CCGroup?, APIError?) -> Void) {
        let parameters: Parameters = [
            "name": group.name,
            "phone_ids": phoneIds,
            "email_ids": emailIds
        ]
        
        self._request("/groups/\(group.identifier)", method: .put, parameters: parameters) { (statusCode, json, error) in
            if let statusCode = statusCode, let json = json as? [String: AnyObject] {
                switch statusCode {
                case 200:
                    // serialize the group
                    let group = CCGroup(modelDictionary: json)
                    // return the group
                    responseHandler(group, nil)
                case 404:
                    // send back an unauthorized error
                    responseHandler(nil, APIError.UnauthorizedError())
                default:
                    // send back an unknown error
                    responseHandler(nil, APIError.UnknownError())
                }
            } else {
                // send back the error
                responseHandler(nil, error)
            }
        }
    }
    
    func deleteGroup(group: CCGroup, responseHandler: @escaping (APIError?) -> Void) {
        self._request("/groups/\(group.identifier)", method: .delete, parameters: nil) { (statusCode, json, error) in
            switch statusCode {
            case 204:
                // return success
                responseHandler(nil)
            case 401:
                // return unauthorized error (most likely not group admin)
                responseHandler(APIError.UnauthorizedError())
            default:
                // send back an unknown error
                responseHandler(APIError.UnknownError())
            }
        }
    }
    
    func uploadGroupPicture(groupId: Int, image: UIImage, responseHandler: @escaping (CCGroup?, APIError?) -> Void) {
        // make sure we have an access token
        guard let accessToken = self._token?.accessToken else {
            responseHandler(nil, APIError.NullTokenError())
            return
        }
        
        // get image data as jpeg
        guard let imageData = UIImageJPEGRepresentation(image, 0.4) else {
            responseHandler(nil, APIError.UnknownError())
            return
        }
        
        // specify the upload url and headers
        let url = "\(host)/groups/\(groupId)/picture"
        let headers: HTTPHeaders = [
            "Content-Type": "multipart/form-data",
            "Accept": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        // upload
        Alamofire.upload(multipartFormData: { multipartFormData in
            // append the image data with the name 'file'
            multipartFormData.append(imageData, withName: "file", fileName: "file.jpg", mimeType: "image/jpeg")
        }, usingThreshold: UInt64.init(), to: url, method: .post, headers: headers) { result in
            switch result {
            case .success(let upload, _, _):
                upload.responseJSON(completionHandler: { response in
                    // get the status code and json data
                    if let statusCode = response.response?.statusCode, let json = response.value as? [String: AnyObject] {
                        switch statusCode {
                        case 200:
                            // serialize the new group
                            let group = CCGroup(modelDictionary: json)
                            // execute the callback
                            responseHandler(group, nil)
                        case 404:
                            // send back an unauthorized error
                            responseHandler(nil, APIError.UnauthorizedError())
                        case 401:
                            // send back an unauthorized error
                            responseHandler(nil, APIError.UnauthorizedError())
                        default:
                            // send back an unknown error
                            responseHandler(nil, APIError.UnknownError())
                        }
                    } else {
                        // send back an unknown error
                        responseHandler(nil, APIError.UnknownError())
                    }
                })
            case .failure(_):
                // send back an unknown error
                responseHandler(nil, APIError.UnknownError())
            }
        }
    }
    
    func removeGroupPicture(groupId: Int, responseHandler: @escaping (CCGroup?, APIError?) -> Void) {
        self._request("/groups/\(groupId)/picture", method: .delete, parameters: nil) { (statusCode, json, error) in
            if let statusCode = statusCode, let json = json as? [String: AnyObject] {
                switch statusCode {
                case 200:
                    // serialize the new group
                    let group = CCGroup(modelDictionary: json)
                    // execute the callback
                    responseHandler(group, nil)
                case 401:
                    // send back an unauthorized error
                    responseHandler(nil, APIError.UnauthorizedError())
                case 404:
                    // send back an unauthorized error
                    responseHandler(nil, APIError.UnauthorizedError())
                default:
                    // send back an unknown error
                    responseHandler(nil, APIError.UnknownError())
                }
            } else {
                // send back the error
                responseHandler(nil, error)
            }
        }
    }
    
    func getGroupMembers(id: Int, responseHandler: @escaping ([CCContact]?, APIError?) -> Void) {
        self._request("/groups/\(id)/members", method: .get, parameters: nil) { (statusCode, json, error) in
            if let statusCode = statusCode, let json = json as? [[String: AnyObject]] {
                if statusCode == 200 {
                    // serialize the members
                    let members = json.map({ memberJson -> CCContact in
                        return CCContact(modelDictionary: memberJson)
                    })
                    // send back the member list
                    responseHandler(members, nil)
                } else {
                    // send back an unknown error
                    responseHandler(nil, APIError.UnknownError())
                }
            } else {
                // send back the error
                responseHandler(nil, error)
            }
        }
    }
    
    func getGroupCode(id: Int, responseHandler: @escaping (String?, APIError?) -> Void) {
        self._request("/groups/\(id)/code", method: .get, parameters: nil) { (statusCode, json, error) in
            if let statusCode = statusCode, let json = json as? [String: AnyObject] {
                switch statusCode {
                case 200:
                    // convert the json
                    let result = JSON(json)
                    // get the code
                    guard let code = result["join_code"]["code"].string else { return responseHandler(nil, APIError.UnknownError()) }
                    // send back the code
                    responseHandler(code, nil)
                case 404:
                    // send back an unauthorized error
                    responseHandler(nil, APIError.UnauthorizedError())
                default:
                    // send back an unknown error
                    responseHandler(nil, APIError.UnknownError())
                }
            } else {
                // send back the error
                responseHandler(nil, error)
            }
        }
    }
    
    func joinGroup(code: String, phoneIds: [Int], emailIds: [Int], responseHandler: @escaping (CCGroup?, APIError?) -> Void) {
        let parameters: Parameters = [
            "join_code": code.uppercased(),
            "phone_ids": phoneIds,
            "email_ids": emailIds
        ]
        
        self._request("/groups/join", method: .post, parameters: parameters) { (statusCode, json, error) in
            if let statusCode = statusCode, let json = json as? [String: AnyObject] {
                switch statusCode {
                case 200:
                    // serialize the group
                    let group = CCGroup(modelDictionary: json)
                    // call the response handler
                    responseHandler(group, nil)
                case 400:
                    // send back an invalid request error
                    responseHandler(nil, APIError.InvalidRequestError(message: "Invalid join code"))
                default:
                    // send back an unknown error
                    responseHandler(nil, APIError.UnknownError())
                }
            } else {
                // send back the error
                responseHandler(nil, error)
            }
        }
    }
    
    func leaveGroup(id: Int, responseHandler: @escaping (APIError?) -> Void) {
        self._request("/groups/\(id)/leave", method: .post, parameters: nil) { (statusCode, json, error) in
            if let statusCode = statusCode {
                if statusCode == 204 {
                    // all good - send back nothing
                    responseHandler(nil)
                } else {
                    // send back an unknown error
                    responseHandler(APIError.UnknownError())
                }
            } else {
                // return the error
                responseHandler(error)
            }
        }
    }
    
    func getContacts(responseHandler: @escaping ([CCContact]?, APIError?) -> Void) {
        self._request("/contacts/", method: .get, parameters: nil) { (statusCode, json, error) in
            if let statusCode = statusCode, let json = json as? [[String: AnyObject]] {
                if statusCode == 200 {
                    // serialize the contacts
                    let contacts = json.map({ contactJson -> CCContact in
                        return CCContact(modelDictionary: contactJson)
                    })
                    // send back the contact list
                    responseHandler(contacts, nil)
                } else {
                    // send back an unknown error
                    responseHandler(nil, APIError.UnknownError())
                }
            } else {
                // send back the error
                responseHandler(nil, error)
            }
        }
    }
    
    func getContact(id: Int, responseHandler: @escaping (CCContact?, APIError?) -> Void) {
        self._request("/contacts/\(id)", method: .get, parameters: nil) { (statusCode, json, error) in
            if let statusCode = statusCode, let json = json as? [String: AnyObject] {
                if statusCode == 200 {
                    // serialize the contact
                    let contact = CCContact(modelDictionary: json)
                    // send back the contact
                    responseHandler(contact, nil)
                } else {
                    // send back an unknown error
                    responseHandler(nil, APIError.UnknownError())
                }
            } else {
                // send back the error
                responseHandler(nil, error)
            }
        }
    }
    
}

extension Notification.Name {
    
    static let kCliqCardAPILoggedInNotification = Notification.Name("kCliqCardAPILoggedInNotification")
    static let kCliqCardAPILoggedOutNotification = Notification.Name("kCliqCardAPILoggedOutNotification")
    
}
