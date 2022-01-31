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
    func getFollowers(userId: String?, fieldsParams: [UserRequestFieldsParams], completion: @escaping DataFetcherCompletion<FriendsResponseWrapper>)
    func getAllPhotos(ownerId: String?, extended: Bool, offset: Int?, count: Int?, skipHidden: Bool, completion: @escaping DataFetcherCompletion<PhotosResponseWrapper>)
    func getAlbums(ownerId: String?, photoSizes: Bool, needSystem: Bool, completion: @escaping DataFetcherCompletion<AlbumResponseWrapper>)
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
        var params: Parametrs = [:]
        if let ownerId = ownerId {
            params[PhotosRequestParams.ownerId.rawValue] = ownerId
        }
        if let photoIds = photoIds {
            params[PhotosRequestParams.photoIds.rawValue] = photoIds.joined(separator: ",")
        }
        params[PhotosRequestParams.albumId.rawValue] = albumId.string
        params[PhotosRequestParams.extended.rawValue] = (extended ? 1 : 0).description
        makeRequest(path: .getPhotos, params: params, response: PhotosResponseWrapper.self, completion: completiom)
    }
    
    func getFollowers(userId: String?, fieldsParams: [UserRequestFieldsParams], completion: @escaping DataFetcherCompletion<FriendsResponseWrapper>) {
        var params: Parametrs = [:]
        if let userId = userId {
            params[UsersGetFollowersRequestParams.userId.rawValue] = userId
        }
        if !fieldsParams.isEmpty {
            params[UsersGetFollowersRequestParams.fields.rawValue] = UserRequestFieldsParams.params(fieldsParams)
        }
        makeRequest(path: .getFollowers, params: params, response: FriendsResponseWrapper.self, completion: completion)
    }
    
    func getAllPhotos(ownerId: String?, extended: Bool, offset: Int? = nil, count: Int?, skipHidden: Bool, completion: @escaping DataFetcherCompletion<PhotosResponseWrapper>) {
        var params: Parametrs = [:]
        if let ownerId = ownerId {
            params[GetAllPhotosRequestParams.ownerId.rawValue] = ownerId
        }
        if let offset = offset {
            params[GetAllPhotosRequestParams.offset.rawValue] = String(offset)
        }
        if let count = count {
            params[GetAllPhotosRequestParams.count.rawValue] = String(count)
        }
        params[GetAllPhotosRequestParams.extended.rawValue] = String(extended ? 1 : 0)
        params[GetAllPhotosRequestParams.skipHidden.rawValue] = String(skipHidden ? 1 : 0)
        makeRequest(path: .getAllPhotos, params: params, response: PhotosResponseWrapper.self, completion: completion)
    }
    
    func getAlbums(ownerId: String?, photoSizes: Bool, needSystem: Bool, completion: @escaping DataFetcherCompletion<AlbumResponseWrapper>) {
        var params: Parametrs = [:]
        if let ownerId = ownerId {
            params[AlbumsRequestParams.ownerId.rawValue] = ownerId
        }
        params[AlbumsRequestParams.photoSizes.rawValue] = String(photoSizes ? 1 : 0)
        params[AlbumsRequestParams.needSystem.rawValue] = String(needSystem ? 1 : 0)
        params[AlbumsRequestParams.needCovers.rawValue] = String(photoSizes ? 1 : 0)
        makeRequest(path: .getAlbums, params: params, response: AlbumResponseWrapper.self, completion: completion)
    }
    
    //MARK: - private method for universal make request for all methods API
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
