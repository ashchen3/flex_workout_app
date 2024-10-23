//
//  TimerManager.swift
//  flex_workout_app
//
//  Created by Alex Chen on 10/23/24.
//

import SwiftUI
import Foundation

class TimerManager: ObservableObject {
    @Published var timeElapsed = 0
    @Published var isRunning = false
    private var startDate: Date?
    
    init() {
        // Load saved state when initializing
        if let savedStart = UserDefaults.standard.object(forKey: "timerStartDate") as? Date {
            self.startDate = savedStart
            self.isRunning = true
            updateTimer()
        }
    }
    
    func startTimer() {
        isRunning = true
        startDate = Date()
        UserDefaults.standard.set(startDate, forKey: "timerStartDate")
        updateTimer()
    }
    
    func stopTimer() {
        isRunning = false
        startDate = nil
        UserDefaults.standard.removeObject(forKey: "timerStartDate")
    }
    
    func resetTimer() {
        timeElapsed = 0
        startTimer()
    }
    
    private func updateTimer() {
        guard isRunning else { return }
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let self = self,
                  let startDate = self.startDate,
                  self.isRunning else {
                timer.invalidate()
                return
            }
            
            self.timeElapsed = Int(Date().timeIntervalSince(startDate))
        }
    }
}
