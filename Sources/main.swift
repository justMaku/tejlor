import Foundation

#if os(Linux)
    import Glibc
#else
    import Darwin.C
#endif

func debug(_ val: String) {
    print(val)
    fflush(stdout)
}

var runLoop = RunLoop.current

debug("Welcome to New York")

let irc = try! IRC(server: IRC.Server(host: "irc.freenode.net", port: 6667))
let hello = HelloPlugin()
let terms = TermsPlugin()

let bot = Bot(name: "tejlor")

bot.register(irc)
bot.register(hello)
bot.register(terms)

try? bot.connect()

debug("Bot started")

while (runLoop.run(mode: .defaultRunLoopMode, before: .distantFuture)) {}

debug("Quitting now, bye")
