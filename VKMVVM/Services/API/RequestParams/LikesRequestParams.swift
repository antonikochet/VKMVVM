//
//  LikesRequestParams.swift
//  VKMVVM
//
//  Created by Антон Кочетков on 09.02.2022.
//

import Foundation

enum LikesTypeParams: String {
    case post
    case photo
}

enum LikesTypeMethod {
    case add
    case delete
}

struct LikesRequestParams: RequestParamsProtocol {
    let type: LikesTypeParams
    let ownerId: Int
    let itemId: Int

    func generateParametrsForRequest() -> Parametrs {
        var parametrs: Parametrs = [:]
        parametrs[NameParams.type.rawValue] = type.rawValue
        parametrs[NameParams.ownerId.rawValue] = String(ownerId)
        parametrs[NameParams.itemId.rawValue] = String(itemId)
        return parametrs
    }
    
    private enum NameParams: String {
        case type
        case ownerId = "owner_id"
        case itemId = "item_id"
    }
}
