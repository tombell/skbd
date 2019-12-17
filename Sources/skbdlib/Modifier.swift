import Carbon

public class Modifier {
    public static func flags(for modifiers: [String]) -> UInt32 {
        let mods = modifiers.map { $0.lowercased() }

        var flags = 0

        if mods.contains("shift") {
            flags |= shiftKey
        }

        if mods.contains("ctrl") || mods.contains("control") {
            flags |= controlKey
        }

        if mods.contains("alt") || mods.contains("opt") || mods.contains("option") {
            flags |= optionKey
        }

        if mods.contains("cmd") || mods.contains("command") {
            flags |= cmdKey
        }

        return UInt32(flags)
    }
}
