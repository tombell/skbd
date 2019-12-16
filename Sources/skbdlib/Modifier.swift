import Carbon

public class Modifier {
    public static func flags(for modifiers: [String]) -> UInt32 {
        let mods = modifiers.map { $0.uppercased() }

        var flags = 0

        if mods.contains("SHIFT") {
            flags |= shiftKey
        }

        if mods.contains("CTRL") || mods.contains("CONTROL") {
            flags |= controlKey
        }

        if mods.contains("ALT") || mods.contains("OPT") || mods.contains("OPTION") {
            flags |= optionKey
        }

        if mods.contains("CMD") || mods.contains("COMMAND") {
            flags |= cmdKey
        }

        return UInt32(flags)
    }
}
