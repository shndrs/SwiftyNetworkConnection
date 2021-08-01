//
//  APIError.swift
//  SwiftyNetworkConnection
//
//  Created by shndrs on 8/1/21.
//

import Foundation

enum APIError: Error {
    case reponseError
    case decodingError
    case unknownError
}
