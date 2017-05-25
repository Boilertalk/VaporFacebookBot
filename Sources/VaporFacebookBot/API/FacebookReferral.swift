//
//  FacebookReferral.swift
//  VaporFacebookBot
//
//  Created by Koray Koska on 25/05/2017.
//
//

import Foundation
import Vapor

public final class FacebookReferral: JSONConvertible {

    public var ref: String
    public var adId: String?
    public var source: FacebookReferralSource
    public var type: FacebookReferralType

    public init(json: JSON) throws {
        ref = try json.get("ref")
        adId = json["ad_id"]?.string

        guard let source = try FacebookReferralSource(rawValue: json.get("source")) else {
            throw Abort(.badRequest, metadata: "source was not set for FacebookReferral")
        }
        self.source = source

        guard let type = try FacebookReferralType(rawValue: json.get("type")) else {
            throw Abort(.badRequest, metadata: "type was not set for FacebookReferral")
        }
        self.type = type
    }

    public func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set("ref", ref)

        if let adId = adId {
            try json.set("ad_id", adId)
        }

        try json.set("source", source.rawValue)
        try json.set("type", type.rawValue)
        return json
    }
}

public enum FacebookReferralSource: String {

    case shortlink = "SHORTLINK"
    case ads = "ADS"
    case messengerCode = "MESSENGER_CODE"
}

public enum FacebookReferralType: String {

    case openThread = "OPEN_THREAD"
}
