# toPether

<p align="center">
<img src="https://github.com/dolores0105/forScreenshots/blob/master/toPetherIconwithName.png" width="160" height="226"/>
</p>

<p align="center">
  <b>toPether</b> provides a place for close members to <b>keep records</b> for the <b>pets that they keep together</b>, <br>they could <b>sync the information</b> about the pet with each other in the pet group.
</p>

<p align="center"><a href="https://apps.apple.com/tw/app/topether/id1591802267">
<img src="https://i.imgur.com/X9tPvTS.png" width="120" height="40"/>
</a></p>


## Features

### Hightlights
- Real-time data synchronization in the pet group 
- Record food/medical information of the pet
- Send messages to members of the pet group for a quick sync
- Take a todo list for a member in the pet groups

### Pet Group
#### Create a pet group
- Create a new pet group by filling in some pet information

<img src="https://github.com/dolores0105/forScreenshots/blob/master/CreatePetGroup.png" width="540" height=""/>


#### Invite member/Join into the pet group
- Show QRCode to be scanned

<img src="https://github.com/dolores0105/forScreenshots/blob/master/ShowQRCode.png" width="540" height=""/>


- Scan the QRCode of the member to invite him/she to the specific group 

<img src="https://github.com/dolores0105/forScreenshots/blob/master/ScanQRCode.png" width="540" height=""/>


### Records
#### Food/Medical records
- Record food/medical notes of the pet with members, and view the history records

<img src="https://github.com/dolores0105/forScreenshots/blob/master/Take%20record.png" width="540" height=""/>


### Messages
- Text a message to the members for the casual information sync

<img src="https://github.com/dolores0105/forScreenshots/blob/master/Message.png" width="540" height=""/>

### Todos
- Take a todo list for reminding a member of something needs to do for the pet

<img src="https://github.com/dolores0105/forScreenshots/blob/master/TakeTodo.png" width="540" height=""/>


## Technical Highlights
- Developed readable and maintainable codes in Swift using **OOP** and **MVC** architecture.
- Implemented **Auto Layout programmatically** to make app compatible for all the iPhones.
- **Customized and reused UI components** to optimize maintainability and brevity of codes.
- Utilized **AVFoundation** for QRCode scanner for inviting member into the pet group with more convenience.
- Implemented **Firestore Snapshot Listener** to perform real-time data synchronization and interactions **across Collections**.
- Completed account system via **Sign in with Apple**, and integrated **Firebase Auth** and **Firestore** database. 
- Applied **User Notifications** for reminding users of their todo lists.
- Used **Singleton** to access the single instance which centralizing data management.
- Transformed image into **Base64 encoded string** to increase uploading efficiency.


## Libraries
- [Firestore](https://firebase.google.com/products/firestore?gclid=Cj0KCQiA-qGNBhD3ARIsAO_o7ynVqh2xVTgG6WIKFSfdCN4x9lHJrit2kdCT99IfZPNxPPbbtPHr6qsaAv4lEALw_wcB&gclsrc=aw.ds)
- [lottie-ios](https://github.com/airbnb/lottie-ios)
- [IQKeyboardManagerSwift](https://github.com/hackiftekhar/IQKeyboardManager)
- [SwiftLint](https://github.com/realm/SwiftLint)
- [Crashlytics](https://firebase.google.com/products/crashlytics?hl=en)


## Version
1.0.1


## Requirement
- Xcode 13.0 or later
- iOS 14.0 or later


## Release Notes
| Version | Date | Description                                                                                     |
| :-------| :----|:------------------------------------------------------------------------------------------------|
| 1.0.1   | 2021.12.03 | General improvement |
| 1.0.0   | 2021.11.20 | Launched in App Store|


## Contact

Dolores Lin 林宜萱
[yihsuanlin.dolores@gmail.com](yihsuanlin.dolores@gmail.com)

## License

This project is licensed under the terms of the MIT license

