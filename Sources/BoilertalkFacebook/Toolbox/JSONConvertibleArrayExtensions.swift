//
//  JSONConvertibleArrayExtensions.swift
//  BoilertalkFacebook
//
//  Created by Koray Koska on 25/05/2017.
//
//

import Foundation
import Vapor

extension Array where Element: JSONConvertible {

    func jsonArray() throws -> [JSON] {
        return try map { try $0.makeJSON() }
    }
}
