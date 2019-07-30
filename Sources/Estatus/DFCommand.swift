import Foundation
import Command

struct DFCommand: Command {
    
    var arguments: [CommandArgument] {
        return [.argument(name: "style")]
    }
    
    var options: [CommandOption] {
        return []
    }
    var help: [String] {
      return ["Usage:", "Estatus disk [style=human|bytes]"]
    }

    func run(using context: CommandContext) throws -> Future<Void> {
      let pmset = Process()
      let pipe = Pipe()
      if #available(OSX 13, *) {
        pmset.executableURL = URL(fileURLWithPath: "/usr/bin/env")
      } else {
        pmset.launchPath = "/usr/bin/env"
      }
      pmset.arguments = ["df"]

      let style = try context.argument("style")
      switch style {
      case "human":
        pmset.arguments?.append("-h")
      case "bytes":
        pmset.arguments?.append("-b")
      default:
        throw EstatusError.invalidArgument
      }

      pmset.standardOutput = pipe
      do {
      if #available(OSX 13, *) {
        try pmset.run()
      } else {
        pmset.launch()
      }
        pmset.waitUntilExit()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        if let output = String(data: data, encoding: String.Encoding.utf8) {
          context.console.print(output)
        }
      }
      return .done(on: context.container)
    }
}
