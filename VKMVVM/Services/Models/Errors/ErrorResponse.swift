//
//  ErrorResponse.swift
//  VKMVVM
//
//  Created by Антон Кочетков on 23.01.2022.
//

import Foundation

struct ErrorResponseWrapper: Decodable {
    let error: ErrorResponse
}

struct ErrorResponse: Decodable, Error {
    let errorCode: Int
    let errorMessage: String
    let requestParams: [ErrorRequestParams]
    
    enum CodingKeys: String, CodingKey {
        case errorCode = "error_code"
        case errorMessage = "error_msg"
        case requestParams = "request_params"
    }
}

struct ErrorRequestParams: Decodable {
    let key: String
    let value: String
}
