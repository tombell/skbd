import Carbon

public class KeybindController {
    final class KeybindBox {
        let identifier: UUID

        weak var keybind: Keybind?
        let carbonHotKeyID: UInt32

        var carbonEventHotKey: EventHotKeyRef?

        init(keybind: Keybind, carbonHotKeyID: UInt32) {
            identifier = keybind.identifier

            self.keybind = keybind
            self.carbonHotKeyID = carbonHotKeyID
        }
    }

    private static let signature = UTGetOSTypeFromString("SKBD" as CFString)

    private static var keybinds = [UInt32: KeybindBox]()
    private static var keybindsCount: UInt32 = 0

    private static var eventHandler: EventHandlerRef?

    static func handleCarbonEvent(_ event: EventRef?) -> OSStatus {
        guard let event = event else {
            return OSStatus(eventNotHandledErr)
        }

        var hotKeyID = EventHotKeyID()

        let err = GetEventParameter(
            event,
            UInt32(kEventParamDirectObject),
            UInt32(typeEventHotKeyID),
            nil,
            MemoryLayout<EventHotKeyID>.size,
            nil,
            &hotKeyID
        )

        if err != noErr {
            return err
        }

        guard hotKeyID.signature == signature, let keybind = self.keybind(for: hotKeyID.id) else {
            return OSStatus(eventNotHandledErr)
        }

        if let handler = keybind.handler {
            handler()
            return noErr
        }

        return OSStatus(eventNotHandledErr)
    }

    public static func register(keybind: Keybind) {
        if keybinds.values.contains(where: { $0.identifier == keybind.identifier }) {
            return
        }

        keybindsCount += 1

        let box = KeybindBox(keybind: keybind, carbonHotKeyID: keybindsCount)
        keybinds[box.carbonHotKeyID] = box

        let eventHotKeyID = EventHotKeyID(signature: signature, id: box.carbonHotKeyID)
        var eventHotKeyRef: EventHotKeyRef?

        let registerErr = RegisterEventHotKey(
            keybind.carbonKeyCode,
            keybind.carbonModifiers,
            eventHotKeyID,
            GetEventDispatcherTarget(),
            0,
            &eventHotKeyRef
        )

        guard registerErr == noErr, eventHotKeyRef != nil else {
            return
        }

        box.carbonEventHotKey = eventHotKeyRef
    }

    public static func unregister(keybind: Keybind) {
        guard let box = self.box(for: keybind) else {
            return
        }

        UnregisterEventHotKey(box.carbonEventHotKey)

        box.keybind = nil
        keybinds.removeValue(forKey: box.carbonHotKeyID)
    }

    public static func start() {
        if keybindsCount == 0 || eventHandler != nil {
            return
        }

        let eventSpec = [
            EventTypeSpec(eventClass: OSType(kEventClassKeyboard), eventKind: UInt32(kEventHotKeyPressed)),
        ]

        InstallEventHandler(GetEventDispatcherTarget(), keybindEventHandler, 1, eventSpec, nil, &eventHandler)
    }

    public static func stop() {
        if eventHandler == nil {
            return
        }

        RemoveEventHandler(eventHandler)
    }

    private static func keybind(for id: UInt32) -> Keybind? {
        if let keybind = keybinds[id]?.keybind {
            return keybind
        }

        keybinds.removeValue(forKey: id)
        return nil
    }

    private static func box(for keybind: Keybind) -> KeybindBox? {
        for box in keybinds.values where box.identifier == keybind.identifier {
            return box
        }

        return nil
    }
}

private func keybindEventHandler(_: EventHandlerCallRef?, event: EventRef?, _: UnsafeMutableRawPointer?) -> OSStatus {
    KeybindController.handleCarbonEvent(event)
}
