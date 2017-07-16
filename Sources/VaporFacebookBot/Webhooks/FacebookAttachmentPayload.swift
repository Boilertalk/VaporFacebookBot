//
//  FacebookAttachmentPayload.swift
//  VaporFacebookBot
//
//  Created by Koray Koska on 24/05/2017.
//
//

import Foundation
import Vapor

public final class FacebookAttachmentPayload: JSONConvertible {

    public var url: String?
    public var coordinatesLat: Double?
    public var coordinatesLong: Double?

    public init(url: String) {
        self.url = url
    }

    public init(coordinatesLat: Double, coordinatesLong: Double) {
        self.coordinatesLat = coordinatesLat
        self.coordinatesLong = coordinatesLong
    }

    public convenience init(json: JSON) throws {
        let url = json["url"]?.string
        let coordinatesLat = json["coordinates"]?["lat"]?.double
        let coordinatesLong = json["coordinates"]?["long"]?.double

        if let url = url, coordinatesLat == nil, coordinatesLong == nil {
            self.init(url: url)
        } else if let coordinatesLat = coordinatesLat, let coordinatesLong = coordinatesLong {
            self.init(coordinatesLat: coordinatesLat, coordinatesLong: coordinatesLong)
        } else {
            throw Abort(.badRequest, metadata: "FacebookAttachmentPayload must contain either a url or coordinates.lat and coordinates.long")
        }
    }

    public func makeJSON() throws -> JSON {
        var json = JSON()

        if let url = url {
            try json.set("url", url)
        } else if let coordinatesLat = coordinatesLat, let coordinatesLong = coordinatesLong {
            var coordinates = JSON()
            try coordinates.set("lat", coordinatesLat)
            try coordinates.set("lat", coordinatesLong)

            try json.set("coordinates", coordinates)
        }

        return json
    }
}
