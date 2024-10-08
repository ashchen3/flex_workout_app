//
//  WorkoutsViewModel.swift
//  flex_workout_app
//
//  Created by Alex Chen on 10/3/24.
//

import Foundation
import Supabase


//struct Workout: Codable {
//    let id: Int? //To be populated by Supabase
//    let workoutName: String
//    let programId: Int
//    let user_id: UUID
//    
//    enum CodingKeys: String, CodingKey {
//        case id
//        case workoutName = "workout_name"
//        case programId = "program_id"
//        case user_id
//    }
//}

class WorkoutsViewModel: ObservableObject {
    @Published var workouts = [Workout]()
    
    private let supabase = SupabaseClient(supabaseURL: Secrets.projectURL, supabaseKey: Secrets.apiKey)

    // MARK: CRUD Workouts
    
    @MainActor
    func createWorkout(workoutName: String, programId: Int) async throws {
        let user = try await supabase.auth.session.user
        
        let workout = Workout(workoutName: workoutName, programId: programId, user_id: user.id)
        
        let newProgram: Workout = try await supabase
            .from("workouts")
            .insert(workout)
            .select()
            .single()
            .execute()
            .value
    }

    
    func fetchPrograms(programId: Int) async throws {
        let user = try await supabase.auth.session.user
        
        let workouts: [Workout] = try await supabase
            .from("workouts")
            .select()
            .eq("program_id", value: programId)
            .execute()
            .value
                
        self.workouts = workouts
        
    }
    
//    func updateProgram(_ program: Program, with programName: String) async {
//        guard let id = program.id else {
//            print("Can't update program")
//            return
//        }
//        
//        var toUpdate = program
//        toUpdate.programName = programName
//        
//        do {
//            try await supabase
//                .from("programs")
//                .update(toUpdate)
//                .eq("id", value: id)
//                .execute()
//        } catch {
//            print("Error: \(error)")
//        }
//    }
//    
//    func deleteProgram(at id: Int) async throws {
//        try await supabase
//            .from("programs")
//            .delete()
//            .eq("id", value: id)
//            .execute()
//    }
    
}
