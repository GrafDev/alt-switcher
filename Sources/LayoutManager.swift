import Foundation
import Carbon

class LayoutManager {
    static func switchLayout() {
        let inputSource = TISCopyCurrentKeyboardInputSource().takeRetainedValue()
        
        // Получаем список всех включенных раскладок
        let inputSourceList = TISCreateInputSourceList(nil, false).takeRetainedValue() as! [TISInputSource]
        
        // Фильтруем только клавиатурные раскладки
        let keyboardLayouts = inputSourceList.filter { source in
            let categoryPtr = TISGetInputSourceProperty(source, kTISPropertyInputSourceCategory)
            if let categoryPtr = categoryPtr {
                let category = Unmanaged<CFString>.fromOpaque(categoryPtr).takeUnretainedValue() as String
                return category == (kTISCategoryKeyboardInputSource as String)
            }
            return false
        }
        
        if keyboardLayouts.count < 2 { return }
        
        // Находим текущую
        let currentIDPtr = TISGetInputSourceProperty(inputSource, kTISPropertyInputSourceID)
        let currentID = Unmanaged<CFString>.fromOpaque(currentIDPtr!).takeUnretainedValue() as String
        
        // Ищем индекс текущей, чтобы переключить на следующую
        if let currentIndex = keyboardLayouts.firstIndex(where: {
            let idPtr = TISGetInputSourceProperty($0, kTISPropertyInputSourceID)
            let id = Unmanaged<CFString>.fromOpaque(idPtr!).takeUnretainedValue() as String
            return id == currentID
        }) {
            let nextIndex = (currentIndex + 1) % keyboardLayouts.count
            let nextSource = keyboardLayouts[nextIndex]
            TISSelectInputSource(nextSource)
        }
    }
}
