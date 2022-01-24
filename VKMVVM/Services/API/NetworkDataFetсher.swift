//
//  NetworkDataFetсher.swift
//  VKMVVM
//
//  Created by Антон Кочетков on 22.01.2022.
//

import Foundation

protocol DataFetcher {
    func getNewsFeed(startFrom: String?, paramsFilter: [NewsFeedFiltersParams], completion: @escaping (Result<NewsFeedResponseWrapped, Error>) -> Void)
    func getProfileInfo(userId: String?, fieldsParams: [UserRequestFieldsParams], completion: @escaping (Result<UserResponseWrapper, Error>) -> Void)
    func getFriends(userId: String?, fieldsParams: [FriendsRequestFieldsParams], orderParams: FriendsRequestOrderParams?, completion: @escaping (Result<FriendsResponseWrapper, Error>) -> Void)
}

struct NetworkDataFetcher: DataFetcher {
    func getNewsFeed(startFrom: String?, paramsFilter: [NewsFeedFiltersParams], completion: @escaping (Result<NewsFeedResponseWrapped, Error>) -> Void) {
        var params = [NewsFeedParams.filters.rawValue: NewsFeedFiltersParams.params(paramsFilter)]
        if let startFrom = startFrom {
            params[NewsFeedParams.startFrom.rawValue] = startFrom
        }
        makeRequest(path: .getNewsFeed, params: params, response: NewsFeedResponseWrapped.self, completion: completion)
    }
    
    func getProfileInfo(userId: String?, fieldsParams: [UserRequestFieldsParams], completion: @escaping (Result<UserResponseWrapper, Error>) -> Void) {
        var params = [UserRequestParams.fields.rawValue: UserRequestFieldsParams.params(fieldsParams)]
        if let userId = userId {
            params[UserRequestParams.userIds.rawValue] = userId
        }
        makeRequest(path: .getUsers, params: params, response: UserResponseWrapper.self, completion: completion)
    }
    
    func getFriends(userId: String?, fieldsParams: [FriendsRequestFieldsParams], orderParams: FriendsRequestOrderParams?, completion: @escaping (Result<FriendsResponseWrapper, Error>) -> Void) {
        var params = [FriendsRequestParams.fields.rawValue: FriendsRequestFieldsParams.params(fieldsParams)]
        if let userId = userId {
            params[FriendsRequestParams.userId.rawValue] = userId
        }
        if let orderParams = orderParams {
            params[FriendsRequestParams.order.rawValue] = orderParams.rawValue
        }
        makeRequest(path: .getFriends, params: params, response: FriendsResponseWrapper.self, completion: completion)
    }
    
    private func makeRequest<T: Decodable>(path: APIMethods, params: Parametrs, response: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        APIManager.shader.request(path: path, params: params) { data, error in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            if let data = data {
                if let response = try? JSONDecoder().decode(response.self, from: data) {
                    completion(.success(response))
                } else {
                    if let errorResponse = try? JSONDecoder().decode(ErrorResponseWrapper.self, from: data) {
                        completion(.failure(errorResponse.error))
                    }
                }
            }
        }
    }
    
}
