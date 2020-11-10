//
//  ServiceRequester.swift
//  TestDaCodes
//
//  Created by Jaime Escobar on 09/11/20.
//

import Foundation
import Alamofire

final class ServiceRequester {
    class func request<T: Decodable>(router: URLRequestConvertible,
                                     completion: @escaping(Swift.Result<T, NetworkError>) -> Void) {
        AF.request(router).responseJSON { result in
            
            guard let data = result.data else {
                return completion(.failure(.noData))
            }
            
            do {
                print(data)
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let responseObject = try decoder.decode(T.self, from: data)
                print(responseObject)
                return completion(.success(responseObject))
            } catch {
                do {
                    let responseError = try JSONDecoder().decode(ResponseError.self, from: data)
                    return completion(.failure(.serverError(error: responseError)))
                } catch {
                    return completion(.failure(.invalidJSON(error)))
                }
            }
        }
    }
}
