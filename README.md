# Vapor 4 + SMTP

Add this library to `Package.swift`

```swift
.package(url: "https://github.com/Joannis/VaporSMTPKit.git", from: "1.0.0")
```

Add the target `"VaporSMTPKit"` to your own target's dependencies.
In Swift 5.2 manifests, this looks like the following:

```swift
.product(name: "VaporSMTPKit", package: "VaporSMTPKit"),
```

## Setup

```swift
import VaporSMTPKit

extension SMTPCredentials {
    static var `default`: SMTPCredentials {
        return SMTPCredentials(
            hostname: "smtp.example.com",
            ssl: .startTLS(configuration: .default),
            email: "noreply@example.com",
            password: "<SECRET>"
        )
    }
}
```

### Sending a Mail

```swift
import SMTPKitten

app.get { request -> EventLoopFuture<String> in
    let email = Mail(
        from: MailUser(name: "Noreply", email: "noreply@example.com"),
        to: [
            MailUser(name: "Myself", email: "me@example.com")
        ],
        subject: "Your new mail server!",
        contentType: .plain,
        text: "You've set up mail!"
    )
    
    return request.application.sendMail(email, withCredentials: .default).map { 
        return "Check your mail!"
    }
}
```
