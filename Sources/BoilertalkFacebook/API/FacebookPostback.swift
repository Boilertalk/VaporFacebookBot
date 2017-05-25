//
//  FacebookPostback.swift
//  BoilertalkFacebook
//
//  Created by Koray Koska on 25/05/2017.
//
//

import Foundation
import Vapor

public final class FacebookPostback: JSONConvertible {

    public var payload: String
    public var referral: FacebookReferral?

    public init(json: JSON) throws {
        payload = try json.get("payload")

        if let r = json["referral"] {
            referral = try FacebookReferral(json: r)
        }
    }

    public func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set("payload", payload)

        if let referral = referral {
            try json.set("referral", referral.makeJSON())
        }

        return json
    }
}
