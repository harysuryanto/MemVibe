//
//  MemVibeApp.swift
//  MemVibe
//
//  Created by Hary Suryanto on 02/03/26.
//

import SwiftUI
import Combine
import ServiceManagement

/**
 * MemVibe
 * A high-performance, native macOS menu bar utility.
 * Features:
 * - Real-time memory tracking using Mach Kernel APIs.
 * - Persistent settings via @AppStorage.
 * - Auto-launch capability using SMAppService.
 * - Format: {icon} {percentage} {emoji}
 * - Thresholds: 5-tier face system for granular feedback.
 */

// --- DATA MODELS ---

enum DisplayMode: String, CaseIterable, Identifiable, Codable {
    case emoji = "Emoji", percentage = "Percentage", both = "Both"
    var id: String { self.rawValue }
}

enum RefreshInterval: String, CaseIterable, Identifiable, Codable {
    case s1 = "1s", s2 = "2s", s5 = "5s", s15 = "15s", s30 = "30s", m1 = "1m"
    var id: String { self.rawValue }
    
    var seconds: Double {
        switch self {
        case .s1: return 1.0; case .s2: return 2.0; case .s5: return 5.0
        case .s15: return 15.0; case .s30: return 30.0; case .m1: return 60.0
        }
    }
}

// --- VIEW MODELS ---

class MemoryMonitor: ObservableObject {
    @Published var memoryUsage: Double = 0.0
    private var timer: Timer?

    func start(interval: Double) {
        timer?.invalidate()
        updateMemory()
        
        // Use standard scheduled timer to prevent UI glitches in MenuBarExtra
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
            self?.updateMemory()
        }
    }

    private func updateMemory() {
        var stats = vm_statistics64()
        var count = UInt32(MemoryLayout<vm_statistics64_data_t>.size / MemoryLayout<integer_t>.size)
        
        let result = withUnsafeMutablePointer(to: &stats) {
            $0.withMemoryRebound(to: integer_t.self, capacity: Int(count)) {
                host_statistics64(mach_host_self(), HOST_VM_INFO64, $0, &count)
            }
        }
        
        if result == KERN_SUCCESS {
            let pageSize = Double(vm_kernel_page_size)
            let active = Double(stats.active_count) * pageSize
            let wired = Double(stats.wire_count) * pageSize
            let compressed = Double(stats.compressor_page_count) * pageSize
            
            var hostInfo = host_basic_info()
            var hostCount = UInt32(MemoryLayout<host_basic_info_data_t>.size / MemoryLayout<integer_t>.size)
            let _ = withUnsafeMutablePointer(to: &hostInfo) {
                $0.withMemoryRebound(to: integer_t.self, capacity: Int(hostCount)) {
                    host_info(mach_host_self(), HOST_BASIC_INFO, $0, &hostCount)
                }
            }
            
            let total = Double(hostInfo.max_mem)
            let used = active + wired + compressed
            
            DispatchQueue.main.async {
                self.memoryUsage = used / total
            }
        }
    }
}

// --- VIEWS ---

@main
struct MemVibeApp: App {
    @AppStorage("selectedMode") private var selectedMode: DisplayMode = .both
    @AppStorage("refreshInterval") private var refreshInterval: RefreshInterval = .s2
    @AppStorage("autoLaunch") private var autoLaunch: Bool = false
    
    @StateObject private var monitor = MemoryMonitor()

    var body: some Scene {
        MenuBarExtra {
            Text("MemVibe Settings").font(.headline)
            
            Divider()
            
            Picker("Display Mode", selection: $selectedMode) {
                ForEach(DisplayMode.allCases) { mode in
                    Text(mode.rawValue).tag(mode)
                }
            }.pickerStyle(.menu)

            Picker("Refresh Rate", selection: $refreshInterval) {
                ForEach(RefreshInterval.allCases) { interval in
                    Text(interval.rawValue).tag(interval)
                }
            }
            .pickerStyle(.menu)
            .onChange(of: refreshInterval) { _, newValue in
                monitor.start(interval: newValue.seconds)
            }

            Divider()
            
            Toggle("Launch at Login", isOn: $autoLaunch)
                .onChange(of: autoLaunch) { _, newValue in
                    toggleAutoLaunch(enabled: newValue)
                }
                
            Divider()
            
            Button("Check for Updates...") {
                // Link to GitHub Releases page
                if let url = URL(string: "https://github.com/harysuryanto/MemVibe/releases") {
                    NSWorkspace.shared.open(url)
                }
            }
            
            Divider()
            
            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
            .keyboardShortcut("q")
            
        } label: {
            MenuBarLabelView(monitor: monitor, selectedMode: selectedMode)
                .onAppear {
                    syncAutoLaunchState()
                    monitor.start(interval: refreshInterval.seconds)
                }
        }
    }
    
    private func syncAutoLaunchState() {
        autoLaunch = SMAppService.mainApp.status == .enabled
    }

    private func toggleAutoLaunch(enabled: Bool) {
        do {
            if enabled {
                try? SMAppService.mainApp.register()
            } else {
                try? SMAppService.mainApp.unregister()
            }
        }
    }
}

struct MenuBarLabelView: View {
    @ObservedObject var monitor: MemoryMonitor
    let selectedMode: DisplayMode
    
    var body: some View {
        HStack(spacing: 5) {
            Image(systemName: "memorychip")
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(monitor.memoryUsage > 0.90 ? .red : .primary)
            
            Text(combinedStatusString)
                .font(.body) // Matches system menu bar text size
                .monospacedDigit() // Ensures stable width during number changes
        }
    }
    
    private var combinedStatusString: String {
        var parts: [String] = []
        
        if selectedMode == .percentage || selectedMode == .both {
            let percent = monitor.memoryUsage > 0 ? String(format: "%.0f%%", monitor.memoryUsage * 100) : "--%"
            parts.append(percent)
        }

        if selectedMode == .emoji || selectedMode == .both {
            parts.append(getEmoji(for: monitor.memoryUsage))
        }
        
        return parts.joined(separator: " ")
    }
    
    private func getEmoji(for usage: Double) -> String {
        if usage > 0.90 { return "🥵" } // Critical
        if usage > 0.75 { return "😰" } // High
        if usage > 0.50 { return "🧐" } // Moderate
        if usage > 0.25 { return "🙂" } // Light
        return "😀" // Idle
    }
}
