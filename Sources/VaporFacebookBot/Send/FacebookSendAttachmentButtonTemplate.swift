//
//  FacebookSendAttachmentButtonTemplate.swift
//  VaporFacebookBot
//
//  Created by Koray Koska on 26/05/2017.
//
//

import Foundation
import Vapor

public final class FacebookSendAttachmentButtonTemplate: FacebookSendAttachmentTemplate {

    public static var templateType: FacebookSendAttachmentTemplateType {
        return .button
    }

    public var sharable: Bool?
    public var text: String
    public var buttons: [FacebookSendButton]

    public init(sharable: Bool? = nil, text: String, buttons: [FacebookSendButton]) {
        self.sharable = sharable
        self.text = text
        self.buttons = buttons
    }

    public convenience init(json: JSON) throws {
        let sharable = json["sharable"]?.bool
        let text: String = try json.get("text")

        var buttons: [FacebookSendButton] = [FacebookSendButton]()
        if let buttonsArray = json["buttons"]?.array {
            for b in buttonsArray {
                try buttons.append(FacebookSendButtonHolder(json: b).button)
            }
        } else {
            throw Abort(.badRequest, metadata: "buttons must be an array of FacebookSendButtons in FacebookSendAttachmentButtonTemplate")
        }

        self.init(sharable: sharable, text: text, buttons: buttons)
    }

    public func makeJSON() throws -> JSON {
        var json = JSON()

        try json.set("template_type", type(of: self).templateType.rawValue)

        try json.set("text", text)

        if let sharable = sharable {
            try json.set("sharable", sharable)
        }

        var buttonsJArr = [JSON]()
        for b in buttons {
            try buttonsJArr.append(b.makeJSON())
        }
        try json.set("buttons", buttonsJArr)
        
        return json
    }
}
