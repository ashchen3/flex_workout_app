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
    private var timer: Timer?
    
//    init() {
//        // Load saved state when initializing
//        if let savedStart = UserDefaults.standard.object(forKey: "timerStartDate") as? Date {
//            self.startDate = savedStart
//            self.isRunning = true
//            updateTimer()
//        }
//    }
    
    func startTimer() {
        isRunning = true
        startDate = Date()
        //UserDefaults.standard.set(startDate, forKey: "timerStartDate")
        updateTimer()
    }
    
    func stopTimer() {
        isRunning = false
        startDate = nil
        timer?.invalidate()
        timer = nil
        //UserDefaults.standard.removeObject(forKey: "timerStartDate")
    }
    
    func resetTimer() {
        timeElapsed = 0
        startTimer()
    }
    
    private func updateTimer() {
        guard isRunning else { return }
        
        timer?.invalidate()
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self,
                  let startDate = self.startDate,
                  self.isRunning else {
                self?.timer?.invalidate()
                self?.timer = nil
                return
            }
            
            self.timeElapsed = Int(Date().timeIntervalSince(startDate))
        }
    }
    
    deinit {
        timer?.invalidate()
    }
}
