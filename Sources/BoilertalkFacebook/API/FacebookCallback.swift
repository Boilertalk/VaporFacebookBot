//
//  FacebookCallback.swift
//  BoilertalkFacebook
//
//  Created by Koray Koska on 24/05/2017.
//
//

import Foundation
import Vapor

public final class FacebookCallback: JSONConvertible {

    public var object: String
    public var entry: [FacebookCallbackEntry]

    public init(json: JSON) throws {
        object = try json.get("object")

        if let a = json["entry"]?.array {
            var arr = [FacebookCallbackEntry]()
            for e in a {
                arr.append(try FacebookCallbackEntry(json: e))
            }
            entry = arr
        } else {
            throw Abort(.badRequest, metadata: "entry is not set or is not an array in FacebookCallback")
        }
    }

    public func makeJSON() throws -> JSON {
        var json = JSON()

        try json.set("object", object)
        try json.set("entry", entry.jsonArray())

        return json
    }
}
