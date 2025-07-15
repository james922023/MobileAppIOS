//
//  CompletedTasksView.swift
//  PlanR
//
//  Created by James Yackanich on 11/30/24.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct CompletedTasksView: View {
    @State private var completedTasks: [UserTask] = []
    @State private var selectedTask: UserTask? = nil
    private var db = Firestore.firestore()

    var body: some View {
        NavigationStack {
            VStack {
                if completedTasks.isEmpty {
                    Text("No completed tasks available")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                        .padding()
                } else {
                    List(completedTasks) { task in
                        Button(action: {
                            selectedTask = task
                        }) {
                            VStack(alignment: .leading) {
                                Text(task.name)
                                    .font(.headline)
                                Text(task.details)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Text("Due: \(task.dueDate, formatter: taskDateFormatter)")
                                    .font(.footnote)
                                    .foregroundColor(.blue)
                            }
                            .padding(.vertical, 5)
                        }
                        .buttonStyle(PlainButtonStyle()) // Ensures the button doesn’t look like a button
                    }
                }
            }
            .onAppear {
                fetchCompletedTasks()
            }
            .sheet(item: $selectedTask) { task in
                DetailedTaskView(userTask: task, isCompletedTaskView: true, onTaskModified: {
                    // Handle task modification logic here, for example:
                    fetchCompletedTasks() // Update completed tasks after modification
                })
            }

        }
    }

    func fetchCompletedTasks() {
        db.collection("tasks")
            .whereField("taskCompleted", isEqualTo: true) // Filter to only fetch completed tasks
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching completed tasks: \(error.localizedDescription)")
                } else {
                    completedTasks = snapshot?.documents.compactMap { document in
                        let data = document.data()
                        guard
                            let details = data["details"] as? String,
                            let name = data["name"] as? String,
                            let dueDateTimestamp = data["dueDate"] as? Timestamp,
                            let taskCompleted = data["taskCompleted"] as? Bool
                        else { return nil }

                        return UserTask(
                            id: document.documentID,
                            details: details,
                            name: name,
                            dueDate: dueDateTimestamp.dateValue(),
                            taskCompleted: taskCompleted
                        )
                    } ?? []
                }
            }
    }

    private var taskDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }
}

#Preview {
    CompletedTasksView()
}


