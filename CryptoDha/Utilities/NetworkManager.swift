//
//  NetworkManager.swift
//  CryptoDha
//
//  Created by Rosh on 26/04/26.
//

import Foundation
import Combine

class NetworkManager {
    
    enum NetworkError: Error {
        case clientSideError(String)
        case serverError
        case unknown
        
        var errorDescription: String {
            switch self {
            case .clientSideError(let error):
                return "StatusCode: 400. Client side error: \(error)"
            case .serverError:
                return "Internal server error!"
            case .unknown:
                return "Unknown error occured!"
            }
        }
    }
    
    static func download(url: URLRequest) -> AnyPublisher<Data, Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .tryMap { (output) -> Data in
                guard let response = output.response as? HTTPURLResponse else {
                    throw NetworkError.serverError
                }
                
                if !(200...299).contains(response.statusCode) {
                    let body = String(data: output.data, encoding: .utf8)
                    throw NetworkError.clientSideError(body ?? "")
                }
#if DEBUG
                if let json = String(data: output.data, encoding: .utf8) {
                    print("✅ JSON:", json)
                }
#endif
                return output.data
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
}


