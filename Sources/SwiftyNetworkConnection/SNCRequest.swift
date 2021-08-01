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
    
    public func connect(body: SNCBody,
                        httpMethod: SNCHttpMethods = .get ,
                        callback: @escaping(Result<SNCResponse, APIError>) -> Void) {
        do {
            var request = URLRequest(url: url)
            request.httpMethod = httpMethod.rawValue
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONEncoder().encode(body)
            let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let resp = response as? HTTPURLResponse, resp.statusCode == 200,
                      let jsonData = data else {
                    callback(.failure(.reponseError))
                    return
                }
                do {
                    let data = try JSONDecoder().decode(SNCResponse.self, from: jsonData)
                    callback(.success(data))
                } catch {
                    callback(.failure(.decodingError))
                }
            }
            dataTask.resume()
        } catch {
            callback(.failure(.encodingError))
        }
    }
    
}
