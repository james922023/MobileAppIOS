//
//  AddTaskView.swift
//  PlanR
//
//  Created by James Yackanich on 11/30/24.
//

import SwiftUI
import FirebaseFirestore // <-- Import Firestore

struct AddTaskView: View {
    
    @Binding var isPresented: Bool
    @State private var taskName: String = ""
    @State private var taskDetails: String = ""
    @State private var taskDate: Date = Date() // New state variable for the date picker
    @State private var recommendedTasks: [String] = [] // State variable to store recommended tasks
    var onTaskAdded: () -> Void // Closure to notify when task is added

    // Firestore reference
    private var db = Firestore.firestore() // Firebase Firestore instance

    // Initializer with explicit access control to allow access from other views
    public init(isPresented: Binding<Bool>, onTaskAdded: @escaping () -> Void) {
        _isPresented = isPresented
        self.onTaskAdded = onTaskAdded
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                TextField("Task Name", text: $taskName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                TextField("Task Details", text: $taskDetails)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                // Smaller Date Picker for selecting a task date
                DatePicker(
                    "Due Date", // Label for the DatePicker
                    selection: $taskDate,
                    displayedComponents: [.date, .hourAndMinute] // Display both date and time
                )
                .datePickerStyle(CompactDatePickerStyle()) // Use Compact style for a smaller appearance
                .padding(.horizontal)

                Button(action: {
                    // Handle adding the task to Firestore
                    addTaskToFirestore(name: taskName, details: taskDetails, dueDate: taskDate)
                    onTaskAdded()
                    isPresented = false // Dismiss the popup
                }) {
                    Text("Add Task")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }

                // Display recommended tasks if any
                if !recommendedTasks.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Recommended Tasks:")
                            .font(.headline)
                            .padding(.top)

                        ForEach(recommendedTasks, id: \.self) { task in
                            Button(action: {
                                // Set task name and details when clicked
                                taskName = task // Set task name
                                taskDetails = "" // Optional details
                            }) {
                                Text(task)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue.opacity(0.2))
                                    .foregroundColor(.blue)
                                    .cornerRadius(8)
                            }
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                }


                Spacer()
            }
            .navigationTitle("Add Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        isPresented = false // Dismiss the popup
                    }
                }
            }
        }
        .task {
            await fetchMostRecentUncompletedTask() // Use Task to fetch completed tasks asynchronously
        }
    }

    // Function to add task to Firestore
    private func addTaskToFirestore(name: String, details: String, dueDate: Date) {
        // Prepare task data as a dictionary
        let taskData: [String: Any] = [
            "name": name,
            "details": details,
            "dueDate": Timestamp(date: dueDate), // Convert Date to Firestore Timestamp
            "taskCompleted": false // Default taskCompleted field to false
        ]
        
        // Add task data to Firestore under "tasks" collection
        db.collection("tasks").addDocument(data: taskData) { error in
            if let error = error {
                print("Error adding task: \(error.localizedDescription)")
            } else {
                print("Task successfully added to Firestore!")
            }
        }
    }

    // Function to fetch the most recent uncompleted task from Firestore
    private func fetchMostRecentUncompletedTask() async {
        print("Fetching the most recent uncompleted task...") // Debugging line
        
        do {
            // Query uncompleted tasks sorted by dueDate in descending order (most recent first)
            let snapshot = try await db.collection("tasks")
                .whereField("taskCompleted", isEqualTo: false)
                .order(by: "dueDate", descending: false) // Change to descending if needed
                .limit(to: 1) // Only fetch the most recent task
                .getDocuments()

            // Check if there's at least one document
            if let document = snapshot.documents.first {
                if let taskName = document.data()["name"] as? String {
                    print("Most recent uncompleted task: \(taskName)") // Debugging line
                    
                    // Call ChatGPT API with the most recent uncompleted task
                    await getRecommendedTasks(from: [taskName])
                }
            } else {
                print("No uncompleted tasks found.") // Debugging line
            }
        } catch {
            print("Error fetching uncompleted tasks: \(error.localizedDescription)") // Debugging line
        }
    }


    private func getRecommendedTasks(from completedTasks: [String]) async {
        print("Sending to ChatGPT API...") // Debugging line
        
        let apiKey = "ADD KEY HERE" // Replace with your actual API key
        let url = URL(string: "https://api.openai.com/v1/chat/completions")! // Use chat endpoint

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Prepare the messages for the chat API
        let prompt = "Based on the following completed tasks, recommend 3 similar tasks: \(completedTasks.joined(separator: ", "))"
        
        let body: [String: Any] = [
            "model": "gpt-3.5-turbo", // Use gpt-3.5-turbo instead of text-davinci-003
            "messages": [
                [
                    "role": "system",
                    "content": "You are a helpful assistant."
                ],
                [
                    "role": "user",
                    "content": prompt
                ]
            ],
            "max_tokens": 150
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            print("Error creating request body: \(error)") // Debugging line
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(for: request)

            // Debugging: log the full response
            if let responseString = String(data: data, encoding: .utf8) {
                print("ChatGPT Response: \(responseString)") // Debugging line
            }

            let responseJSON = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            if let choices = responseJSON?["choices"] as? [[String: Any]], let message = choices.first?["message"] as? [String: Any], let text = message["content"] as? String {
                let recommendedTasks = text.split(separator: "\n").map { String($0) }
                DispatchQueue.main.async {
                    self.recommendedTasks = recommendedTasks
                    print("Recommended tasks: \(recommendedTasks)") // Debugging line
                }
            }
        } catch {
            print("Error fetching recommended tasks: \(error)") // Debugging line
        }
    }


}

#Preview {
    AddTaskView(isPresented: .constant(true), onTaskAdded: {
        // Mock action, typically you'd update the task list here
        print("Task added!")
    })
}
