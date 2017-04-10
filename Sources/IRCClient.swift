//
//  IRCClient.swift
//  Taylor
//
//  Created by Michał Kałużny on 04/04/2017.
//
//

import Foundation
import Socket

extension String {
    /// An `NSRange` that represents the full range of the string.
    var range: NSRange {
        return NSRange(location: 0, length: utf16.count)
    }
}



enum Command: String {
    case NOTICE
    case JOIN
    case PRIVMSG
    case USER
    case NICK
    case ERROR
}

class IRC: Gateway {
    
    struct Server {
        let host: String
        let port: Int32
    }
    
    let server: Server
    let nick = "Tejlorowa"
    let channel = "#taylortesting"
    
    var state: GatewayState = .disconnected {
        didSet {
            if oldValue != state {
                didChangeState(to: state)
            }
        }
    }
    var delegate: GatewayDelegate? = nil
    
    private let socket: Socket
    
    private var loopOperation: BlockOperation? = nil
    private let loopQueue = OperationQueue()
    
    init(server: Server) throws {
        self.server = server
        self.socket = try Socket.create()
        loopQueue.qualityOfService = .userInteractive
    }
    
    func connect() throws {
        try socket.connect(to: server.host, port: server.port)
        loopQueue.addOperation(loop)
        state = .connecting
    }
    
    func disconnect() {
        socket.close()
        self.state = .disconnected
    }
    
    func send(_ message: Message, to context: Context) {
        try? self.send(.PRIVMSG, [context.uuid, message.content])
    }
    
    func join(_ channel: Channel) {
        try? self.send(.JOIN, [channel.UUID])
    }
    
    func loop() {
        while (self.socket.isConnected) {
            do {
                guard let data = try self.socket.readString() else {
                    break
                }
                self.parse(data: data)
            } catch {
                break
            }
        }
        self.socket.close()
    }
    
    
    static let RFC2812ParsingRegexp = try? NSRegularExpression(pattern: "^(?::(([^@! ]*)(?:(?:!([^@]*))?@([^ ]*))?) )?([^ ]+)((?: [^: ][^ ]*){0,14})(?: :?(.*))?$",
                                          options: [.anchorsMatchLines])
    
    private func parse(data: String) {
        if data.isEmpty {
            return
        }
        
        let lines = data.components(separatedBy: .newlines)
        
        for line in lines {
            
            if line.isEmpty {
                continue
            }

            guard let match = IRC.RFC2812ParsingRegexp?.matches(in: line, options: [], range: line.range).first else {
                print("Line doesn't match?")
                continue
            }
            
            print("[SERVER] \(line)")
            
            var components: [String?] = []
            for i in 0..<match.numberOfRanges {
                let range = match.rangeAt(i)
                
                let string: String?
                if range.location > line.characters.count {
                    string = nil
                } else {
                    string = (line as NSString).substring(with: range)
                }
                components.append(string)
            }
            
            guard let commandValue = components[5] else { continue }
            guard let command = Command(rawValue: commandValue) else {
                continue
            }
            
            var arguments: [String] = []
            
            func extract(argumentString: String?) -> [String] {
                guard let string = argumentString else { return [] }
                
                return string.components(separatedBy: .whitespaces).filter { $0.isEmpty == false }
            }
            
//            let arguments = components[6]?
//                .components(separatedBy: .whitespaces)
//                .append(contentsOf: components[7]?.components(separatedBy: .whitespaces))
//                .filter { $0.isEmpty == false }
            
            arguments.append(contentsOf: extract(argumentString: components[6]))
            arguments.append(contentsOf: extract(argumentString: components[7]))

            dump(components)
            dump(arguments)
            handle(command, arguments: arguments)
        }
    }
    
    private func handle(_ command: Command, arguments: [String]) {
        switch command {
        case .NOTICE:
            state = .connected
        case .ERROR:
            state = .disconnected
        case .JOIN:
            self.delegate?.gateway(self, joinedChannel: Channel(UUID: arguments.first!))
        case .PRIVMSG:
            let context: Context
            let source = arguments.first!
            if source.characters.first == "#" {
                context = .channel(channel: Channel(UUID: source))
            } else {
                context = .user(user: User(UUID: source))
            }
            
            self.delegate?.gateway(self, receivedMessage: Message(content: arguments[1]), context: context)
        default:
            print("No idea how to handle this, waving hands")
        }
    }
    
    private func send(_ command: Command, _ arguments: [String] = []) throws {
        guard self.connected else {
            return
        }
        
        let argumentsString = arguments
            .map { $0.contains(" ") ? ":\($0)" : $0 }
            .joined(separator: " ")
        let command = "\(command.rawValue) \(argumentsString)"
        print("[CLIENT] \(command)")
        try socket.write(from: "\(command)\n")
    }
    
    private func didChangeState(to newState: GatewayState) {
        switch state {
        case .connected:
            try? send(.USER, [nick, "0", "*", "Taylor Swift"])
            try? send(.NICK, [nick])
            try? send(.JOIN, ["#taylortesting"])
        default:
            return
        }
    }
}
