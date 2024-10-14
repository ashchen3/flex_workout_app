//
//  ProgramViewModel.swift
//  flex_workout_app
//
//  Created by Alex Chen on 10/1/24.
//

import Foundation
import Supabase

class ProgramViewModel: ObservableObject {
    @Published var programName = ""
    @Published var programs = [Program]()
    @Published var selectedProgram: Program?


    private let supabase = SupabaseClient(supabaseURL: Secrets.projectURL, supabaseKey: Secrets.apiKey)
    
    // MARK: CRUD Programs
    
    @MainActor
    func createProgram(programName: String) async throws {
        let user = try await supabase.auth.session.user
        
        let program = Program(user_id: user.id, programName: programName, numWorkouts: 0)
        
        let newProgram: Program = try await supabase
            .from("programs")
            .insert(program)
            .select()
            .single()
            .execute()
            .value
                
        // Check if this is the user's first program
        if self.programs.isEmpty {
            try await selectProgram(newProgram)
        }
        
        try await fetchPrograms()
    }

    
    func fetchPrograms() async throws {
        let user = try await supabase.auth.session.user
        
        let programs: [Program] = try await supabase
            .from("programs")
            .select()
            .eq("user_id", value: user.id)
            .order("created_at", ascending: false)
            .execute()
            .value
                
        self.programs = programs
        
    }
    
    func updateProgram(_ program: Program, with programName: String) async {
        guard let id = program.id else {
            print("Can't update program")
            return
        }
        
        var toUpdate = program
        toUpdate.programName = programName
        
        do {
            try await supabase
                .from("programs")
                .update(toUpdate)
                .eq("id", value: id)
                .execute()
        } catch {
            print("Error: \(error)")
        }
    }
    
    func deleteProgram(at id: Int) async throws {
        try await supabase
            .from("programs")
            .delete()
            .eq("id", value: id)
            .execute()
    }
    
    // MARK: SELECT Programs
    
    func selectProgram(_ program: Program) async throws {
        let user = try await supabase.auth.session.user
        
        try await supabase
            .from("profiles")
            .update(["selected_program": program.id])
            .eq("id", value: user.id)
            .execute()
        
        
        // Update the local state MIGHT BE USELESS
        await MainActor.run {
            self.selectedProgram = program
        }
    }
    
    @MainActor
    func fetchSelectedProgram() async throws {
        let user = try await supabase.auth.session.user
        
        let profile: Profile = try await supabase
            .from("profiles")
            .select("selected_program")
            .eq("id", value: user.id)
            .single()
            .execute()
            .value
        
//        if let selectedProgramId = profile.selectedProgram {
//            self.selectedProgram = programs.first { $0.id == selectedProgramId }
//        }
        
        if let selectedProgramId = profile.selectedProgram {
            let program: Program = try await supabase
                .from("programs")
                .select("*")
                .eq("id", value: selectedProgramId)
                .single()
                .execute()
                .value
            
            // Do something with the fetched program, like assigning it to a property
            self.selectedProgram = program
            print(program)
        } else {
            // Handle the case where selectedProgram is nil
            print("No selected program found for this user.")
        }
    }
    
//    func deselectProgram() async throws {
//        let user = try await supabase.auth.session.user
//        
//        // Update the selectedProgram in the profiles table to null
//        try await supabase
//            .from("profiles")
//            .update(["selectedProgram": nil])
//            .eq("id", value: user.id)
//            .execute()
//        
//        // Update the local state
//        await MainActor.run {
//            self.selectedProgram = nil
//        }
//    }
    
}
