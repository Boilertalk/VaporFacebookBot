//
//  FacebookSendAttachmentTemplate.swift
//  VaporFacebookBot
//
//  Created by Koray Koska on 26/05/2017.
//
//

import Foundation
import Vapor

public protocol FacebookSendAttachmentTemplate: FacebookSendAttachmentPayload {

    static var templateType: FacebookSendAttachmentTemplateType { get }
}

public extension FacebookSendAttachmentTemplate {

    static var attachmentType: FacebookSendAttachmentType {
        return .template
    }
}

public enum FacebookSendAttachmentTemplateType: String {

    case button = "button"
    case generic = "generic"
}

public final class FacebookSendAttachmentTemplateHolder: FacebookSendAttachmentPayload {

    public static var attachmentType: FacebookSendAttachmentType {
        return .template
    }

    public var attachmentTemplate: FacebookSendAttachmentTemplate

    public init(attachmentTemplate: FacebookSendAttachmentTemplate) {
        self.attachmentTemplate = attachmentTemplate
    }

    public convenience init(json: JSON) throws {
        guard let type = try FacebookSendAttachmentTemplateType(rawValue: json.get("template_type")), let templateType = FacebookSendApi.shared.registeredTemplateTypes[type] else {
            throw Abort(.badRequest, metadata: "template_type must be a valid FacebookSendAttachmentTemplateType for FacebookSendAttachmentTemplateHolder")
        }

        self.init(attachmentTemplate: try templateType.init(json: json))
    }

    public func makeJSON() throws -> JSON {
        return try attachmentTemplate.makeJSON();
    }
}
