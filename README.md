<h1>Ubersnap Assignment</h1>
<h2>Project Overview</h2>
The purpose of this application is to set or change temperature of JPEG photo.
<br>
User can load a photo from gallery only with JPEG format, any other formats will return Warning.
<br>
After loading the JPEG photo, user can change the photo's temperature with slider.
<br>
The value of the slider is between -100(Cool) & 100(Warm)
<br>
After changing the temperature, user can save the photo to gallery with save button.
<br>
I'm using SwiftUI and MVVM as design pattern. The reason i use MVVM is to promote loose coupling and separation of concern between view and business logic.

<h2>Setup Instruction</h2>

<ul>
  <li>
    Download OpenCV Framework File (OpenCV iOS Pack - 4.11.0) from:
    https://opencv.org/releases/
    Or
    https://drive.google.com/file/d/1KFeC3u7dmuMjIoG2rsvnkNgItmXrbw5N/view?usp=sharing
  </li>
  <li>Extract the zip</li>
  <li>Copy opencv2.framework file to Root Project Folder (like the screenshot i attached below)</li>
  <img width="742" alt="Screenshot 2025-03-09 at 23 33 08" src="https://github.com/user-attachments/assets/95407062-f95d-49c7-862b-29c866151e25" />
  <li>Now you can run the project by opening UbersnapTemperature.xcodeproj</li>
  <li>This project can only run in real iOS Device because of OpenCV requirement, so it cannot run on iOS Simulator</li>
</ul>
