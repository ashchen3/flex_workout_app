//
//  WorkoutsViewModel.swift
//  flex_workout_app
//
//  Created by Alex Chen on 10/3/24.
//

import Foundation
import Supabase

class WorkoutsViewModel: ObservableObject {
    @Published var workouts: [Workout] = []
    @Published var workoutsWithExercises: [WorkoutWithExercises] = []
    
    private let supabase = SupabaseClient(supabaseURL: Secrets.projectURL, supabaseKey: Secrets.apiKey)

    // MARK: WorkoutExercises
    // Returns a list of WorkoutWithExercises.
    
    @MainActor
    func fetchWorkoutsWithExercises(for programId: Int) async throws {
        let local_workouts: [Workout] = try await fetchWorkouts(for: programId)
        var workoutsWithExercises: [WorkoutWithExercises] = []
        
        for workout in local_workouts {
            let exercises: [Exercise] = try await fetchProgramExercises(for: workout)
            workoutsWithExercises.append(WorkoutWithExercises(workout: workout, exercises: exercises))
        }
        
        print("WorkoutsViewModel: fetch [workoutsWithExercises]")
        
        self.workoutsWithExercises = workoutsWithExercises
    }
    
    
    
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

    func getWorkoutWithExercises(for workoutId: Int) async throws -> WorkoutWithExercises {
        let workout = try await fetchWorkout(id: workoutId)
        let exercises = try await fetchProgramExercises(for: workout)
        
        // Create and return the WorkoutWithExercises object
        return WorkoutWithExercises(workout: workout, exercises: exercises)
    }
    
    private func fetchWorkout(id: Int) async throws -> Workout {
        let response: Workout = try await supabase
            .from("workouts")
            .select("*")
            .eq("id", value: id)
            .single()
            .execute()
            .value
        
        return response
    }
    
    
    func fetchWorkouts(for programId: Int) async throws -> [Workout] {
        let response: [Workout] = try await supabase
            .from("workouts")
            .select("*")
            .eq("program_id", value: programId)
            .order("workout_order", ascending: true)  // Sort by workout_order
            .execute()
            .value
        
        await MainActor.run {
            self.workouts = response
        }
        return response
    }
    
    func updateWorkoutOrder(workouts: [Workout]) async throws {
        for (index, workout) in workouts.enumerated() {
            try await supabase
                .from("workouts")
                .update(["workout_order": index + 1])
                .eq("id", value: workout.id!)
                .execute()
        }
        
        // Refresh the workouts after updating
        if let programId = workouts.first?.programId {
            _ = try await fetchWorkouts(for: programId)
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
            .select("*, user_exercises(*)")
            .eq("workout_id", value: workout.id)
            .execute()
            .value
        
        let userExerciseIds = response.map { $0.user_exercise_id }
        
        let exercisesResponse: [Exercise] = try await supabase
            .from("user_exercises")
            .select("*")
            .in("id", values: userExerciseIds)
            .order("created_at", ascending: false)
            .execute()
            .value
        
        //print("WorkoutsViewModel: fetchProgramExercises [Exercise]")
        
        return exercisesResponse
        
    }
    
    func fetchAllExercises() async throws -> [Exercise] {
        let response: [Exercise] = try await supabase
            .from("exercises")
            .select("*")
            .order("exercise_name", ascending: true)
            .execute()
            .value
        return response
    }
    
    func addExercisesToWorkout(_ exercises: [Exercise], workout: Workout) async throws {
        let user = try await supabase.auth.session.user

        for exercise in exercises {
            
            //Check existance of user_exercise
            let existingUserExercises: [Exercise] = try await supabase
                .from("user_exercises")
                .select("*")
                .eq("user_id", value: user.id)
                .eq("exercise_name", value: exercise.exerciseName)
                .execute()
                .value
            
            if let existingUserExercise = existingUserExercises.first {
                // Use the existing user_exercise

                let workoutExercise = WorkoutExercise(
                    workout_id: workout.id!,
                    exercise_id: exercise.id!,
                    user_exercise_id: existingUserExercise.id!,
                    user_id: user.id
                )
                
                try await supabase
                    .from("workout_exercises")
                    .insert(workoutExercise)
                    .execute()
            } else {
                let userExercise = Exercise(
                    user_id: user.id,
                    exerciseName: exercise.exerciseName,
                    defaultWeight: exercise.defaultWeight,
                    defaultReps: exercise.defaultReps,
                    defaultSets: exercise.defaultSets
                )
                
                let response: Exercise = try await supabase
                    .from("user_exercises")
                    .insert(userExercise)
                    .select()
                    .single()
                    .execute()
                    .value
                
                let workoutExercise = WorkoutExercise(
                    workout_id: workout.id!,
                    exercise_id: exercise.id!,
                    user_exercise_id: response.id!,
                    user_id: user.id
                )
                
                try await supabase
                    .from("workout_exercises")
                    .insert(workoutExercise)
                    .execute()
            }
        }
    }
    
    func removeExerciseFromWorkout(_ exercise: Exercise, workout: Workout) async throws {
        try await supabase
            .from("workout_exercises")
            .delete()
            .eq("workout_id", value: workout.id)
            .eq("user_exercise_id", value: exercise.id)
            .execute()
    }
    
}
