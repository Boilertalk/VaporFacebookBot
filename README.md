<a href="https://github.com/Boilertalk/VaporFacebookBot">
  <img src="https://storage.googleapis.com/boilertalk/logo.svg" width="100%" height="256">
</a>

<p align="center">
  <a href="https://gitter.im/VaporFacebookBot/Lobby?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge">
    <img src="https://badges.gitter.im/VaporFacebookBot/Lobby.svg" alt="Join the chat at https://gitter.im/VaporFacebookBot/Lobby">
  </a>
  <a href="https://travis-ci.org/Boilertalk/VaporFacebookBot">
    <img src="https://travis-ci.org/Boilertalk/VaporFacebookBot.svg?branch=master" alt="Build Status">
  </a>
  <a href="https://github.com/Boilertalk/VaporFacebookBot/blob/master/LICENSE">
    <img src="https://img.shields.io/badge/license-MIT-brightgreen.svg?style=flat" alt="license">
  </a>
  <a href="https://swift.org">
    <img src="https://img.shields.io/badge/swift-3.1-brightgreen.svg?style=flat" alt="swift">
  </a>
  <a href="https://github.com/vapor/vapor">
    <img src="https://img.shields.io/badge/vapor-2.0-blue.svg?style=flat" alt="vapor">
  </a>
</p>

# :alembic: VaporFacebookBot

This library provides helpers for [Vapor 2](https://github.com/vapor/vapor) to interact with the [facebook bot api](https://developers.facebook.com/docs/messenger-platform). It simplifies the interaction with [the Send API](https://developers.facebook.com/docs/messenger-platform/send-api-reference) as well as parses incoming [webhooks](https://developers.facebook.com/docs/messenger-platform/webhook-reference) for you.

## :sparkles: Supported features

The following is a list with all features of the facebook Send API and webhooks as of May 2017 together with a note whether it is supported or not. If you find something that's not listed there please open an [issue](https://github.com/Boilertalk/VaporFacebookBot/issues).

### Webhooks

| Feature                        | Supported | Note                                            |
| ------------------------------ | --------- | ----------------------------------------------- |
| Parse and validate webhooks    | Yes       |                                                 |
| Message Received Callback      | Yes       |                                                 |
| Postback Received Webhook      | Yes       |                                                 |
| Other webhooks                 | No        | If you need more webhooks open an issue         |

### Send API

| Feature                        | Supported | Note                                            |
| ------------------------------ | --------- | ----------------------------------------------- |
| Interact with Send API         | Yes       |                                                 |
| Send to page scoped id         | Yes       |                                                 |
| Send to phone number           | Yes       |                                                 |
| Send sender_action             | Yes       | e.g.: `typing_on`, `typing_off`, `mark_seen`    |
| Add notification_type          | Yes       | e.g.: `REGULAR`, `SILENT_PUSH`, or `NO_PUSH`    |
| Send text messages             | Yes       |                                                 |
| Send quick_replies             | Yes       |                                                 |
| Add metadata to send request   | Yes       |                                                 |
| Send multimedia attachments    | Yes (url) | e.g.: `image`, `audio`, `video`, `file`         |
| Send with attachment reuse     | Yes       |                                                 |
| Binary multimedia upload       | No        | If you need it open an issue                    |
| Send template attachments      | Partially | See below...                                    |
| Generic Template               | Yes       |                                                 |
| Button Template                | Yes       |                                                 |
| Receipt Template               | No        | In development...                               |
| List Template                  | No        | In development...                               |
| Airline Templates              | No        | If you need it open an issue                    |
| Buttons                        | Partially | See below...                                    |
| URL Button                     | Yes       |                                                 |
| Postback Button                | Yes       |                                                 |
| Call Button                    | Yes       |                                                 |
| Share Button                   | Yes       |                                                 |
| Buy Button                     | No        | If you need it open an issue                    |
| Log In Button                  | No        | In development...                               |
| Log Out Button                 | No        | In development...                               |
| Message Tags                   | No        | If you need it open an issue                    |
| Auto parsing response          | No        | In development...                               |

## :package: Installation

This Swift package is intended to be used together with Vapor 2.0.    
Add the following line to your dependencies in the `Package.swift` file:

```Swift
.Package(url: "https://github.com/Boilertalk/VaporFacebookBot.git", majorVersion: 0)
```

Your `Package.swift` file should now look a little bit like the following:

```Swift
import PackageDescription

let package = Package(
    name: "MyAwesomeBot",
    targets: [
        Target(name: "App"),
        Target(name: "Run", dependencies: ["App"]),
    ],
    dependencies: [
        .Package(url: "https://github.com/vapor/vapor.git", majorVersion: 2),
        .Package(url: "https://github.com/vapor/fluent-provider.git", majorVersion: 1),
        .Package(url: "https://github.com/Boilertalk/VaporFacebookBot.git", majorVersion: 0)
    ],
    exclude: [
        "Config",
        "Database",
        "Localization",
        "Public",
        "Resources",
    ]
)
```

## :book: Documentation

### Webhooks

First of all import VaporFacebookBot:

```Swift
import VaporFacebookBot
```

Then you can parse facebook webhooks in your route:

```Swift
// builder is your RouteBuilder
builder.post("facebook") { request in

  // Parse json body onto a callback object
  if let j = request.json {
      let callback = try FacebookCallback(json: j)
      // Loop through all entries and messaging objects as described in the facebook documentation
      for e in callback.entry {
          for m in e.messaging {
              if let mR = m.messageReceived {
                  // We have a message received callback
                  if let text = mR.message.text {
                      // We have a text
                      print(text)
                  } else if let att = mR.message.attachments {
                      // We have some attachments
                      print(att.debugDescription)
                  }
              } else if let pR = m.postbackReceived {
                  // We have a postback received callback
                  // Do something with that...
              }
          }
      }
  }

  // Return 200 OK
  var json = JSON()
  try json.set("success", true)
  return json
}
```

You can basically access all non optional and optional values through these objects. For a complete list of available values refer to the [facebook bot documentation](https://developers.facebook.com/docs/messenger-platform/webhook-reference).

### Send API

> TODO: Add documentation for Send API...

## :rocket: Contributing

> TODO: Add information for contributors...
