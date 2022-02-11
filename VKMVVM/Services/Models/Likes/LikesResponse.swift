//
//  LikesResponse.swift
//  VKMVVM
//
//  Created by Антон Кочетков on 09.02.2022.
//

import Foundation

struct LikesResponseWrapper: Decodable {
    let response: LikesResponse
}

struct LikesResponse: Decodable {
    let likes: Int 
}
