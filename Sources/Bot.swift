//
//  Bot.swift
//  Taylor
//
//  Created by Michał Kałużny on 10/04/2017.
//
//

import Foundation

class Bot {    
    let name: String
    fileprivate var gateways: [Gateway] = []
    fileprivate var plugins: [Plugin] = []
    
    init(name: String) {
        self.name = name
    }
    
    func register(_ plugin: Plugin) {
        plugins.append(plugin)
    }
    
    func register(_ gateway: Gateway) {
        var g = gateway
        g.delegate = self
        gateways.append(g)
    }
    
    func connect() throws {
        try gateways.filter { !$0.connected }.forEach { try $0.connect() }
    }
    
    func disconnect() {
        gateways.filter { $0.connected }.forEach { $0.disconnect() }
    }
}

extension Bot: GatewayDelegate {

    func gateway(_ gateway: Gateway, joinedServer server: Server) {
        plugins.forEach { $0.bot(self, gateway: gateway, joinedServer: server) }
    }
    
    func gateway(_ gateway: Gateway, leftServer server: Server) {
        plugins.forEach { $0.bot(self, gateway: gateway, leftServer: server) }
    }
    
    func gateway(_ gateway: Gateway, joinedChannel channel: Channel) {
        plugins.forEach { $0.bot(self, gateway: gateway, joinedChannel: channel) }
    }
    
    func gateway(_ gateway: Gateway, leftChannel channel: Channel) {
        plugins.forEach { $0.bot(self, gateway: gateway, leftChannel: channel) }
    }
    
    func gateway(_ gateway: Gateway, receivedMessage message: String, context: Context) {
        plugins.forEach { $0.bot(self, gateway: gateway, receivedMessage: message, context: context) }
    }
}
