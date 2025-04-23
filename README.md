# 🌳 FamilyTree – A SwiftUI Cloud-Powered Family Tree App

FamilyTree is a SwiftUI application that allows users to visually build, explore, and manage their family history — complete with parent, child, and spouse relationships — stored securely in the cloud with Firebase.

![Simulator Screenshot - iPhone 16 Pro - 2025-04-23 at 17 38 14](https://github.com/user-attachments/assets/21202313-30c5-440a-bf97-0c0ce3bd0b59)
![Simulator Screenshot - iPhone 16 Pro - 2025-04-23 at 17 29 34](https://github.com/user-attachments/assets/edc09533-e66c-44a9-a414-fd31912bc013)
---

## 🚀 Features

- 📲 **Firebase Authentication** – Users sign in with email and password (Apple Sign-In coming soon!)
- ☁️ **Cloud Sync with Firestore** – All family tree data is saved and synced per user
- 🧬 **Graphical Tree View** – A dynamic, visual diagram of the family structure using SwiftUI where children are automatically sorted by birthday
- 🧠 **Drag-to-Link Interaction** – Long press to start a connection, drag to another member to link cross-bloodline relationships
- 🖼️ **Custom Colors & Outline Highlights** – Visually differentiate cross-bloodline relationships
- 📱 **Zoom & Pan Support** – Explore large trees easily on any device, large or small!

---

## 🔧 Technical Details

### SwiftUI + SwiftData

- Uses SwiftData (`@Model`, `@Query`, `ModelContext`) to persist data locally
- Recursive tree structure (`FamilyMember`) supports nested relationships
- Fully custom `Diagram` view for visual layout of the tree

### Firebase Integration

- **Authentication**:
  - Managed with `FirebaseAuth`
  - Supports email/password login
  - Stores and tracks `user.uid` to load/save user-specific data

- **Cloud Persistence**:
  - Each user’s family tree is stored under:
    ```
    /users/{uid}/familyTree/{memberId}
    /users/{uid}/crossBloodlineConnections/{connectionId}
    ```
  - Data is encoded and synced to Firestore
  - Cloud → Local sync occurs on login
  - `ModelContext` is reset before each sync to prevent stale data

---

## 📁 Data Model Structure

```swift
@Model
class FamilyMember {
    var id: UUID
    var firstName: String
    var lastName: String?
    var spouse: FamilyMember?
    var children: [FamilyMember]
    var isTopOfBloodline: Bool
    var isMarriedIntoFamily: Bool
    // ...
}

struct CrossBloodlineConnection: Codable {
    var fromChild: UUID
    var toNewParent: UUID
}
```
