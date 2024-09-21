//MainViewModel.swift

import FirebaseAuth
import FirebaseFirestore
import Foundation

class MainViewModel: ObservableObject {
    @Published var currentUserId: String = ""
    @Published var selectedProgramId: String? = nil
    @Published var programTemplates: [ProgramTemplate] = []

    private var handler: AuthStateDidChangeListenerHandle?
    
    init() {
        self.handler = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                self?.currentUserId = user?.uid ?? ""
                if let userId = user?.uid {
                    self?.fetchSelectedProgram(for: userId)
                    self?.fetchProgramTemplates()
                }
            }
        }
    }
    
    func selectProgram(programId: String) {
        let db = Firestore.firestore()
        db.collection("users").document(currentUserId).setData(["selectedProgramId": programId], merge: true) { [weak self] error in
            if error == nil {
                DispatchQueue.main.async {
                    self?.selectedProgramId = programId
                }
            } else {
                print("Error updating program: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
    
    private func fetchSelectedProgram(for userId: String) {
        let db = Firestore.firestore()
        db.collection("users").document(userId).getDocument { [weak self] document, error in
            if let document = document, document.exists {
                DispatchQueue.main.async {
                    self?.selectedProgramId = document.data()?["selectedProgramId"] as? String
                }
            }
        }
    }
    
    func fetchProgramTemplates() {
        let db = Firestore.firestore()
        db.collection("users").document(currentUserId).collection("ProgramTemplate").getDocuments { [weak self] snapshot, error in
            if let error = error {
                print("Error fetching program templates: \(error.localizedDescription)")
                return
            }
            
            let templates = snapshot?.documents.compactMap { document -> ProgramTemplate? in
                let data = document.data()
                guard let title = data["title"] as? String else { return nil }
                
                let workoutTemplates = (data["workoutTemplates"] as? [[String: Any]])?.compactMap { workoutData -> WorkoutTemplate? in
                    guard let workoutTitle = workoutData["title"] as? String else { return nil }
                    return WorkoutTemplate(id: UUID().uuidString, title: workoutTitle, exerciseTypes: [])
                } ?? []
                
                return ProgramTemplate(id: document.documentID, title: title, workoutTemplates: workoutTemplates)
            } ?? []
            
            DispatchQueue.main.async {
                self?.programTemplates = templates
            }
        }
    }
    
    var isSignedIn: Bool {
        return Auth.auth().currentUser != nil
    }
}
