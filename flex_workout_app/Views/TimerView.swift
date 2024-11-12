import SwiftUI

struct TimerView: View {

    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var timerManager: TimerManager
    let totalTime: Int
    let onDismiss: () -> Void

    init(timerManager: TimerManager = TimerManager(), totalTime: Int, onDismiss: @escaping () -> Void) {
        _timerManager = StateObject(wrappedValue: timerManager)
        self.totalTime = totalTime
        self.onDismiss = onDismiss
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.white)
                .shadow(radius: 10)
            
            VStack(spacing: 8) {
                HStack(alignment: .center) {
                    // Timer display
                    Text(timeString(from: timerManager.timeElapsed))
                        .font(.system(size: 30, weight: .regular))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // Rest text
                    Text("Rest \(3)min.")
                        .foregroundColor(.gray)
                        .font(.system(size: 16))
                    // Close button
                    Button(action: onDismiss) {
                        Image(systemName: "xmark")
                            .foregroundColor(.gray)
                            .font(.system(size: 16, weight: .medium))
                            .padding(8)
                            .background(Color.gray.opacity(0.2))
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                
                // Progress bar
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 3)
                        
                        // Progress indicator
                        Rectangle()
                            .fill(Color.cyan)
                            .frame(width: min(geometry.size.width * CGFloat(timerManager.timeElapsed) / CGFloat(totalTime), geometry.size.width), height: 3)
                    }
                }
                .frame(height: 3)
                .padding(.horizontal, 20)
                .padding(.bottom, 16)
            }
        }
        .frame(height: 100)
        .padding(.horizontal)
        .onAppear {
            if !timerManager.isRunning {
                timerManager.startTimer()
            }
        }
        .onDisappear {
            //stopTimer()
        }
//        .onChange(of: shouldReset) {
//            resetTimer()
//            shouldReset = false
//        }
    }
    
    private func timeString(from seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%d:%02d", minutes, remainingSeconds)
    }
    
}

