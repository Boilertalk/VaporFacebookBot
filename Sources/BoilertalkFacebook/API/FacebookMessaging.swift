//
//  FacebookMessaging.swift
//  BoilertalkFacebook
//
//  Created by Koray Koska on 24/05/2017.
//
//

import Foundation
import Vapor

public final class FacebookMessaging: JSONConvertible {

    // TODO: Support other callback formats
    public var messageReceived: FacebookMessageReceived?
    public var postbackReceived: FacebookPostbackReceived?

    public init(json: JSON) throws {
        if let _ = json["message"] {
            messageReceived = try FacebookMessageReceived(json: json)
        } else if let _ = json["postback"] {
            postbackReceived = try FacebookPostbackReceived(json: json)
        }
    }

    public func makeJSON() throws -> JSON {
        let json = JSON()

        if let j = messageReceived {
            return try j.makeJSON()
        } else if let j = postbackReceived {
            return try j.makeJSON()
        }

        return json
    }
}
