//
//  FacebookAttachment.swift
//  VaporFacebookBot
//
//  Created by Koray Koska on 24/05/2017.
//
//

import Foundation
import Vapor

public final class FacebookAttachment: JSONConvertible {

    public var type: FacebookAttachmentType
    public var payload: FacebookAttachmentPayload

    public var title: String?
    public var url: String?

    public init(json: JSON) throws {
        guard let type = FacebookAttachmentType(rawValue: try json.get("type")) else {
            throw Abort(.badRequest, metadata: "type is not a valid FacebookAttachmentType in FacebookAttachement")
        }
        self.type = type
        self.payload = try FacebookAttachmentPayload(json: json.get("payload"))

        self.title = json["title"]?.string
        self.url = json["url"]?.string
    }

    public func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set("type", type.rawValue)
        try json.set("payload", try payload.makeJSON())

        if let title = title {
            try json.set("title", title)
        }
        if let url = url {
            try json.set("url", url)
        }

        return json
    }
}

public enum FacebookAttachmentType: String {

    case audio, fallback, file, image, location, video
}
