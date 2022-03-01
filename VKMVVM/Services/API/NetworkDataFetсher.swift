//
//  NetworkDataFetсher.swift
//  VKMVVM
//
//  Created by Антон Кочетков on 22.01.2022.
//

import Foundation

enum DataFetcherError: ErrorProtocol {
    case NotValidData(String)
    case UserNotPersonal
    case NotValidError
    
    var message: String {
        switch self {
            case .NotValidData(let method):
                return "С сервера по запросу '\(method)' получены не валидные данные!"
            case .UserNotPersonal:
                return ""
            case .NotValidError:
                return ""
        }
    }
}

extension DataFetcherError: Equatable {}

protocol DataFetcher {
    typealias DataFetcherCompletion<T> = (Result<T, Error>) -> Void
    
    func getNewsFeed(parametrs: RequestParamsProtocol, completion: @escaping DataFetcherCompletion<NewsFeedResponseWrapped>)
    func getProfileInfo(parametrs: RequestParamsProtocol, completion: @escaping DataFetcherCompletion<UserResponseWrapper>)
    func getFriends(parametrs: RequestParamsProtocol, completion: @escaping DataFetcherCompletion<FriendsResponseWrapper>)
    func getPhotos(parametrs: RequestParamsProtocol, completiom: @escaping DataFetcherCompletion<PhotosResponseWrapper>)
    func getFollowers(parametrs: RequestParamsProtocol, completion: @escaping DataFetcherCompletion<FriendsResponseWrapper>)
    func getAllPhotos(parametrs: RequestParamsProtocol, completion: @escaping DataFetcherCompletion<PhotosResponseWrapper>)
    func getAlbums(parametrs: RequestParamsProtocol, completion: @escaping DataFetcherCompletion<AlbumResponseWrapper>)
    func handlingLike(type: LikesTypeMethod, parametrs: RequestParamsProtocol, completion: @escaping DataFetcherCompletion<LikesResponseWrapper>)
}

struct NetworkDataFetcher: DataFetcher {
    func getNewsFeed(parametrs: RequestParamsProtocol, completion: @escaping DataFetcherCompletion<NewsFeedResponseWrapped>) {
        makeRequest(path: .getNewsFeed, params: parametrs.generateParametrsForRequest(), response: NewsFeedResponseWrapped.self, completion: completion)
    }
    
    func getProfileInfo(parametrs: RequestParamsProtocol, completion: @escaping DataFetcherCompletion<UserResponseWrapper>) {
        makeRequest(path: .getUsers, params: parametrs.generateParametrsForRequest(), response: UserResponseWrapper.self, completion: completion)
    }
    
    func getFriends(parametrs: RequestParamsProtocol, completion: @escaping DataFetcherCompletion<FriendsResponseWrapper>) {
        makeRequest(path: .getFriends, params: parametrs.generateParametrsForRequest(), response: FriendsResponseWrapper.self, completion: completion)
    }
    
    func getPhotos(parametrs: RequestParamsProtocol, completiom: @escaping DataFetcherCompletion<PhotosResponseWrapper>) {
        makeRequest(path: .getPhotos, params: parametrs.generateParametrsForRequest(), response: PhotosResponseWrapper.self, completion: completiom)
    }
    
    func getFollowers(parametrs: RequestParamsProtocol, completion: @escaping DataFetcherCompletion<FriendsResponseWrapper>) {
        makeRequest(path: .getFollowers, params: parametrs.generateParametrsForRequest(), response: FriendsResponseWrapper.self, completion: completion)
    }
    
    func getAllPhotos(parametrs: RequestParamsProtocol, completion: @escaping DataFetcherCompletion<PhotosResponseWrapper>) {
        makeRequest(path: .getAllPhotos, params: parametrs.generateParametrsForRequest(), response: PhotosResponseWrapper.self, completion: completion)
    }
    
    func getAlbums(parametrs: RequestParamsProtocol, completion: @escaping DataFetcherCompletion<AlbumResponseWrapper>) {
        makeRequest(path: .getAlbums, params: parametrs.generateParametrsForRequest(), response: AlbumResponseWrapper.self, completion: completion)
    }
    
    func handlingLike(type: LikesTypeMethod, parametrs: RequestParamsProtocol, completion: @escaping DataFetcherCompletion<LikesResponseWrapper>) {
        let method: APIMethods = type == .add ? .addLike : .deleteLike
        makeRequest(path: method, params: parametrs.generateParametrsForRequest(), response: LikesResponseWrapper.self, completion: completion)
    }
    
    //MARK: - private method for universal make request for all methods API
    private func makeRequest<T: Decodable>(path: APIMethods, params: Parametrs, response: T.Type, completion: @escaping DataFetcherCompletion<T>) {
        APIManager.shader.request(path: path, params: params) { data, error in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            if let data = data {
                do {
                    let response = try JSONDecoder().decode(response.self, from: data)
                    completion(.success(response))
                } catch DecodingError.typeMismatch(_, let context) {
                    if context.codingPath.contains(where: { $0.stringValue == "personal" }) {
                        completion(.failure(DataFetcherError.UserNotPersonal))
                    }
                } catch is DecodingError {
                    let json = try! JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                    completion(.failure(DataFetcherError.NotValidData(path.rawValue)))
                } catch {
                    if let errorResponse = try? JSONDecoder().decode(ErrorResponseWrapper.self, from: data) {
                        completion(.failure(errorResponse.error))
                    } else {
                        completion(.failure(DataFetcherError.NotValidError))
                    }
                }
            } else {
                completion(.failure(DataFetcherError.NotValidData(path.rawValue)))
            }
        }
    }
}
