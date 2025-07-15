import SwiftUI
import Firebase
import FirebaseFirestore

struct DetailedTaskView: View {
    let userTask: UserTask
    @Environment(\.dismiss) private var dismiss
    private var db = Firestore.firestore()

    // Add a flag to conditionally hide buttons
    var isCompletedTaskView: Bool = false

    var onTaskModified: () -> Void // Closure to notify parent view for task modification
    
    init(userTask: UserTask, isCompletedTaskView: Bool = false , onTaskModified: @escaping () -> Void) {
        self.userTask = userTask
        self.isCompletedTaskView = isCompletedTaskView
        self.onTaskModified = onTaskModified
    }

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Task Name:")
                    .font(.headline)
                Text(userTask.name)
                    .font(.body)
                
                Text("Task Details:")
                    .font(.headline)
                Text(userTask.details)
                    .font(.body)

                Text("Due Date:")
                    .font(.headline)
                Text("\(userTask.dueDate, formatter: dateFormatter)")
                    .font(.body)

                Spacer()

                // Only show these buttons if it's not coming from the Completed Tasks view
                if !isCompletedTaskView {
                    HStack {
                        Button(action: {
                            completeTask()
                        }) {
                            Label("Complete", systemImage: "checkmark.circle.fill")
                                .font(.title)
                                .foregroundColor(.green)
                        }
                        .padding()

                        Spacer()

                        Button(action: {
                            deleteTask()
                        }) {
                            Label("Delete", systemImage: "trash.fill")
                                .font(.title)
                                .foregroundColor(.red)
                        }
                        .padding()
                    }
                    .padding(.bottom, 16)
                }
            }
            .padding()
            .navigationTitle("Task Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }

    private func completeTask() {
        db.collection("tasks").document(userTask.id).updateData([
            "taskCompleted": true
        ]) { error in
            if let error = error {
                print("Error updating task completion: \(error.localizedDescription)")
            } else {
                onTaskModified()
                dismiss()
            }
        }
    }

    private func deleteTask() {
        db.collection("tasks").document(userTask.id).delete { error in
            if let error = error {
                print("Error deleting task: \(error.localizedDescription)")
            } else {
                onTaskModified()
                dismiss()
            }
        }
    }

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }
}

#Preview {
    DetailedTaskView(
        userTask: UserTask(
            id: "1",
            details: "Example details for the task.",
            name: "Example Task",
            dueDate: Date(),
            taskCompleted: false
        ),
        isCompletedTaskView: true, // Pass true for completed tasks
        onTaskModified: {
            print("Task modified!")
            // Here, you can simulate how the parent view should update when the task is modified
        }
    )
}

