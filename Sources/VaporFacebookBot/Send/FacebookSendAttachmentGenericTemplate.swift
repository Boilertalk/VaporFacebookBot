//
//  FacebookSendAttachmentGenericTemplate.swift
//  VaporFacebookBot
//
//  Created by Koray Koska on 26/05/2017.
//
//

import Foundation
import Vapor

public final class FacebookSendAttachmentGenericTemplate: FacebookSendAttachmentTemplate {

    public static var templateType: FacebookSendAttachmentTemplateType {
        return .generic
    }

    public var sharable: Bool?
    public var imageAspectRatio: FacebookSendAttachmentImageRatio?
    public var elements: [FacebookSendAttachmentGenericElement]

    public init(sharable: Bool? = nil, imageAspectRatio: FacebookSendAttachmentImageRatio? = nil, elements: [FacebookSendAttachmentGenericElement]) {
        self.sharable = sharable
        self.imageAspectRatio = imageAspectRatio
        self.elements = elements
    }

    public convenience init(json: JSON) throws {
        let sharable = json["sharable"]?.bool
        let imageAspectRatioString = json["image_aspect_ratio"]?.string
        let imageAspectRatio = imageAspectRatioString == nil ? nil : FacebookSendAttachmentImageRatio(rawValue: imageAspectRatioString!)

        guard let elementsArray = json["elements"]?.array else {
            throw Abort(.badRequest, metadata: "elements must be set for FacebookSendAttachmentGenericTemplate")
        }

        var elements = [FacebookSendAttachmentGenericElement]()
        for e in elementsArray {
            try elements.append(FacebookSendAttachmentGenericElement(json: e))
        }

        self.init(sharable: sharable, imageAspectRatio: imageAspectRatio, elements: elements)
    }

    public func makeJSON() throws -> JSON {
        var json = JSON()

        try json.set("template_type", type(of: self).templateType.rawValue)

        if let sharable = sharable {
            try json.set("sharable", sharable)
        }

        if let imageAspectRatio = imageAspectRatio {
            try json.set("image_aspect_ratio", imageAspectRatio.rawValue)
        }

        try json.set("elements", elements.jsonArray())

        return json
    }
}

public enum FacebookSendAttachmentImageRatio: String {

    case horizontal = "horizontal"
    case square = "square"
}

public final class FacebookSendAttachmentGenericElement: JSONConvertible {

    public var title: String
    public var subtitle: String?
    public var imageUrl: String?
    public var defaultAction: FacebookSendAttachmentGenericDefaultAction?
    public var buttons: [FacebookSendButton]?

    public init(
        title: String,
        subtitle: String? = nil,
        imageUrl: String? = nil,
        defaultAction: FacebookSendAttachmentGenericDefaultAction? = nil,
        buttons: [FacebookSendButton]? = nil) {

        self.title = title
        self.subtitle = subtitle
        self.imageUrl = imageUrl
        self.defaultAction = defaultAction
        self.buttons = buttons
    }

    public convenience init(json: JSON) throws {
        let title: String = try json.get("title")
        let subtitle = json["subtitle"]?.string
        let imageUrl = json["image_url"]?.string
        var defaultAction: FacebookSendAttachmentGenericDefaultAction? = nil
        if let j = json["default_action"] {
            defaultAction = try FacebookSendAttachmentGenericDefaultAction(json: j)
        }
        var buttons: [FacebookSendButton]? = nil
        if let buttonsArray = json["buttons"]?.array {
            buttons = [FacebookSendButton]()
            for b in buttonsArray {
                try buttons?.append(FacebookSendButtonHolder(json: b).button)
            }
        }

        self.init(title: title, subtitle: subtitle, imageUrl: imageUrl, defaultAction: defaultAction, buttons: buttons)
    }

    public func makeJSON() throws -> JSON {
        var json = JSON()

        try json.set("title", title)

        if let subtitle = subtitle {
            try json.set("subtitle", subtitle)
        }

        if let imageUrl = imageUrl {
            try json.set("image_url", imageUrl)
        }

        if let defaultAction = defaultAction {
            try json.set("default_action", defaultAction.makeJSON())
        }

        if let buttons = buttons {
            var jArray = [JSON]()
            for b in buttons {
                jArray.append(try b.makeJSON())
            }
            try json.set("buttons", jArray)
        }

        return json
    }
}

// TODO: The only difference between this class and FacebookSendURLButton is that this one does not support `title`. Maybe there is a better solution than duplicating it...
public final class FacebookSendAttachmentGenericDefaultAction: JSONConvertible {

    public let type = "web_url"
    public var url: String
    public var webviewHeightRatio: FacebookSendWebviewHeightRatio?
    public var messengerExtensions: Bool?
    public var fallbackUrl: String?
    public var webviewShareButton: String?

    public init(
        url: String,
        webviewHeightRatio: FacebookSendWebviewHeightRatio? = nil,
        messengerExtensions: Bool? = nil,
        fallbackUrl: String? = nil,
        webviewShareButton: String? = nil) {

        self.url = url
        self.webviewHeightRatio = webviewHeightRatio
        self.messengerExtensions = messengerExtensions
        self.fallbackUrl = fallbackUrl
        self.webviewShareButton = webviewShareButton
    }

    public convenience init(json: JSON) throws {
        let url: String = try json.get("url")
        var webviewHeightRatio: FacebookSendWebviewHeightRatio? = nil
        if let w = json["webview_height_ratio"]?.string {
            webviewHeightRatio = FacebookSendWebviewHeightRatio(rawValue: w)
        }
        let messengerExtensions = json["messenger_extensions"]?.bool
        let fallbackUrl = json["fallback_url"]?.string
        let webviewShareButton = json["webview_share_button"]?.string

        self.init(url: url, webviewHeightRatio: webviewHeightRatio, messengerExtensions: messengerExtensions, fallbackUrl: fallbackUrl, webviewShareButton: webviewShareButton)
    }

    public func makeJSON() throws -> JSON {
        var json = JSON()

        try json.set("type", type)
        try json.set("url", url)

        if let webviewHeightRatio = webviewHeightRatio {
            try json.set("webview_height_ratio", webviewHeightRatio.rawValue)
        }

        if let messengerExtensions = messengerExtensions {
            try json.set("messenger_extensions", messengerExtensions)
        }

        if let fallbackUrl = fallbackUrl {
            try json.set("fallback_url", fallbackUrl)
        }

        if let webviewShareButton = webviewShareButton {
            try json.set("webview_share_button", webviewShareButton)
        }

        return json
    }
}
