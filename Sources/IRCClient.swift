//
//  IRCClient.swift
//  Taylor
//
//  Created by Michał Kałużny on 04/04/2017.
//
//

import Foundation
import Dispatch
import Socket
import Rexy

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
    case PING
    case PONG
}

struct Message {
    enum Prefix {
        case server(name: String)
        case user(user: String)
    }
    
    enum Command: String {
        case NOTICE
        case JOIN
        case PRIVMSG
        case USER
        case NICK
        case ERROR
        case PING
        case PONG
    }
    
    let command: Command
    let arguments: [String]
    
    init(command: Command, arguments: [String]) {
        self.command = command
        self.arguments = arguments
    }
    
    init?(line: String) {
        let RFC2812ParsingRegexp = try? Regex("^(:[^ ]+ )?([a-zA-Z]+|[0-9]{3})( .+)?$")
        guard var groups = RFC2812ParsingRegexp?.groups(line) else {
            return nil
        }
        
        guard groups.count > 0 else {
            return nil
        }
        
        let prefixString: String?
        if groups.first?.characters.first == ":" {
            prefixString = groups.removeFirst()
        } else {
            prefixString = nil
        }
    
        guard groups.count > 0 else {
            return nil
        }
        
        let commandString = groups.removeFirst()
        
        let paramsString: String?
        if groups.count > 0 {
            paramsString = groups.removeFirst().trimmingCharacters(in: .whitespaces)
        } else {
            paramsString = nil
        }
        
        var params: [String] = paramsString?.components(separatedBy: " :") ?? []
        
        if paramsString?.characters.first != ":" {
            let middle = params.removeFirst().components(separatedBy: " ")
            params = middle + params
        }
        
        guard let command = Command(rawValue: commandString) else {
            return nil
        }
        
        self.init(command: command, arguments: params)
    }
    
    var string: String {
        let argumentsString = arguments
            .map { $0.contains(" ") ? ":\($0)" : $0 }
            .joined(separator: " ")
        return "\(command.rawValue) \(argumentsString)"
    }
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
    
    func send(_ message: String, to context: Context) {
        try? self.send(.PRIVMSG, [context.uuid, message])
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
                DispatchQueue.main.async {
                    self.parse(data: data)
                }
            } catch {
                break
            }
        }
        self.socket.close()
    }
    
    private func parse(data: String) {
        if data.isEmpty {
            return
        }
        
        let lines = data.components(separatedBy: .newlines)
        
        for line in lines {
            
            if line.isEmpty {
                continue
            }
            
            print("[SERVER] \(line)")
            
            guard let message = Message(line: line) else {
                continue
            }
            
            handle(message)
        }
    }
    
    private func handle(_ message: Message) {
        switch message.command {
        case .NOTICE:
            state = .connected
        case .ERROR:
            state = .disconnected
        case .JOIN:
            self.delegate?.gateway(self, joinedChannel: Channel(UUID: message.arguments.first!))
        case .PRIVMSG:
            let context: Context
            let source = message.arguments[0]
            if source.characters.first == "#" {
                context = .channel(channel: Channel(UUID: source))
            } else {
                context = .user(user: User(UUID: source))
            }
            
            self.delegate?.gateway(self, receivedMessage: message.arguments[1], context: context)
        case .PING:
            try? self.send(.PONG, message.arguments)
        default:
            print("No idea how to handle this, waving hands")
        }
    }
    
    private func send(_ command: Message.Command, _ arguments: [String]) throws {
        try send(Message(command: command, arguments: arguments))
    }
    
    private func send(_ message: Message) throws {
        guard self.connected else {
            return
        }
        
        print("[CLIENT] \(message.string)")
        try socket.write(from: "\(message.string)\n")
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
