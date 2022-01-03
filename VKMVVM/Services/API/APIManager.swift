//
//  APIManager.swift
//  VKMVVM
//
//  Created by Антон Кочетков on 15.12.2021.
//

import Foundation

typealias Parametrs = [String: String]

protocol Networing {
    func request(path: APIMethods, params: Parametrs, completion: @escaping (Data?, Error?) -> Void)
}

class APIManager: Networing {
    
    static let shader = APIManager()
    
    func request(path: APIMethods, params: Parametrs, completion: @escaping (Data?, Error?) -> Void) {
        guard let token = AuthService.shared.token else { return }
        var allParams = params
        allParams["access_token"] = token
        allParams["v"] = API.version
        let url = createURL(from: path, params: allParams)
        
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard error == nil else {
                completion(nil, error!)
                return
            }
            if let data = data {
                completion(data, nil)
            } else {
                completion(nil, nil) //TODO: создать ошибку для отсутсвия данных
            }
        }
        
        task.resume()
    }
    
    private func createURL(from method: APIMethods, params: Parametrs) -> URL {
        var componentsURL = URLComponents()
        componentsURL.scheme = API.scheme
        componentsURL.host = API.host
        componentsURL.path = method.path
        componentsURL.queryItems = params.map { URLQueryItem(name: $0, value: $1) }
        
        return componentsURL.url!
    }
    
}
