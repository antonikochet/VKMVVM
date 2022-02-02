//
//  PhotosRequestParams.swift
//  VKMVVM
//
//  Created by Антон Кочетков on 24.01.2022.
//

import Foundation


struct PhotosRequestParams: RequestParamsProtocol {
    let ownerId: String?
    let photoIds: [String]?
    let albumId: AlbumIdRequestParams
    let extended: Bool
    
    func generateParametrsForRequest() -> Parametrs {
        var parametrs: Parametrs = [:]
        if let ownerId = ownerId {
            parametrs[NameRequestParams.ownerId.rawValue] = ownerId
        }
        if let photoIds = photoIds {
            parametrs[NameRequestParams.photoIds.rawValue] = photoIds.joined(separator: ",")
        }
        parametrs[NameRequestParams.albumId.rawValue] = albumId.string
        parametrs[NameRequestParams.extended.rawValue] = (extended ? 1 : 0).description
        return parametrs
    }
    
    private enum NameRequestParams: String {
        case ownerId = "owner_id"
        case albumId = "album_id"
        case photoIds = "photo_ids"
        case extended
    }
}

struct GetAllPhotosRequestParams: RequestParamsProtocol {
    let ownerId: String?
    let offset: Int?
    let count: Int?
    let extended: Bool
    let skipHidden: Bool
    
    func generateParametrsForRequest() -> Parametrs {
        var parametrs: Parametrs = [:]
        if let ownerId = ownerId {
            parametrs[NameRequestParams.ownerId.rawValue] = ownerId
        }
        if let offset = offset {
            parametrs[NameRequestParams.offset.rawValue] = String(offset)
        }
        if let count = count {
            parametrs[NameRequestParams.count.rawValue] = String(count)
        }
        parametrs[NameRequestParams.extended.rawValue] = String(extended ? 1 : 0)
        parametrs[NameRequestParams.skipHidden.rawValue] = String(skipHidden ? 1 : 0)
        return parametrs
    }
    
    private enum NameRequestParams: String {
        case ownerId = "owner_id"
        case extended
        case offset
        case count
        case needHidden = "need_hidden"
        case skipHidden = "skip_hidden"
    }
    
}

enum AlbumIdRequestParams {
    case wall
    case profile
    case saved
    case id(String)
    
    var string: String {
        switch self {
            case .wall:
                return "wall"
            case .profile:
                return "profile"
            case .saved:
                return "saved"
            case .id(let string):
                return string
        }
    }
}
