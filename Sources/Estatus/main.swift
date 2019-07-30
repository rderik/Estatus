import Console
import Command

let container = BasicContainer(config: Config(), environment: Environment.production, services: Services(), on: EmbeddedEventLoop())

var commandConfig = CommandConfig()
commandConfig.use(BatteryCommand(), as: "batt", isDefault: true)
commandConfig.use(IfconfigCommand(), as: "ifconfig")
commandConfig.use(DFCommand(), as: "disk")
container.services.register(commandConfig)

let group = try commandConfig.resolve(for: container).group()

var commandInput = CommandInput(arguments: CommandLine.arguments)
let terminal = Terminal()
try terminal.run(group, input: &commandInput, on: container).wait()
