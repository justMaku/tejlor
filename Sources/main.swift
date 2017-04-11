import Foundation

let queue = OperationQueue()
queue.qualityOfService = .utility

queue.addOperation {
    print("Welcome to New York")
    
    let irc = try! IRC(server: IRC.Server(host: "irc.freenode.net", port: 6667))
    let hello = HelloPlugin()
    let terms = TermsPlugin()
    
    let bot = Bot(name: "tejlor")
    
    bot.register(irc)
    bot.register(hello)
    bot.register(terms)
    
    try? bot.connect()
    
    print("Bot started")
}

Thread.sleep(until: Date.distantFuture)
print("Quitting now, bye")
