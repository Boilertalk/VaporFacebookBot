//
//  FacebookSend.swift
//  VaporFacebookBot
//
//  Created by Koray Koska on 25/05/2017.
//
//

import Foundation
import Vapor

public final class FacebookSend: JSONConvertible {

    public var recipient: FacebookSendRecipient
    public var message: FacebookSendMessage?
    public var senderAction: FacebookSenderAction?
    public var notificationType: FacebookSendNotificationType?

    public init(recipient: FacebookSendRecipient, message: FacebookSendMessage, notificationType: FacebookSendNotificationType? = nil) {
        self.recipient = recipient
        self.message = message
        self.notificationType = notificationType
    }

    public init(recipient: FacebookSendRecipient, senderAction: FacebookSenderAction, notificationType: FacebookSendNotificationType? = nil) {
        self.recipient = recipient
        self.senderAction = senderAction
        self.notificationType = notificationType
    }

    public convenience init(json: JSON) throws {
        let recipient = try FacebookSendRecipient(json: json.get("recipient"))
        var notificationType: FacebookSendNotificationType? = nil
        if let notificationTypeString = json["notification_type"]?.string {
            notificationType = FacebookSendNotificationType(rawValue: notificationTypeString)
        }

        if let m = json["message"] {
            let message = try FacebookSendMessage(json: m)
            self.init(recipient: recipient, message: message, notificationType: notificationType)
        } else if let s = json["sender_action"]?.string, let senderAction = FacebookSenderAction(rawValue: s) {
            self.init(recipient: recipient, senderAction: senderAction, notificationType: notificationType)
        } else {
            throw Abort(.badRequest, metadata: "Either message or a valid sender_action (FacebookSenderAction) must be set for FacebookSend")
        }
    }

    public func makeJSON() throws -> JSON {
        var json = JSON()

        try json.set("recipient", recipient)

        if let message = message {
            try json.set("message", message)
        } else if let senderAction = senderAction {
            try json.set("sender_action", senderAction)
        }

        if let notificationType = notificationType {
            try json.set("notification_type", notificationType)
        }

        return json
    }
}

public final class FacebookSendRecipient: JSONConvertible {

    public var id: String?
    public var phoneNumber: String?
    public var name: (firstName: String, lastName: String)?

    public init(id: String) {
        self.id = id
    }

    public init(phoneNumber: String, name: (firstName: String, lastName: String)? = nil) {
        self.phoneNumber = phoneNumber
        self.name = name
    }

    public convenience init(json: JSON) throws {
        if let id = json["id"]?.string {
            self.init(id: id)
        } else if let phoneNumber = json["phone_number"]?.string {
            if let firstName = json["name"]?["first_name"]?.string, let lastName = json["name"]?["last_name"]?.string {
                let name = (firstName: firstName, lastName: lastName)
                self.init(phoneNumber: phoneNumber, name: name)
            } else {
                self.init(phoneNumber: phoneNumber)
            }
        } else {
            throw Abort(.badRequest, metadata: "FacebookSendObjectRecipient must contain either id or phone_number!")
        }
    }

    public func makeJSON() throws -> JSON {
        var json = JSON()

        if let id = id {
            try json.set("id", id)
        } else if let phoneNumber = phoneNumber {
            try json.set("phone_number", phoneNumber)

            if let name = name {
                var nameJson = JSON()
                try nameJson.set("first_name", name.firstName)
                try nameJson.set("last_name", name.lastName)

                try json.set("name", nameJson)
            }
        }

        return json
    }
}

public enum FacebookSenderAction: String {

    case typingOn = "typing_on"
    case typingOff = "typing_off"
    case markSeen = "mark_seen"
}

public enum FacebookSendNotificationType: String {

    case regular = "REGULAR"
    case silentPush = "SILENT_PUSH"
    case noPush = "NO_PUSH"
}
