//
//  NetworkDataFetсher.swift
//  VKMVVM
//
//  Created by Антон Кочетков on 22.01.2022.
//

import Foundation


protocol DataFetcher {
    typealias DataFetcherCompletion<T> = (Result<T, Error>) -> Void
    
    func getNewsFeed(startFrom: String?, paramsFilter: [NewsFeedFiltersParams], completion: @escaping DataFetcherCompletion<NewsFeedResponseWrapped>)
    func getProfileInfo(userId: String?, fieldsParams: [UserRequestFieldsParams], completion: @escaping DataFetcherCompletion<UserResponseWrapper>)
    func getFriends(userId: String?, fieldsParams: [FriendsRequestFieldsParams], orderParams: FriendsRequestOrderParams?, completion: @escaping DataFetcherCompletion<FriendsResponseWrapper>)
    func getPhotos(ownerId: String?, photoIds: [String]?, albumId: AlbumIdRequestParams, extended: Bool, completiom: @escaping DataFetcherCompletion<PhotosResponseWrapper>)
}

struct NetworkDataFetcher: DataFetcher {
    func getNewsFeed(startFrom: String?, paramsFilter: [NewsFeedFiltersParams], completion: @escaping DataFetcherCompletion<NewsFeedResponseWrapped>) {
        var params = [NewsFeedParams.filters.rawValue: NewsFeedFiltersParams.params(paramsFilter)]
        if let startFrom = startFrom {
            params[NewsFeedParams.startFrom.rawValue] = startFrom
        }
        makeRequest(path: .getNewsFeed, params: params, response: NewsFeedResponseWrapped.self, completion: completion)
    }
    
    func getProfileInfo(userId: String?, fieldsParams: [UserRequestFieldsParams], completion: @escaping DataFetcherCompletion<UserResponseWrapper>) {
        var params = [UserRequestParams.fields.rawValue: UserRequestFieldsParams.params(fieldsParams)]
        if let userId = userId {
            params[UserRequestParams.userIds.rawValue] = userId
        }
        makeRequest(path: .getUsers, params: params, response: UserResponseWrapper.self, completion: completion)
    }
    
    func getFriends(userId: String?, fieldsParams: [FriendsRequestFieldsParams], orderParams: FriendsRequestOrderParams?, completion: @escaping DataFetcherCompletion<FriendsResponseWrapper>) {
        var params = [FriendsRequestParams.fields.rawValue: FriendsRequestFieldsParams.params(fieldsParams)]
        if let userId = userId {
            params[FriendsRequestParams.userId.rawValue] = userId
        }
        if let orderParams = orderParams {
            params[FriendsRequestParams.order.rawValue] = orderParams.rawValue
        }
        makeRequest(path: .getFriends, params: params, response: FriendsResponseWrapper.self, completion: completion)
    }
    
    func getPhotos(ownerId: String?, photoIds: [String]?, albumId: AlbumIdRequestParams, extended: Bool, completiom: @escaping DataFetcherCompletion<PhotosResponseWrapper>) {
        var params: [String: String] = [:]
        if let ownerId = ownerId {
            params[PhotosRequestParams.ownerId.rawValue] = ownerId
        }
        if let photoIds = photoIds {
            params[PhotosRequestParams.photoIds.rawValue] = photoIds.joined(separator: ",")
        }
        params[PhotosRequestParams.albumId.rawValue] = albumId.rawValue
        params[PhotosRequestParams.extended.rawValue] = (extended ? 1 : 0).description
        makeRequest(path: .getPhotos, params: params, response: PhotosResponseWrapper.self, completion: completiom)
    }
    
    private func makeRequest<T: Decodable>(path: APIMethods, params: Parametrs, response: T.Type, completion: @escaping DataFetcherCompletion<T>) {
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
