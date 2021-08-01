//
//  SNCRequest.swift
//  SwiftyNetworkConnection
//
//  Created by shndrs on 8/1/21.
//

import Foundation

public class SNCRequest: NSObject {
    
    private let url: URL
    
    public init(url: String) {
        guard let baseUrl = URL(string: url) else { fatalError("Failed Fetching url") }
        self.url = baseUrl
    }
    
    public func connect(object: Codable,
                        httpMethod: SNCHttpMethods = .get ,
                        callback: @escaping(Result<Codable, APIError>) -> Void) {
        do {
            var request = URLRequest(url: url)
            
        }
    }
    
}
