import Carbon

let relocatableKeyCodes = [
    kVK_ANSI_A, kVK_ANSI_B, kVK_ANSI_C, kVK_ANSI_D, kVK_ANSI_E,
    kVK_ANSI_F, kVK_ANSI_G, kVK_ANSI_H, kVK_ANSI_I, kVK_ANSI_J,
    kVK_ANSI_K, kVK_ANSI_L, kVK_ANSI_M, kVK_ANSI_N, kVK_ANSI_O,
    kVK_ANSI_P, kVK_ANSI_Q, kVK_ANSI_R, kVK_ANSI_S, kVK_ANSI_T,
    kVK_ANSI_U, kVK_ANSI_V, kVK_ANSI_W, kVK_ANSI_X, kVK_ANSI_Y,
    kVK_ANSI_Z,

    kVK_ANSI_0, kVK_ANSI_1, kVK_ANSI_2, kVK_ANSI_3, kVK_ANSI_4,
    kVK_ANSI_5, kVK_ANSI_6, kVK_ANSI_7, kVK_ANSI_8, kVK_ANSI_9,

    kVK_ANSI_Period,
    kVK_ANSI_Quote,
    kVK_ANSI_RightBracket,
    kVK_ANSI_Semicolon,
    kVK_ANSI_Slash,
    kVK_ANSI_Backslash,
    kVK_ANSI_Comma,
    kVK_ANSI_Equal,
    kVK_ANSI_Grave,
    kVK_ANSI_LeftBracket,
    kVK_ANSI_Minus,
]

let keyToCode = [
    "SPACE": kVK_Space,
    "TAB": kVK_Tab,
    "RETURN": kVK_Return,

    "CAPSLOCK": kVK_CapsLock,

    "PAGE_UP": kVK_PageUp,
    "PAGE_DOWN": kVK_PageDown,
    "HOME": kVK_Home,
    "END": kVK_End,
    "UP": kVK_UpArrow,
    "RIGHT": kVK_RightArrow,
    "DOWN": kVK_DownArrow,
    "LEFT": kVK_LeftArrow,

    "F1": kVK_F1,
    "F2": kVK_F2,
    "F3": kVK_F3,
    "F4": kVK_F4,
    "F5": kVK_F5,
    "F6": kVK_F6,
    "F7": kVK_F7,
    "F8": kVK_F8,
    "F9": kVK_F9,
    "F10": kVK_F10,
    "F11": kVK_F11,
    "F12": kVK_F12,
    "F13": kVK_F13,
    "F14": kVK_F14,
    "F15": kVK_F15,
    "F16": kVK_F16,
    "F17": kVK_F17,
    "F18": kVK_F18,
    "F19": kVK_F19,
    "F20": kVK_F20,

    "ESCAPE": kVK_Escape,
    "DELETE": kVK_Delete,
]

public class Key {
    private static let relocatableKeys: [String: Int] = {
        var keys = [String: Int]()

        let source = TISCopyCurrentASCIICapableKeyboardLayoutInputSource().takeUnretainedValue()
        let dataRefPtr = TISGetInputSourceProperty(source, kTISPropertyUnicodeKeyLayoutData)
        let dataRef = unsafeBitCast(dataRefPtr, to: CFData.self)
        let data = unsafeBitCast(CFDataGetBytePtr(dataRef), to: UnsafePointer<UCKeyboardLayout>.self)

        for keyCode in relocatableKeyCodes {
            var deadKeyState: UInt32 = 0
            let maxLength = 255
            var length = 0
            var chars = [UniChar](repeating: 0, count: maxLength)

            UCKeyTranslate(
                data,
                UInt16(keyCode),
                UInt16(kUCKeyActionDisplay),
                0,
                UInt32(LMGetKbdType()),
                OptionBits(kUCKeyTranslateNoDeadKeysBit),
                &deadKeyState,
                maxLength,
                &length,
                &chars
            )

            if length == 0 {
                continue
            }

            let key = String(utf16CodeUnits: &chars, count: length)
            keys[key.uppercased()] = keyCode
        }

        return keys
    }()

    public static func code(for key: String) -> UInt32 {
        if let keyCode = relocatableKeys[key.uppercased()] {
            return UInt32(keyCode)
        }

        return UInt32(keyToCode[key.uppercased()] ?? 0)
    }
}
