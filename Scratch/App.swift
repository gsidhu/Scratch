//
//  App.swift
//  Scratch
//
//  Created by Gurjot Sidhu on 26/08/23.
//
import SwiftUI
import MenuBarExtraAccess
import HotKey

extension NSImage.Name {
    static let icon = Self("StatusBarIcon")
}

class AppState: ObservableObject {
    @Published var isMenuPresented = false
}

let hotKey = HotKey(key: .escape, modifiers: [.command])

@main
struct ScratchApp: App {
//    @State var isMenuPresented: Bool = false
    @StateObject private var viewModel = ScratchViewModel()
    @NSApplicationDelegateAdaptor(ScratchStatusItem.self) var appDelegate
    @StateObject var appState: AppState = .init()
    
    init() {
        ScratchStatusItem.shared = appDelegate
    }

    var body: some Scene {
        Settings {
            EmptyView()
        }
        MenuBarExtra("Utility App", systemImage: "square.and.pencil") {
            ScratchPopoverView(viewModel: viewModel)
                .environmentObject(appState)
                .onAppear {
                    NotificationCenter.default.addObserver(forName: Notification.Name("HotkeyPressed"), object: nil, queue: .main) { _ in
                        appState.isMenuPresented.toggle()
                    }
                }
        }
        .menuBarExtraStyle(.window)
        .menuBarExtraAccess(isPresented: $appState.isMenuPresented) { statusItem in // <-- the magic ✨
             // access status item or store it in a @State var
            
        }
        
        Window("Scratch App", id: "window-view") {
            WindowView(viewModel: viewModel)
         }
    }
}

class ScratchStatusItem: NSObject, NSApplicationDelegate {
    static var shared: ScratchStatusItem!
    
    func applicationDidFinishLaunching(_: Notification) {
        hotKey.keyDownHandler = {
//            print("Key pressed")
            NotificationCenter.default.post(name: Notification.Name("HotkeyPressed"), object: nil)
        }
    }
}
