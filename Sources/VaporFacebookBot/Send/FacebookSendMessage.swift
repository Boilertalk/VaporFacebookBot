//
//  FacebookSendMessage.swift
//  VaporFacebookBot
//
//  Created by Koray Koska on 25/05/2017.
//
//

import Foundation
import Vapor

public final class FacebookSendMessage: JSONConvertible {

    public var text: String?
    public var attachment: FacebookSendAttachment?
    public var quickReplies: [FacebookSendQuickReply]?
    public var metadata: String?

    public init(text: String, quickReplies: [FacebookSendQuickReply]? = nil, metadata: String? = nil) {
        self.text = text
        self.quickReplies = quickReplies
        self.metadata = metadata
    }

    public init(attachment: FacebookSendAttachment, quickReplies: [FacebookSendQuickReply]? = nil, metadata: String? = nil) {
        self.attachment = attachment
        self.quickReplies = quickReplies
        self.metadata = metadata
    }

    public convenience init(json: JSON) throws {
        var replies: [FacebookSendQuickReply]? = nil
        if let quickReplies = json["quick_replies"]?.array {
            replies = [FacebookSendQuickReply]()
            for q in quickReplies {
                try replies?.append(FacebookSendQuickReply(json: q))
            }
        }

        let metadata = json["metadata"]?.string

        if let text = json["text"]?.string {
            self.init(text: text, quickReplies: replies, metadata: metadata)
        } else if let attachment = json["attachment"] {
            let a = try FacebookSendAttachment(json: attachment)
            self.init(attachment: a, quickReplies: replies, metadata: metadata)
        } else {
            throw Abort(.badRequest, metadata: "Either text or attachment must be set for FacebookSendMessage")
        }
    }

    public func makeJSON() throws -> JSON {
        var json = JSON()

        if let text = text {
            try json.set("text", text)
        } else if let attachment = attachment {
            try json.set("attachment", attachment)
        }

        if let quickReplies = quickReplies {
            try json.set("quick_replies", quickReplies.jsonArray())
        }

        if let metadata = metadata {
            try json.set("metadata", metadata)
        }

        return json
    }
}

public final class FacebookSendQuickReply: JSONConvertible {

    public var contentType: FacebookSendQuickReplyContentType
    public var title: String?
    public var payload: String?
    public var imageUrl: String?

    public convenience init(title: String, payload: String, imageUrl: String? = nil) {
        self.init(contentType: .text, title: title, payload: payload, imageUrl: imageUrl)
    }

    public init(contentType: FacebookSendQuickReplyContentType, title: String? = nil, payload: String? = nil, imageUrl: String? = nil) {
        self.contentType = .text
        self.title = title
        self.payload = payload
        self.imageUrl = imageUrl
    }

    public convenience init(json: JSON) throws {
        guard let contentType = try FacebookSendQuickReplyContentType(rawValue: json.get("content_type")) else {
            throw Abort(.badRequest, metadata: "content_type must be set for FacebookSendQuickReply")
        }

        if contentType == .text {
            let title: String = try json.get("title")
            let payload: String = try json.get("payload")
            let imageUrl = json["image_url"]?.string

            self.init(contentType: contentType, title: title, payload: payload, imageUrl: imageUrl)
        } else if contentType == .location {
            self.init(contentType: contentType)
        } else {
            throw Abort(.badRequest, metadata: "Either .text or .location must be set as content_type for FacebookSendQuickReply")
        }
    }

    public func makeJSON() throws -> JSON {
        var json = JSON()

        try json.set("content_type", contentType.rawValue)

        if contentType == .text {
            try json.set("title", title)
            try json.set("payload", payload)
            if let imageUrl = imageUrl {
                try json.set("image_url", imageUrl)
            }
        }

        return json
    }
}

public enum FacebookSendQuickReplyContentType: String {

    case text = "text"
    case location = "location"
}
