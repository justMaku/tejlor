//
//  HelloPlugin.swift
//  Taylor
//
//  Created by Michał Kałużny on 10/04/2017.
//
//

import Foundation

class HelloPlugin: Plugin {
    
    func bot(_ bot: Bot, gateway: Gateway, joinedChannel channel:Channel) {
        gateway.send("Siema, co tam?", to: .channel(channel: channel))
    }
}
