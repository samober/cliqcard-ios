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

final class CliqCardAPI {
    
    enum APIError: Error {
        case UnauthorizedError()
        case UnknownError()
        case NullTokenError()
        case InvalidRequestError(message: String)
    }
    
    static let shared = CliqCardAPI()
    
    let host = "https://api.getcliqcard.com"
    let clientId = "ai8fg37aorshflawehoiufhadaiowhuf"
    let clientSecret = "awfkiuhuosrgfliusdhfisuherugyhasdkljfhawoieufaklsd"
    
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
    
    func updateAccount(firstName: String, lastName: String, email: String?, phoneNumber: String, responseHandler: @escaping (CCAccount?, APIError?) -> Void) {
        let parameters: Parameters = [
            "first_name": firstName,
            "last_name": lastName,
            "email": email ?? NSNull(),
            "phone_number": phoneNumber
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
    
    func getCards(responseHandler: @escaping (CCPersonalCard?, CCWorkCard?, APIError?) -> Void) {
        self._request("/cards", method: .get, parameters: nil) { (statusCode, json, error) in
            if let statusCode = statusCode, let json = json as? [String: [String: AnyObject]] {
                if statusCode == 200 {
                    // extract the cards
                    guard let personalJson = json["personal"] else { return responseHandler(nil, nil, APIError.UnknownError()) }
                    guard let workJson = json["work"] else { return responseHandler(nil, nil, APIError.UnknownError()) }
                    // serialize the cards
                    let personalCard = CCPersonalCard(modelDictionary: personalJson)
                    let workCard = CCWorkCard(modelDictionary: workJson)
                    // send back the cards
                    responseHandler(personalCard, workCard, nil)
                } else {
                    // send back an unknown error
                    responseHandler(nil, nil, APIError.UnknownError())
                }
            } else {
                // send back the error
                responseHandler(nil, nil, error)
            }
        }
    }
    
    func getPersonalCard(responseHandler: @escaping (CCPersonalCard?, APIError?) -> Void) {
        self._request("/cards/personal", method: .get, parameters: nil) { (statusCode, json, error) in
            if let statusCode = statusCode, let json = json as? [String: AnyObject] {
                if statusCode == 200 {
                    // serialize the card
                    let card = CCPersonalCard(modelDictionary: json)
                    // send back the card
                    responseHandler(card, nil)
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
    
    func getWorkCard(responseHandler: @escaping (CCWorkCard?, APIError?) -> Void) {
        self._request("/cards/work", method: .get, parameters: nil) { (statusCode, json, error) in
            if let statusCode = statusCode, let json = json as? [String: AnyObject] {
                if statusCode == 200 {
                    // serialize the card
                    let card = CCWorkCard(modelDictionary: json)
                    // send back the card
                    responseHandler(card, nil)
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
    
    func updatePersonalCard(personalCard: CCPersonalCard, responseHandler: @escaping (CCPersonalCard?, APIError?) -> Void) {
        let parameters: Parameters = [
            "cell_phone": personalCard.cellPhone ?? NSNull(),
            "home_phone": personalCard.homePhone ?? NSNull(),
            "email": personalCard.email ?? NSNull()
        ]
        
        self._request("/cards/personal", method: .put, parameters: parameters) { (statusCode, json, error) in
            if let statusCode = statusCode, let json = json as? [String: AnyObject] {
                if statusCode == 200 {
                    // serialize the card
                    let card = CCPersonalCard(modelDictionary: json)
                    // send back the card
                    responseHandler(card, nil)
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
    
    func updateWorkCard(workCard: CCWorkCard, responseHandler: @escaping (CCWorkCard?, APIError?) -> Void) {
        let parameters: Parameters = [
            "office_phone": workCard.officePhone ?? NSNull(),
            "email": workCard.email ?? NSNull()
        ]
        
        self._request("/cards/work", method: .put, parameters: parameters) { (statusCode, json, error) in
            if let statusCode = statusCode, let json = json as? [String: AnyObject] {
                if statusCode == 200 {
                    // serialize the card
                    let card = CCWorkCard(modelDictionary: json)
                    // send back the card
                    responseHandler(card, nil)
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
            if let statusCode = statusCode, let json = json as? [String: [String: String]] {
                switch statusCode {
                case 200:
                    // get the code
                    guard let code = json["join_code"]?["code"] else { return responseHandler(nil, APIError.UnknownError()) }
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
    
}

extension Notification.Name {
    
    static let kCliqCardAPILoggedInNotification = Notification.Name("kCliqCardAPILoggedInNotification")
    static let kCliqCardAPILoggedOutNotification = Notification.Name("kCliqCardAPILoggedOutNotification")
    
}
