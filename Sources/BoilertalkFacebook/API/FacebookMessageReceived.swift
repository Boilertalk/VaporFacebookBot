//
//  FacebookMessageReceived.swift
//  BoilertalkFacebook
//
//  Created by Koray Koska on 24/05/2017.
//
//

import Foundation
import Vapor

public final class FacebookMessageReceived: JSONConvertible {

    // TODO: Echo messages and stickers???

    public var senderId: String
    public var recipientId: String
    public var timestamp: Int
    public var message: FacebookMessage

    public init(json: JSON) throws {
        senderId = try (json.get("sender") as JSON).get("id")
        recipientId = try (json.get("recipient") as JSON).get("id")
        timestamp = try json.get("timestamp")
        message = try FacebookMessage(json: json.get("message"))
    }

    public func makeJSON() throws -> JSON {
        var json = JSON()

        var sender = JSON()
        try sender.set("id", senderId)
        try json.set("sender", sender)

        var recipient = JSON()
        try recipient.set("id", recipientId)
        try json.set("recipient", recipient)

        try json.set("timestamp", timestamp)

        try json.set("message", message.makeJSON())

        return json
    }
}
