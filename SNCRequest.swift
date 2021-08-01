//
//  SNCRequest.swift
//  SwiftyNetworkConnection
//
//  Created by shndrs on 8/1/21.
//

import Foundation

open class SNCRequest: NSObject {
    
    private let url: URL
    
    public init(url: String) {
        guard let baseUrl = URL(string: url) else {
            fatalError("Failed Fetching url")
        }
        self.url = baseUrl
    }
    
}

// MARK: - Methods

extension SNCRequest {
    
    public func connect(body: SNCBody? = nil,
                        httpMethod: SNCHttpMethods = .get,
                        callback: @escaping(Result<SNCResponse, APIError>) -> Void) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            do {
                var request = URLRequest(url: self.url)
                request.httpMethod = httpMethod.rawValue
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpBody = try JSONEncoder().encode(body)
                URLSession.shared.dataTask(with: request) { data, response, error in
                    guard let resp = response as? HTTPURLResponse, resp.statusCode == 200,
                          let jsonData = data else {
                        callback(.failure(.reponseError))
                        return
                    }
                    do {
                        let data = try JSONDecoder().decode(SNCResponse.self, from: jsonData)
                        DispatchQueue.main.async {
                            callback(.success(data))
                        }
                    } catch {
                        DispatchQueue.main.async {
                            callback(.failure(.decodingError))
                        }
                    }
                }.resume()
            } catch {
                DispatchQueue.main.async {
                    callback(.failure(.encodingError))
                }
            }
        }
    }
    
}
