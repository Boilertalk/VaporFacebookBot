//
//  FacebookPostbackReceived.swift
//  VaporFacebookBot
//
//  Created by Koray Koska on 25/05/2017.
//
//

import Foundation
import Vapor

public final class FacebookPostbackReceived: JSONConvertible {

    public var senderId: String
    public var recipientId: String
    public var timestamp: Int
    public var postback: FacebookPostback

    public init(json: JSON) throws {
        senderId = try (json.get("sender") as JSON).get("id")
        recipientId = try (json.get("recipient") as JSON).get("id")
        timestamp = try json.get("timestamp")
        postback = try FacebookPostback(json: json.get("postback"))
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

        try json.set("postback", postback.makeJSON())

        return json
    }
}
