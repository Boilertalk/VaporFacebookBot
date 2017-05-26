//
//  FacebookSendAttachmentPayload.swift
//  VaporFacebookBot
//
//  Created by Koray Koska on 26/05/2017.
//
//

import Foundation
import Vapor

public protocol FacebookSendAttachmentPayload: JSONConvertible {

    static var attachmentType: FacebookSendAttachmentType { get }
}
