//
//  Error.swift
//  VKMVVM
//
//  Created by Антон Кочетков on 11.02.2022.
//

import Foundation

protocol ErrorProtocol: Error {
    var message: String { get }
}
