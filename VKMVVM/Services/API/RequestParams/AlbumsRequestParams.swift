//
//  AlbumsRequestParams.swift
//  VKMVVM
//
//  Created by Антон Кочетков on 28.01.2022.
//

import Foundation

struct AlbumsRequestParams: RequestParamsProtocol {
    
    let ownerId: String?
    let photoSizes: Bool
    let needSystem: Bool
    
    func generateParametrsForRequest() -> Parametrs {
        var parametrs: Parametrs = [:]
        if let ownerId = ownerId {
            parametrs[NameRequestParams.ownerId.rawValue] = ownerId
        }
        parametrs[NameRequestParams.photoSizes.rawValue] = String(photoSizes ? 1 : 0)
        parametrs[NameRequestParams.needSystem.rawValue] = String(needSystem ? 1 : 0)
        parametrs[NameRequestParams.needCovers.rawValue] = String(photoSizes ? 1 : 0)
        return parametrs
    }
    
    private enum NameRequestParams: String {
        case ownerId = "owner_id"
        case needSystem = "need_system"
        case needCovers = "need_covers"
        case photoSizes = "photo_sizes"
    }

}
