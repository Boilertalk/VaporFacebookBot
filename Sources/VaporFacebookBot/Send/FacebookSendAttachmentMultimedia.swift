//
//  FacebookSendAttachmentMultimedia.swift
//  VaporFacebookBot
//
//  Created by Koray Koska on 26/05/2017.
//
//

import Foundation
import Vapor

public class FacebookSendAttachmentMultimedia: FacebookSendAttachmentPayload {

    public class var attachmentType: FacebookSendAttachmentType {
        fatalError("attachmentType must be set in subclasses of attachmentType")
    }

    // TODO: Binary image upload?
    public var url: String?
    public var isReusable: Bool?

    public var attachmentId: String?

    public init(url: String, isReusable: Bool? = nil) {
        self.url = url
        self.isReusable = isReusable
    }

    public init(attachmentId: String) {
        self.attachmentId = attachmentId
    }

    public convenience required init(json: JSON) throws {
        if let url = json["url"]?.string {
            self.init(url: url, isReusable: json["is_reusable"]?.bool)
        } else {
            try self.init(attachmentId: json.get("attachment_id"))
        }
    }

    public func makeJSON() throws -> JSON {
        var json = JSON()

        if let url = url {
            try json.set("url", url)

            if let isReusable = isReusable {
                try json.set("is_reusable", isReusable)
            }
        } else if let attachmentId = attachmentId {
            try json.set("attachment_id", attachmentId)
        }

        return json
    }
}

public final class FacebookSendAttachmentImage: FacebookSendAttachmentMultimedia {

    public override static var attachmentType: FacebookSendAttachmentType {
        return .image
    }
}

public final class FacebookSendAttachmentAudio: FacebookSendAttachmentMultimedia {

    public override static var attachmentType: FacebookSendAttachmentType {
        return .audio
    }
}

public final class FacebookSendAttachmentVideo: FacebookSendAttachmentMultimedia {

    public override static var attachmentType: FacebookSendAttachmentType {
        return .video
    }
}

public final class FacebookSendAttachmentFile: FacebookSendAttachmentMultimedia {

    public override static var attachmentType: FacebookSendAttachmentType {
        return .file
    }
}
