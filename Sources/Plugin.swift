//
//  Plugin.swift
//  Taylor
//
//  Created by Michał Kałużny on 10/04/2017.
//
//

import Foundation

protocol Plugin {

    func bot(_ bot: Bot, gateway: Gateway, joinedServer server: Server)
    func bot(_ bot: Bot, gateway: Gateway, leftServer server: Server)
    
    func bot(_ bot: Bot, gateway: Gateway, joinedChannel channel: Channel)
    func bot(_ bot: Bot, gateway: Gateway, leftChannel channel: Channel)
    
    func bot(_ bot: Bot, gateway: Gateway, receivedMessage message: String, context: Context)
    
}

extension Plugin {
    func bot(_ bot: Bot, gateway: Gateway, joinedServer:Server) {}
    func bot(_ bot: Bot, gateway: Gateway, leftServer:Server) {}
    
    func bot(_ bot: Bot, gateway: Gateway, joinedChannel:Channel) {}
    func bot(_ bot: Bot, gateway: Gateway, leftChannel:Channel) {}
    
    func bot(_ bot: Bot, gateway: Gateway, receivedMessage message:String, context: Context) {}
}
