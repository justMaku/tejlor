//
//  Plugin.swift
//  Taylor
//
//  Created by Michał Kałużny on 10/04/2017.
//
//

import Foundation

protocol Plugin {

    func bot(_ bot: Bot, gateway: Gateway, joinedServer:Server)
    func bot(_ bot: Bot, gateway: Gateway, leftServer:Server)
    
    func bot(_ bot: Bot, gateway: Gateway, joinedChannel:Channel)
    func bot(_ bot: Bot, gateway: Gateway, leftChannel:Channel)
    
    func bot(_ bot: Bot, gateway: Gateway, receivedMessage:Message, context: Context)
    
}

extension Plugin {
    func bot(_ bot: Bot, gateway: Gateway, joinedServer:Server) {}
    func bot(_ bot: Bot, gateway: Gateway, leftServer:Server) {}
    
    func bot(_ bot: Bot, gateway: Gateway, joinedChannel:Channel) {}
    func bot(_ bot: Bot, gateway: Gateway, leftChannel:Channel) {}
    
    func bot(_ bot: Bot, gateway: Gateway, receivedMessage:Message, context: Context) {}
}
