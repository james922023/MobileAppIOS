# PlanR

Video on the app: https://youtu.be/e0i_KOpRAPI 

## Table of Contents

1. [Overview](#Overview)
2. [Product Spec](#Product-Spec)
3. [Build Progress Gifs](#BUILD-PROGRESS-GIFS)
4. [Wireframes](#Wireframes)
5. [Schema](#Schema)

## Overview

### Description

PlanR is an app designed to help individuals plan things they do and help them keep track of what they need to do. This app is targeted for people who like to write things down that they need to do. This app will allow you to do it on your phone with an easy UI. We are building this app to provide users with an even easier way to access and make tasks. It will have a signup and login page along with a main dashboard with all tasks needed to be done. There will be navigation to a page where you can see past completed tasks. Additionally, there will be a view to add a new task.

### App Evaluation

- **Category:** Productivity
- **Mobile:** Mobile App
- **Story:**  The app will help users log create and manage tasks to help them stay organized. With easy to use UI, along with task recommendations from AI, the app will be extremly easy to use, helping it become part of someones daily routine without much effort.
- **Market:** People who wish to stay organized and plan tasks.
- **Habit:** Daily use app.
- **Scope:** Its a narrow app, in the sense that its pretty straightforward in its function of helping you log and create tasks.

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* [x] User can register or login to an account.
* [x] User can add tasks to a list, and remove them.
* [x] User can see previous tasks that have been completed.

**Optional Nice-to-have Stories**

* [x] When adding a task, the user will be prompted with AI recommended task from OpenAI API.
* The app will have a lightmode and darkmode togggle for the UI style.
* Instead of clicking a button to delete a task, you can swipe it off the screen.

### 2. Screen Archetypes

- [x] Login Screen
* Required User Feature: User can log in or select register to an account.
- [x] Register an Account Screen
* Required User Feature: User can log in or select register to an account.
- [x] Tasks View Screen
*Required User Feature: User can add tasks to the list, and remove them.
- [x] Tasks Creation Screen
*Required User Feature: User can add tasks to the list.
- [x] Previous Tasks View Screen
* User can see previous tasks that have been completed.
- [x] Detial Task View
* Required User Feature: User can click on one of the list items and see detialed view of the task.

### 3. Navigation

**Tab Navigation** (Tab to Screen)

- [x] First Tab, Tasks View Screen
- [x] Second Tab, Previous Tasks View Screen

**Flow Navigation** (Screen to Screen)

- [x] Login Screen
  * Leads to Task View Screen
- [x] Register an Account Screen
  * Leads to Task View Screen
- [x] Task View Screen
  * Leads to a popup Tasks Creation Screen when button is clicked.
  * Also leads back to itself , but with removed task, when task is deleted from list.
  * If click on a task, leads to detialed task view showwing a more detailed description
- [x] Tasks Creation Screen
  * When finished adding, return to the updated Task View Screen with new task added.
- [x] Detailed Task View
  * Can click back button to go back to the task view

## BUILD PROGRESS GIFS

LOGIN AND REGISTER PAGES CREATED

![FinalWireFraming1](https://github.com/user-attachments/assets/4fe81356-52ef-42dd-abdd-9fb8647f597d)

ALL SCREENS AND FLOWS CREATED AND WORKING WITH REQUIRED FUNCTIONALITY

![FinalWireFraming2](https://github.com/user-attachments/assets/daa51e4e-cb8c-4714-81bf-828fbf42c3d5)

## Wireframes

![FinalWireFraming](https://github.com/user-attachments/assets/125d9b3a-d1f2-477b-b229-a259ff072611)

![image](https://github.com/user-attachments/assets/7b9b620e-ed4b-44bb-ac61-59ff7db6d9c9)




