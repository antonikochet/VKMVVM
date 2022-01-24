//
//  PhotosResponse.swift
//  VKMVVM
//
//  Created by Антон Кочетков on 24.01.2022.
//

import Foundation

struct PhotosResponseWrapper: Decodable {
    let response: PhotosResponse
}

struct PhotosResponse: Decodable {
    let count: Int
    let items: [Photo]
}
