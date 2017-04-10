
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

import Rexy

//do {
//    let RFC2812ParsingRegexp = try Regex("^(?::(([^@! ]*)(?:(?:!([^@]*))?@([^ ]*))?) )?([^ ]+)((?: [^: ][^ ]*){0,14})(?: :?(.*))?$", flags: [.extended, .newLineSensitive])
//} catch let error {
//    print(error)
//}


let irc = try! IRC(server: IRC.Server(host: "irc.freenode.net", port: 6667))
let hello = HelloPlugin()
let terms = TermsPlugin()

let bot = Bot(name: "tejlor")

bot.register(irc)
bot.register(hello)
bot.register(terms)

try? bot.connect()

while true {
    let command = readLine()
    print(command)
}
