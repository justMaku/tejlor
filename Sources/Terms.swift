//
//  Terms.swift
//  Taylor
//
//  Created by Michał Kałużny on 10/04/2017.
//
//

import Foundation

class TermsPlugin: Plugin {
    
    func bot(_ bot: Bot, gateway: Gateway, receivedMessage message: Message, context: Context) {
        guard message.content == ",_," else {
            return
        }
        
        gateway.send(Message(content: "JAKIS PROBLEM KURWA?!?"), to: context)
    }
}
