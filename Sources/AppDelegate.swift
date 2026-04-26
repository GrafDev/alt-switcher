import AppKit
import ApplicationServices

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem!
    var keylogger: Keylogger!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        setupMenu()
        
        // Запрашиваем права Accessibility
        checkAccessibilityPermissions()
        
        keylogger = Keylogger()
        keylogger.start()
    }
    
    func setupMenu() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusItem.button {
            button.title = "A" // Временная иконка
        }
        
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Quit AltSwitcher", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        statusItem.menu = menu
    }
    
    func checkAccessibilityPermissions() {
        let options: NSDictionary = [kAXTrustedCheckOptionPrompt.takeRetainedValue() as NSString: true]
        let accessEnabled = AXIsProcessTrustedWithOptions(options)
        
        if !accessEnabled {
            print("ВНИМАНИЕ: Нет прав Accessibility! Приложение не сможет перехватывать нажатия.")
            // Открываем настройки безопасности
            let alert = NSAlert()
            alert.messageText = "Требуются права доступа"
            alert.informativeText = "Пожалуйста, предоставьте AltSwitcher доступ к Универсальному доступу (Accessibility) в Системных настройках."
            alert.alertStyle = .warning
            alert.addButton(withTitle: "Открыть настройки")
            alert.addButton(withTitle: "Отмена")
            
            if alert.runModal() == .alertFirstButtonReturn {
                NSWorkspace.shared.open(URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility")!)
            }
        } else {
            print("Права Accessibility получены.")
        }
    }
}
