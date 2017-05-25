//
//  FacebookMessage.swift
//  BoilertalkFacebook
//
//  Created by Koray Koska on 24/05/2017.
//
//

import Foundation
import Vapor

public final class FacebookMessage: JSONConvertible {

    public var mid: String
    public var text: String?
    public var attachments: [FacebookAttachment]?
    public var quickReply: FacebookQuickReply?

    public init(json: JSON) throws {
        mid = try json.get("mid")
        text = json["text"]?.string

        if let attachementsJson = json["attachments"]?.array {
            var attachmentsArray = [FacebookAttachment]()
            for a in attachementsJson {
                attachmentsArray.append(try FacebookAttachment(json: a))
            }
            attachments = attachmentsArray
        }

        if let q = json["quick_reply"] {
            quickReply = try FacebookQuickReply(json: q)
        }
    }

    public func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set("mid", mid)
        if let text = text {
            try json.set("text", text)
        }
        if let attachments = attachments {
            try json.set("attachments", JSON(attachments.jsonArray()))
        }
        return json
    }
}

public final class FacebookQuickReply: JSONConvertible {

    public var payload: String

    public init(json: JSON) throws {
        payload = try json.get("payload")
    }

    public func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set("payload", payload)
        return json
    }
}
