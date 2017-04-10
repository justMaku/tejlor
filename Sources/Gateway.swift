//
//  Gateway.swift
//  Taylor
//
//  Created by Michał Kałużny on 10/04/2017.
//
//

import Foundation

struct Message {
    var content: String
}

protocol Server {}

struct User {
    let UUID: String
}

struct Channel {
    let UUID: String
}

enum Context {
    case channel(channel: Channel)
    case user(user: User)
    
    var uuid: String {
        switch self {
        case .channel(let channel): return channel.UUID
        case .user(let user): return user.UUID
        }
    }
}

protocol GatewayDelegate {
    func gateway(_ gateway: Gateway, joinedServer server: Server)
    func gateway(_ gateway: Gateway, leftServer server: Server)

    func gateway(_ gateway: Gateway, joinedChannel channel: Channel)
    func gateway(_ gateway: Gateway, leftChannel channel: Channel)

    func gateway(_ gateway: Gateway, receivedMessage message: Message, context: Context)
}

enum GatewayState {
    case disconnected
    case connecting
    case connected
}

protocol Gateway {
    var state: GatewayState { get }
    var delegate: GatewayDelegate? { get set }
    
    func connect() throws
    func disconnect()
    func join(_ channel: Channel)
    func send(_ message: Message, to context: Context)
}

extension Gateway {
    var connected: Bool {
        return state == .connected
    }
}
