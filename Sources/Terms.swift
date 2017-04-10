//
//  Terms.swift
//  Taylor
//
//  Created by Michał Kałużny on 10/04/2017.
//
//

import Foundation

class TermsPlugin: Plugin {
    
    func bot(_ bot: Bot, gateway: Gateway, receivedMessage message: String, context: Context) {
        guard message == ",_," else {
            return
        }
        
        gateway.send("JAKIS PROBLEM KURWA?!?", to: context)
    }
}
