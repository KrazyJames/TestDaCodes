//
//  MoviesRouter.swift
//  TestDaCodes
//
//  Created by Jaime Escobar on 09/11/20.
//

import Foundation
import Alamofire

enum MovieRouter: URLRequestConvertible {
    case getPlayingNow(page: Int)
    case getMovieDetails(id: Int)
    
    var method: HTTPMethod {
        switch self {
        case .getPlayingNow:
            return .get
        case .getMovieDetails:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .getPlayingNow:
            return "/movie/now_playing/"
        case .getMovieDetails(let id):
            return "/movie/\(id)"
        }
    }
    
    var parameters: [String: Any] {
        var params: [String: Any] = [HTTPHeadersField.apiKey.rawValue : APIManager.apiKey]
        switch self {
        case .getPlayingNow(let page):
            params.updateValue(page, forKey: "page")
            return params
        default:
            return params
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try APIManager.urlBase.asURL()
        var urlRequest = try URLRequest(url: url.appendingPathComponent(path),
            method: method)
        urlRequest.httpMethod = method.rawValue
        urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        print(urlRequest)
        return urlRequest
    }
}
