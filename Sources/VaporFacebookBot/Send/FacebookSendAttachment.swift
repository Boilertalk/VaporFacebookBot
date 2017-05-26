//
//  FacebookSendAttachment.swift
//  VaporFacebookBot
//
//  Created by Koray Koska on 26/05/2017.
//
//

import Foundation
import Vapor

public final class FacebookSendAttachment: JSONConvertible {

    public var payload: FacebookSendAttachmentPayload

    public init(payload: FacebookSendAttachmentPayload) {
        self.payload = payload
    }

    public convenience init(json: JSON) throws {
        guard let type = try FacebookSendAttachmentType(rawValue: json.get("type")), let payloadType = FacebookSendApi.shared.registeredPayloadTypes[type] else {
            throw Abort(.badRequest, metadata: "type must be a valid FacebookSendAttachmentType for FacebookSendAttachment")
        }
        let payloadJson: JSON = try json.get("payload")

        self.init(payload: try payloadType.init(json: payloadJson))
    }

    public func makeJSON() throws -> JSON {
        var json = JSON()

        try json.set("type", type(of: payload).attachmentType.rawValue)
        try json.set("payload", try payload.makeJSON())

        return json
    }
}

public enum FacebookSendAttachmentType: String {

    case image = "image"
    case audio = "audio"
    case video = "video"
    case file = "file"
    case template = "template"
}
