# BlueScore Challenge Documentation

## Design Rationale

The BlueScore app aims to provide users, like Sammy in our scenario, with real-time information about cyber threats in their surroundings. The design rationale behind the app is to create a user-friendly and intuitive experience that empowers users to quickly assess their exposure to cyber threats and take appropriate countermeasures.

We drew inspiration from iOS's native Weather app and its Air Quality Index map representation. This choice was made to leverage a familiar design pattern that users are already accustomed to. The color-coded map allows users to understand threat levels at a glance, similar to how the Weather app visualizes air quality.

All the data in the app is randomly generated and simulated using the user’s current location.

## Technical Architecture

The BlueScore app is built using the Swift programming language and follows the Model-View-ViewModel (MVVM) architecture pattern. The architecture’s main components are:

- **View:** The user interface components, designed according to Apple's Human Interface Guidelines, provide a visually appealing and user-friendly experience. The app uses UIKit for building the user interface.
- **ViewModel:** The ViewModel is the intermediary between the View and the data model. It retrieves and processes threat data, calculates the Cyber Threat Index, and provides formatted data to the View for display. The ViewModel also handles communication with the Location Services and manages notifications.
- **Model:** The Model contains the data structures and logic related to the threat data. It includes threat locations with associated threat indexes and coordinates.
- **Location Services:** The app leverages Core Location to determine the user's location and provide location-based threat data. This is done all the time in the background (subject to use opt-in).
- **ARKit:** The app uses ARKit for the augmented reality feature, allowing users to visualize cyber threats in real time using AR overlays.
- **User Notification Services:** User Notifications are deployed periodically/when reaching severe BlueScore Levels, to alert the user (subject to use opt-in).

## Screens Overview

The application includes the following screens:

- **Walk Through:** This is in line with Apple’s HIG and the best practice to ask users for varied permissions.
- **HomeScreen:** This screen houses the Map which has annotations for different threats and a weighted heat map according to the Cyber Threat Indexes.
- **AR Mode:** This screen houses the AR mode that depicts all threats in an AR setting using the user’s camera. Threats are color-coded spheres with the threat index inside them.
- **Threat List:** This screen contains the list of currently scanned devices and associated Threat indexes. It also shows the total BlueScore out of 100.

The app has been made with smooth animations, is crash-free, and also has one set of Unit tests for the Walkthrough feature.

## Challenges and Solutions

**Challenge: AR Visualization**
Integrating ARKit to provide real-time visualization of cyber threats in an AR overlay was complex. Placing lat/lng combinations into the AR World’s X/Y system was accomplished using the well-known library - [ARCL](https://cocoapods.org/pods/ARCL).
This was overcome by creating AR nodes with color-coded spheres based on threat indexes. Users can swipe down to transition to AR view and see the threats in their surroundings.

## Future Improvements

- **Enhanced Threat Data:** In future iterations, we could integrate machine learning algorithms to predict threat levels based on historical data and external factors.
- **Interactive AR Experience:** Adding interactive elements to the AR overlay, such as tapping on a sphere to view more details about a threat location.
- **Complete User Auth and Management:** Users should have login/signup features with a profile section to manage their profiles.
- **Personalized Recommendations:** Providing personalized recommendations for countermeasures based on the user's threat exposure and preferences.
- **News/Blog:** Something low priority, but something along the lines of a feed for current threats/exploits around the world would be nice. Additionally, a feature like [Have I Been Pwned](https://haveibeenpwned.com/) would be great too.
- **Extensive Testing:** Adding comprehensive Unit and UI tests to make the app robust and unbreakable. Good test coverage is always nice to have.
- **Continuous Integration/Delivery:** Adding CI/CD will allow regular Beta builds to all stakeholders.
- **Static Code Analysis:** Adding a dedicated SonarQube server will ensure top-notch code quality.

