//
//  ProgramView.swift
//  flex_workout_app
//
//  Created by Alex Chen on 9/24/24.
//

import SwiftUI

struct ProgramView: View {
    @StateObject var viewModel = ProgramViewModel()
    @State private var showPopup = false
    @State private var newProgramName = ""
    @State private var activeSheet: Program?
    @State private var showSelectionView = false
    
    @EnvironmentObject var userState: UserState


    var body: some View {
        NavigationView {
            ZStack {
                VStack(spacing: 0) {
                    // Content
                    ScrollView {
                        VStack(spacing: 16) {
                            Text("ACTIVE PROGRAM")
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading)
                            
                            if let activeProgram = viewModel.programs.first(where: { $0.id == userState.profile?.selectedProgram })
                            {
                                ProgramCard(program: activeProgram, isActive: true) {
                                    activeSheet = activeProgram
                                }
                            } else {
                                Text("No active program selected")
                                    .foregroundColor(.gray)
                                    .italic()
                            }
                            
                            Text("OTHER PROGRAMS")
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading)
                            
                            ForEach(viewModel.programs.filter { $0.id != userState.profile?.selectedProgram })
                            { program in
                                ProgramCard(program: program) {
                                    activeSheet = program
                                }
                            }
                        }
                        .sheet(item: $activeSheet) { item in
                            ProgramInfo(program: item, viewModel: viewModel)
                                .presentationDetents([.fraction(2/3)])
                                .presentationCompactAdaptation(.none)
                            }
                        .padding(.vertical)
                    }
                }
                .blur(radius: showSelectionView ? 5 : 0)
                
                if showSelectionView {
                    ProgramSelectionView(viewModel: viewModel, isPresented: $showSelectionView){
                        Task {
                            try? await userState.fetchProfile()
                        }
                    }
                    .transition(.opacity)
                    .zIndex(1)
                }
            }
            .foregroundColor(.black)
            .background(Color.white.edgesIgnoringSafeArea(.all))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showPopup = true
                    }) {
                        Text("Create")
                            .foregroundColor(.cyan)
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        showSelectionView = true
                    }) {
                        Text("Select")
                            .foregroundColor(.cyan)
                    }
                }
            }
            .alert("Enter Program Name", isPresented: $showPopup) {
                TextField("Name", text: $newProgramName)
                    .disableAutocorrection(true)
                    .textInputAutocapitalization(.never)
                Button("Create", action: {
                    Task {
                        await createProgram()
                    }
                })
                Button("Cancel", role: .cancel, action: {
                    newProgramName = ""
                })
            }
            .task {
                try? await viewModel.fetchPrograms()
                try? await userState.fetchProfile()
            }
        }
    }

    func createProgram() async {
        do {
            try await viewModel.createProgram(programName: newProgramName)
            newProgramName = ""
            try await viewModel.fetchPrograms()
        } catch {
            print("Error creating program: \(error)")
        }
    }
}

struct ProgramSelectionView: View {
    @ObservedObject var viewModel: ProgramViewModel
    @Binding var isPresented: Bool
    var onProgramSelected: () -> Void
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(viewModel.programs) { program in
                    ProgramCard(program: program, isSelectable: true) {
                        Task {
                            try? await viewModel.selectProgram(program)
                            isPresented = false
                            onProgramSelected()
                        }
                    }
                }
            }
            .padding(.vertical)
        }
        .background(Color.white)
    }
}

struct ProgramView_Previews: PreviewProvider {
    static var previews: some View {
        ProgramView()
            .environmentObject(UserState())
    }
}
