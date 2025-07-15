import SwiftUI
import Firebase
import FirebaseFirestore

struct UserTask: Identifiable {
    let id: String
    let details: String
    let name: String
    let dueDate: Date
    let taskCompleted: Bool
}

struct TaskView: View {
    @Environment(AuthManager.self) var authManager
    @State private var selectedTab: Int = 0
    @State private var showAddTaskPopup: Bool = false
    @State private var showTaskDetailsPopup: Bool = false
    @State private var selectedTask: UserTask? = nil
    @State private var userTasks: [UserTask] = []
    private var db = Firestore.firestore()

    init(isMocked: Bool = false) {}

    var body: some View {
        NavigationStack {
            VStack {
                Picker("", selection: $selectedTab) {
                    Text("Tasks").tag(0)
                    Text("Completed").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                if selectedTab == 0 {
                    if userTasks.isEmpty {
                        Text("No tasks available")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                    } else {
                        List(userTasks) { task in
                            Button(action: {
                                selectedTask = task
                                showTaskDetailsPopup = true
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
                } else {
                    CompletedTasksView()
                }

                Spacer()

                HStack {
                    Spacer()
                    Button(action: {
                        showAddTaskPopup = true
                    }) {
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                            .shadow(radius: 4)
                    }
                    Spacer()
                }
                .padding(.bottom, 16)
            }
            .navigationTitle("PlanR")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem {
                    Button("Sign out") {
                        authManager.signOut()
                    }
                }
            }
            .sheet(isPresented: $showAddTaskPopup) {
                AddTaskView(isPresented: $showAddTaskPopup, onTaskAdded: { fetchUserTasks() })
            }
            .sheet(item: $selectedTask) { task in
                DetailedTaskView(userTask: task, isCompletedTaskView: false, onTaskModified: onTaskModified)
            }
            .onAppear {
                fetchUserTasks()
            }
        }
    }

    // The closure to update the tasks when a task is completed or deleted
    func onTaskModified() {
        fetchUserTasks()
    }

    // Fetch tasks from Firestore
    func fetchUserTasks() {
        db.collection("tasks")
            .whereField("taskCompleted", isEqualTo: false) // Fetch only incomplete tasks
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching tasks: \(error.localizedDescription)")
                } else {
                    userTasks = snapshot?.documents.compactMap { document in
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
    TaskView(isMocked: true).environment(AuthManager(isMocked: true))
}

