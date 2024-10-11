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
    @Published var workouts: [Workout] = []
    
    private let supabase = SupabaseClient(supabaseURL: Secrets.projectURL, supabaseKey: Secrets.apiKey)

    // MARK: CRUD Workouts
    
    @MainActor
    func createWorkout(workoutName: String, programId: Int) async throws {
        let user = try await supabase.auth.session.user
        
        let workout = Workout(user_id: user.id, workoutName: workoutName, programId: programId)
        
        let newWorkout: Workout = try await supabase
            .from("workouts")
            .insert(workout)
            .select()
            .single()
            .execute()
            .value
        
        self.workouts.append(newWorkout)
    
    }

    func fetchWorkouts(for programId: Int) async throws {
        let response: [Workout] = try await supabase
            .from("workouts")
            .select("*")
            .eq("program_id", value: programId)
            .order("workout_order")
            .execute()
            .value
        
        await MainActor.run {
            self.workouts = response
        }
    }
    
// TODO: Update Workout name
    func updateWorkout(_ workout: Workout, with workoutName: String) async {
        guard let id = workout.id else {
            print("Can't update workout name")
            return
        }
        
        var toUpdate = workout
        toUpdate.workoutName = workoutName
        
        do {
            try await supabase
                .from("workouts")
                .update(toUpdate)
                .eq("id", value: id)
                .execute()
        } catch {
            print("Error: \(error)")
        }
    }
    
    func deleteWorkout(_ workout: Workout) async throws {
        try await supabase
            .from("workouts")
            .delete()
            .eq("id", value: workout.id)
            .execute()
        
        await MainActor.run {
            self.workouts.removeAll { $0.id == workout.id }
        }
    }
    
    
    // MARK: - Exercise CRUD Functions
    
    func fetchProgramExercises(for workout: Workout) async throws -> [Exercise] {
        let response: [WorkoutExercise] = try await supabase
            .from("workout_exercises")
            .select("*, exercises(*)")
            .eq("workout_id", value: workout.id)
            .execute()
            .value
        
        let exercises = response.compactMap { $0.exercises }
        return exercises
        
//        await MainActor.run {
//            self.exercises = exercises
//        }
    }
    
    func fetchAllExercises() async throws -> [Exercise] {
        let response: [Exercise] = try await supabase
            .from("exercises")
            .select("*")
            .execute()
            .value
        return response
    }
    
    func addExerciseToWorkout(_ exercise: Exercise, workout: Workout) async throws {
        let user = try await supabase.auth.session.user
        
        let workoutExercise = WorkoutExercise(workout_id: workout.id!, exercise_id: exercise.id!, user_id: user.id)
        
        try await supabase
            .from("workout_exercises")
            .insert(workoutExercise)
            .execute()
        
//        await MainActor.run {
//            self.exercises.append(exercise)
//        }
    }
    
    func addExercisesToWorkout(_ exercises: [Exercise], workout: Workout) async throws {
        let user = try await supabase.auth.session.user

        for exercise in exercises {
            let workoutExercise = WorkoutExercise(workout_id: workout.id!, exercise_id: exercise.id!, user_id: user.id)
            
            try await supabase
                .from("workout_exercises")
                .insert(workoutExercise)
                .execute()
        }

    }
    
    func removeExerciseFromWorkout(_ exercise: Exercise, workout: Workout) async throws {
        try await supabase
            .from("workout_exercises")
            .delete()
            .eq("workout_id", value: workout.id)
            .eq("exercise_id", value: exercise.id)
            .execute()
        
//        await MainActor.run {
//            self.exercises.removeAll { $0.id == exercise.id }
//        }
    }
    
}
