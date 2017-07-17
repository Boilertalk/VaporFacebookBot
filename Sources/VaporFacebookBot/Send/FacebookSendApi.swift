//
//  FacebookSendApi.swift
//  VaporFacebookBot
//
//  Created by Koray Koska on 25/05/2017.
//
//

import Foundation
import Vapor
import HTTP

public final class FacebookSendApi {

    public static let shared = FacebookSendApi()

    public var registeredPayloadTypes: [FacebookSendAttachmentType: FacebookSendAttachmentPayload.Type] = [
        FacebookSendAttachmentImage.attachmentType: FacebookSendAttachmentImage.self,
        FacebookSendAttachmentAudio.attachmentType: FacebookSendAttachmentAudio.self,
        FacebookSendAttachmentVideo.attachmentType: FacebookSendAttachmentVideo.self,
        FacebookSendAttachmentFile.attachmentType: FacebookSendAttachmentFile.self,
        FacebookSendAttachmentTemplateHolder.attachmentType: FacebookSendAttachmentTemplateHolder.self
    ]

    public var registeredTemplateTypes: [FacebookSendAttachmentTemplateType: FacebookSendAttachmentTemplate.Type] = [
        FacebookSendAttachmentGenericTemplate.templateType: FacebookSendAttachmentGenericTemplate.self,
        FacebookSendAttachmentButtonTemplate.templateType: FacebookSendAttachmentButtonTemplate.self
    ]

    public var registeredButtonTypes: [FacebookSendButtonType: FacebookSendButton.Type] = [
        FacebookSendURLButton.type: FacebookSendURLButton.self,
        FacebookSendPostbackButton.type: FacebookSendPostbackButton.self,
        FacebookSendCallButton.type: FacebookSendCallButton.self,
        FacebookSendShareButton.type: FacebookSendShareButton.self
    ]

    public func sendMessageUrl(token: String) -> String {
        return "https://graph.facebook.com/v2.6/me/messages?access_token=\(token)"
    }

    public var defaultHeaders: [HeaderKey: String] {
        return [HeaderKey.contentType: "application/json"]
    }

    private init() {
    }

    public func send(client: ClientFactoryProtocol = EngineClientFactory(), facebookSend: FacebookSend, token: String) throws -> Response {
        let url = sendMessageUrl(token: token)

        let req = Request(method: .post, uri: url, headers: defaultHeaders)
        req.json = try facebookSend.makeJSON()

        return try client.respond(to: req)
    }

    public func sendAsync(client: ClientFactoryProtocol = EngineClientFactory(), facebookSend: FacebookSend, token: String, completion: ((_ response: Response?, _ error: Error?) -> Void)? = nil) {
        background {
            do {
                let response = try self.send(client: client, facebookSend: facebookSend, token: token)
                completion?(response, nil)
            } catch {
                completion?(nil, error)
            }
        }
    }
}
