import Vapor
import SMTPKitten

extension Application {
    
    public func sendMail(
        _ mail: Mail,
        withCredentials credentials: SMTPCredentials,
        preventedDomains: Set<String> = ["example.com"]
    ) async throws {
        try await sendMails([mail], withCredentials: credentials, preventedDomains: preventedDomains)
    }
    
    public func sendMails(
        _ mails: [Mail],
        withCredentials credentials: SMTPCredentials,
        preventedDomains: Set<String> = ["example.com"]
    ) async throws {
        func filterMailAddress(_ address: MailUser) -> Bool {
            for domain in preventedDomains {
                if address.email.contains(domain) {
                    return false
                }
            }
            
            return true
        }
        
        let filteredMails = mails.compactMap { mail -> Mail? in
            var mail = mail
            
            mail.to = mail.to.filter(filterMailAddress)
            mail.cc = mail.cc.filter(filterMailAddress)
            mail.bcc = mail.bcc.filter(filterMailAddress)
            
            if mail.to.isEmpty {
                return nil
            }
            
            return mail
        }
        
        let client = try await SMTPClient.connect(
            hostname: credentials.hostname,
            port: credentials.port,
            ssl: credentials.ssl
        )
        
        try await client.login(
            user: credentials.email,
            password: credentials.password
        )
        
        let sent: () = await withThrowingTaskGroup(of: Void.self) { group in
            for mail in filteredMails {
                group.addTask {
                    try await client.sendMail(mail)
                }
            }
        }
        
        _ = sent
    }
}

public struct SMTPCredentials {
    let hostname: String
    let port: Int
    let email: String
    let ssl: SMTPSSLMode
    let password: String
    
    public init(
        hostname: String,
        port: Int = 587,
        ssl: SMTPSSLMode,
        email: String,
        password: String
    ) {
        self.hostname = hostname
        self.port = port
        self.ssl = ssl
        self.email = email
        self.password = password
    }
}
