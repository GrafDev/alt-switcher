import Cocoa
import CoreGraphics

class Keylogger {
    private var eventTap: CFMachPort?
    private var runLoopSource: CFRunLoopSource?
    
    var ringBuffer = RingBuffer()
    
    // Флаг, чтобы игнорировать программно сгенерированные события
    private var isSimulating = false
    
    func start() {
        let eventMask = (1 << CGEventType.keyDown.rawValue) | (1 << CGEventType.flagsChanged.rawValue)
        
        let callback: CGEventTapCallBack = { (proxy, type, event, refcon) -> Unmanaged<CGEvent>? in
            guard let refcon = refcon else { return Unmanaged.passRetained(event) }
            let keylogger = Unmanaged<Keylogger>.fromOpaque(refcon).takeUnretainedValue()
            return keylogger.handleEvent(proxy: proxy, type: type, event: event)
        }
        
        let ptr = Unmanaged.passUnretained(self).toOpaque()
        
        eventTap = CGEvent.tapCreate(
            tap: .cgSessionEventTap,
            place: .headInsertEventTap,
            options: .defaultTap,
            eventsOfInterest: CGEventMask(eventMask),
            callback: callback,
            userInfo: ptr
        )
        
        guard let tap = eventTap else {
            print("Ошибка: не удалось создать EventTap. Проверьте права Accessibility.")
            return
        }
        
        runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, tap, 0)
        CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
        CGEvent.tapEnable(tap: tap, enable: true)
        print("Keylogger запущен.")
    }
    
    func stop() {
        if let tap = eventTap {
            CGEvent.tapEnable(tap: tap, enable: false)
        }
        if let source = runLoopSource {
            CFRunLoopRemoveSource(CFRunLoopGetCurrent(), source, .commonModes)
        }
    }
    
    private func handleEvent(proxy: CGEventTapProxy, type: CGEventType, event: CGEvent) -> Unmanaged<CGEvent>? {
        if isSimulating {
            return Unmanaged.passRetained(event)
        }
        
        if type == .keyDown {
            let keycode = event.getIntegerValueField(.keyboardEventKeycode)
            
            // Если нажат F12 (keycode 111) — запускаем замену!
            if keycode == 111 {
                print("Сработал горячий ключ (F12)!")
                DispatchQueue.global().async {
                    self.performSwitch()
                }
                // Блокируем передачу F12 дальше в систему
                return nil
            }
            
            // Backspace стирает из буфера
            if keycode == 51 {
                ringBuffer.removeLast()
                return Unmanaged.passRetained(event)
            }
            
            // Space (49) или Enter (36) — очищают буфер (конец слова)
            if keycode == 49 || keycode == 36 {
                ringBuffer.clear()
                return Unmanaged.passRetained(event)
            }
            
            var length = 0
            var chars = [UniChar](repeating: 0, count: 4)
            event.keyboardGetUnicodeString(maxStringLength: 4, actualStringLength: &length, unicodeString: &chars)
            
            if length > 0 {
                let text = String(utf16CodeUnits: chars, count: length)
                ringBuffer.append(text)
            }
        }
        
        return Unmanaged.passRetained(event)
    }
    
    private func performSwitch() {
        let currentWord = ringBuffer.joinedString
        guard !currentWord.isEmpty else { return }
        
        print("Слово для замены: \(currentWord)")
        
        isSimulating = true
        
        // 1. Конвертируем слово
        let convertedWord = LayoutMapper.convert(currentWord)
        
        // 2. Меняем раскладку
        LayoutManager.switchLayout()
        
        // Даем системе чуть времени на смену раскладки
        Thread.sleep(forTimeInterval: 0.1)
        
        // 3. Стираем текущее слово
        let length = ringBuffer.count
        for _ in 0..<length {
            let eventDown = CGEvent(keyboardEventSource: nil, virtualKey: 51, keyDown: true)
            let eventUp = CGEvent(keyboardEventSource: nil, virtualKey: 51, keyDown: false)
            eventDown?.post(tap: .cghidEventTap)
            eventUp?.post(tap: .cghidEventTap)
            Thread.sleep(forTimeInterval: 0.005)
        }
        
        // 4. Печатаем новое слово
        let utf16Chars = Array(convertedWord.utf16)
        let eventDown = CGEvent(keyboardEventSource: nil, virtualKey: 0, keyDown: true)
        eventDown?.keyboardSetUnicodeString(stringLength: utf16Chars.count, unicodeString: utf16Chars)
        eventDown?.post(tap: .cghidEventTap)
        
        let eventUp = CGEvent(keyboardEventSource: nil, virtualKey: 0, keyDown: false)
        eventUp?.keyboardSetUnicodeString(stringLength: utf16Chars.count, unicodeString: utf16Chars)
        eventUp?.post(tap: .cghidEventTap)
        
        // Очищаем буфер, так как слово заменено
        ringBuffer.clear()
        
        Thread.sleep(forTimeInterval: 0.05)
        isSimulating = false
    }
}
