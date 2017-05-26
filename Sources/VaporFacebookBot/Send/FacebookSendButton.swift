//
//  FacebookSendButton.swift
//  VaporFacebookBot
//
//  Created by Koray Koska on 26/05/2017.
//
//

import Foundation
import Vapor

public protocol FacebookSendButton: JSONConvertible {

    static var type: FacebookSendButtonType { get }
}

public enum FacebookSendButtonType: String {

    case webUrl = "web_url"
    case postback = "postback"
    case phoneNumber = "phone_number"
    case elementShare = "element_share"
}

public final class FacebookSendButtonHolder: JSONConvertible {

    public var button: FacebookSendButton

    public init(button: FacebookSendButton) {
        self.button = button
    }

    public convenience init(json: JSON) throws {
        guard let type = try FacebookSendButtonType(rawValue: json.get("type")), let buttonType = FacebookSendApi.shared.registeredButtonTypes[type] else {
            throw Abort(.badRequest, metadata: "type must be a valid FacebookSendButtonType for FacebookSendButtonHolder")
        }

        self.init(button: try buttonType.init(json: json))
    }

    public func makeJSON() throws -> JSON {
        return try button.makeJSON();
    }
}

public final class FacebookSendURLButton: FacebookSendButton {

    public static let type: FacebookSendButtonType = .webUrl

    public var title: String
    public var url: String
    public var webviewHeightRatio: FacebookSendWebviewHeightRatio?
    public var messengerExtensions: Bool?
    public var fallbackUrl: String?
    public var webviewShareButton: String?

    public init(
        title: String,
        url: String,
        webviewHeightRatio: FacebookSendWebviewHeightRatio? = nil,
        messengerExtensions: Bool? = nil,
        fallbackUrl: String? = nil,
        webviewShareButton: String? = nil) {

        self.title = title
        self.url = url
        self.webviewHeightRatio = webviewHeightRatio
        self.messengerExtensions = messengerExtensions
        self.fallbackUrl = fallbackUrl
        self.webviewShareButton = webviewShareButton
    }

    public convenience init(json: JSON) throws {
        let title: String = try json.get("title")
        let url: String = try json.get("url")
        var webviewHeightRatio: FacebookSendWebviewHeightRatio? = nil
        if let w = json["webview_height_ratio"]?.string {
            webviewHeightRatio = FacebookSendWebviewHeightRatio(rawValue: w)
        }
        let messengerExtensions = json["messenger_extensions"]?.bool
        let fallbackUrl = json["fallback_url"]?.string
        let webviewShareButton = json["webview_share_button"]?.string

        self.init(title: title, url: url, webviewHeightRatio: webviewHeightRatio, messengerExtensions: messengerExtensions, fallbackUrl: fallbackUrl, webviewShareButton: webviewShareButton)
    }

    public func makeJSON() throws -> JSON {
        var json = JSON()

        try json.set("type", type(of: self).type.rawValue)
        try json.set("title", title)
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

public final class FacebookSendPostbackButton: FacebookSendButton {

    public static let type: FacebookSendButtonType = .postback

    public var title: String
    public var payload: String

    public init(title: String, payload: String) {
        self.title = title
        self.payload = payload
    }

    public convenience init(json: JSON) throws {
        let title: String = try json.get("title")
        let payload: String = try json.get("payload")

        self.init(title: title, payload: payload)
    }

    public func makeJSON() throws -> JSON {
        var json = JSON()

        try json.set("type", type(of: self).type.rawValue)
        try json.set("title", title)
        try json.set("payload", payload)

        return json
    }
}

public final class FacebookSendCallButton: FacebookSendButton {

    public static let type: FacebookSendButtonType = .phoneNumber

    public var title: String
    public var payload: String

    /**
     * Initializes a new instance of FacebookSendCallButton with the given title and payload attributes.
     *
     * - parameter title: The title of this button. 20 character limit.
     * - parameter payload: A valid phone number. Format must have "+" prefix followed by the country code, area code and local number. For example, +16505551234.
     */
    public init(title: String, payload: String) {
        self.title = title
        self.payload = payload
    }

    public convenience init(json: JSON) throws {
        let title: String = try json.get("title")
        let payload: String = try json.get("payload")

        self.init(title: title, payload: payload)
    }

    public func makeJSON() throws -> JSON {
        var json = JSON()

        try json.set("type", type(of: self).type.rawValue)
        try json.set("title", title)
        try json.set("payload", payload)
        
        return json
    }
}

public final class FacebookSendShareButton: FacebookSendButton {

    public static let type: FacebookSendButtonType = .elementShare

    public var shareContents: FacebookSendAttachmentGenericTemplate?

    /**
     * Initializes a new instance of FacebookSendShareButton.
     *
     * Please use `shareContents` only if you know exactly what you are doing as there are some limitations
     * (like for example the maximum number of URL buttons, which is one as of now) which you must follow in order for
     * the request to work properly.
     *
     * See the documentation of `FacebookSendShareButton` for more details: https://developers.facebook.com/docs/messenger-platform/send-api-reference/share-button
     *
     * - parameter shareContents: The template which you want to share if it is different from the one this button is attached to. Defaults to nil.
     */
    public init(shareContents: FacebookSendAttachmentGenericTemplate? = nil) {
        self.shareContents = shareContents
    }

    public convenience init(json: JSON) throws {
        var shareContents: FacebookSendAttachmentGenericTemplate? = nil
        if let j = json["share_contents"] {
            shareContents = try FacebookSendAttachmentGenericTemplate(json: j)
        }

        self.init(shareContents: shareContents)
    }

    public func makeJSON() throws -> JSON {
        var json = JSON()

        try json.set("type", type(of: self).type.rawValue)

        if let shareContents = shareContents {
            try json.set("share_contents", shareContents.makeJSON())
        }
        
        return json
    }
}

// TODO: Buy Button, Login Button, Logout Button
