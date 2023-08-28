//
//  View.swift
//  Scratch
//
//  Created by Gurjot Sidhu on 26/08/23.
//
import SwiftUI

class ScratchViewModel: ObservableObject {
    @AppStorage("textContent") var textContent: String = ""
}

struct ScratchPopoverView: View {
//    @StateObject private var viewModel = ScratchViewModel()
    @ObservedObject var viewModel: ScratchViewModel
//    @State private var isContentViewPresented = false
    @Environment(\.openWindow) var openWindow
//    @Binding var isMenuPresented: Bool
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        ZStack {
            Color.white
            
            VStack(alignment: .leading, spacing: 8) {
                // HStack with Icon and Text
                HStack {
                    Spacer()
                    Image(systemName: "scribble.variable")
                    Text("Keep Scratching")
                        .foregroundColor(Color.black)
                        .font(.system(.headline, design: .monospaced))
                        .textSelection(.enabled)
                    Spacer()
                }
                
                Divider()
                
                // Main Text Box
                VStack {
                    TextEditor(text: $viewModel.textContent)
                        .font(.system(size: 14))
                        .foregroundColor(.black)
                        .padding(6)
                }
                .background(Color(NSColor.textBackgroundColor))
                .cornerRadius(8)
                
                HStack {
                    // Open WindowView Window
                    Button {
                        // for launching the contentview
//                        isContentViewPresented = true
                        // for launching the windowview
                        NSApplication.shared.activate(ignoringOtherApps: true)
                        openWindow(id: "window-view")
//                        isMenuPresented = false
                        appState.isMenuPresented.toggle()
                    } label: {
                        Text("Open in Window", comment: "Open in window label")
                            .foregroundColor(Color.black)
                            .frame(maxWidth: .infinity)
                        Text("⌘ O")
                            .foregroundColor(Color.gray)
                    }
                    .cornerRadius(4)
//                    .frame(maxWidth: .infinity)
                    .controlSize(.large)
                    .keyboardShortcut("o")
                    
                    Spacer()
                    
                    // Quit button
                    Button {
                        NSApplication.shared.terminate(self)
                    } label: {
                        Text("Quit", comment: "Quit app label")
                            .foregroundColor(Color.black)
                        Text("⌘ Q")
                            .foregroundColor(Color.gray)
                    }
                    .controlSize(.large)
                    .cornerRadius(4)
                    .keyboardShortcut("q")
                }
                
                // Attribution
                HStack {
                    Spacer()
                    Text("Made by")
                        .font(.system(.footnote, design:.monospaced))
                        .foregroundColor(Color.gray)
                    Link("buzo.tools",
                          destination: URL(string: "https://buzo.tools/Scratch")!)
                        .font(.system(.footnote, design:.monospaced))
                        .underline()
                        .foregroundColor(Color.gray)
                        .onHover { inside in
                            if inside {
                                NSCursor.pointingHand.push()
                            } else {
                                NSCursor.pop()
                            }
                        }
                    Spacer()
                }
            }
            .frame(minWidth: 150, idealWidth: 240, maxWidth: 240, minHeight: 360, idealHeight: 360, maxHeight: 360)
            .padding()
//            .sheet(isPresented: $isContentViewPresented) {
//                ContentView(isContentViewPresented: $isContentViewPresented, viewModel: viewModel)
//            }
        }
    }
}

struct WindowView: View {
//    @StateObject private var viewModel = ScratchViewModel()
    @ObservedObject var viewModel: ScratchViewModel

    var body: some View {
        ZStack {
            Color.white
            VStack {
                TextEditor(text: $viewModel.textContent)
                    .font(.system(size: 14))
                    .padding(10)
                    .background(Color(NSColor.textBackgroundColor))
                
                Divider()
                
                // Keyboard Shortcuts
                HStack {
                    Spacer()
                    Text("Close Window (⌘ W)")
                        .font(.system(.footnote, design:.monospaced))
                        .foregroundColor(Color.gray)
                    Spacer()
                    Text("Toggle Menu App (⌘ Esc)")
                        .font(.system(.footnote, design:.monospaced))
                        .foregroundColor(Color.gray)
                    Spacer()
                }
                // Attribution
                HStack {
                    Spacer()
                    Text("Made by")
                        .font(.system(.footnote, design:.monospaced))
                        .foregroundColor(Color.gray)
                    Link("buzo.tools",
                          destination: URL(string: "https://buzo.tools/Scratch")!)
                        .font(.system(.footnote, design:.monospaced))
                        .underline()
                        .foregroundColor(Color.gray)
                        .onHover { inside in
                            if inside {
                                NSCursor.pointingHand.push()
                            } else {
                                NSCursor.pop()
                            }
                        }
                    Spacer()
                }
            }
            .cornerRadius(8)
            .frame(minWidth: 200, minHeight: 200)
            .padding()
        }
    }
}

struct ContentView: View {
    @Binding var isContentViewPresented: Bool
    @ObservedObject var viewModel: ScratchViewModel

    var body: some View {
        VStack {
            TextEditor(text: $viewModel.textContent)
                .font(.system(size: 14))
                .padding(10)
                .background(Color(NSColor.textBackgroundColor))
                .cornerRadius(8)
                .textSelection(.enabled)

            // Close button
            HStack {
                Spacer()
                Button {
                    withAnimation {
                        isContentViewPresented = false
                    }
                } label: {
                    Text("Close Window", comment: "Close window label")
                        .foregroundColor(Color.black)
                    Text("(Esc)")
                        .foregroundColor(Color.gray)
                }
                .controlSize(.large)
            }
        }
        .frame(minWidth: 400, idealWidth: 600, minHeight: 400, idealHeight: 400)
        .padding()
        .onAppear {
            NSApplication.shared.windows.first?.title = "Scratch App"
            NSApplication.shared.windows.first?.center()
        }
    }
}
