// cmux にフォーカスが移ったらキーボード入力を英字 (ABC) に切り替える常駐ウォッチャー。
// launchd (local.cmux-ime-watcher) から起動される。install.sh が swiftc でビルドする。
// アクセシビリティ等の追加権限は不要。
import Cocoa
import Carbon

let targetBundleID = "com.cmuxterm.app"
let inputSourceID = "com.apple.keylayout.ABC"

func selectInputSource(id: String) {
    let filter = [kTISPropertyInputSourceID as String: id] as CFDictionary
    guard let cfList = TISCreateInputSourceList(filter, false)?.takeRetainedValue() else { return }
    let list = cfList as NSArray
    guard list.count > 0 else { return }
    let source = list[0] as! TISInputSource
    TISSelectInputSource(source)
}

NSWorkspace.shared.notificationCenter.addObserver(
    forName: NSWorkspace.didActivateApplicationNotification,
    object: nil,
    queue: .main
) { note in
    guard let app = note.userInfo?[NSWorkspace.applicationUserInfoKey] as? NSRunningApplication,
          app.bundleIdentifier == targetBundleID else { return }
    selectInputSource(id: inputSourceID)
}

RunLoop.main.run()
