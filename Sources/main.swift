import Foundation

//disable output buffering
setbuf(__stdoutp, nil);

var runLoop = RunLoop.current

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

while (runLoop.run(mode: .defaultRunLoopMode, before: Date.distantFuture)) {
    // do nothing
}

print("Quitting now, bye")
