//
//  FacebookCallbackEntry.swift
//  BoilertalkFacebook
//
//  Created by Koray Koska on 24/05/2017.
//
//

import Foundation
import Vapor

public final class FacebookCallbackEntry: JSONConvertible {

    public var id: String
    public var time: Int
    public var messaging: [FacebookMessaging]

    public init(json: JSON) throws {
        id = try json.get("id")
        time = try json.get("time")

        if let a = json["messaging"]?.array {
            var arr = [FacebookMessaging]()
            for e in a {
                arr.append(try FacebookMessaging(json: e))
            }
            messaging = arr
        } else {
            throw Abort(.badRequest, metadata: "messaging is not set or is not an array in FacebookCallbackEntry")
        }
    }

    public func makeJSON() throws -> JSON {
        var json = JSON()

        try json.set("id", id)
        try json.set("time", time)
        try json.set("messaging", messaging.jsonArray())
        
        return json
    }
}
