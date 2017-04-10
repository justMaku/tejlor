
//let connection = try? Connection(server: Server(host: "irc.freenode.net", port: 6667))
//try? connection?.connect()
//print("Connected")
//
//while true {
//    print("Command: ")
//    guard let command = readLine() else {
//        break
//    }
//    try? connection?.send(command: command)
//}

let irc = try! IRC(server: IRC.Server(host: "irc.freenode.net", port: 6667))
let hello = HelloPlugin()
let terms = TermsPlugin()

let bot = Bot(name: "tejlor")

bot.register(irc)
bot.register(hello)
bot.register(terms)

try? bot.connect()
while (true) {
    guard let command = readLine() else {
        continue
    }
    
    print("> \(command)")
}
