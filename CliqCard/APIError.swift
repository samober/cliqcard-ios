//
//  APIError.swift
//  CliqCard
//
//  Created by Sam Ober on 7/7/18.
//  Copyright © 2018 Sam Ober. All rights reserved.
//

import Foundation

enum APIError: Error {
    case UnauthorizedError()
    case UnknownError()
    case NullTokenError()
    case InvalidRequestError(message: String)
}
