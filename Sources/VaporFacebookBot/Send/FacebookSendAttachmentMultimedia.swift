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
    public var url: String
    public var isReusable: Bool?

    public init(url: String, isReusable: Bool? = nil) {
        self.url = url
        self.isReusable = isReusable
    }

    public convenience required init(json: JSON) throws {
        try self.init(url: json.get("url"), isReusable: json["is_reusable"]?.bool)
    }

    public func makeJSON() throws -> JSON {
        var json = JSON()

        try json.set("url", url)

        if let isReusable = isReusable {
            try json.set("is_reusable", isReusable)
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
