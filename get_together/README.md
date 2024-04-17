

 # get_together

get together is a mobile application designed to enhance the exploration of New York City's events, activities, and dining options. Built with Flask, Flutter, and Firebase, this app offers users a platform to discover, organize, and enjoy their favorite outings in the city.

Features
User Authentication: Secure login and authentication system powered by Firebase, ensuring user privacy and data security.

Event Discovery: Browse through a curated selection of events, activities, and restaurants in New York City presented as swipeable cards.

Swipe Interaction: Intuitive swipe gesture interface allows users to express interest (swipe right) or pass (swipe left) on displayed events.

Personalized Lists: Interested events are automatically added to a personalized list for easy access and organization.

Social Integration: See if any friends are interested in the same events, fostering connections and facilitating shared experiences.

Messaging Platform: In-app messaging feature enables users to communicate with friends, coordinate plans, and invite others to join in on outings.

Technologies Used
Flask: Backend server framework for storing event data.
Flutter: Cross-platform mobile app development framework used to build the frontend UI and user interaction.
Firebase: Cloud-based platform utilized for user authentication, real-time database management, and messaging functionality.

Installation
Clone the repository:
git clone [(https://github.com/Kirstynichole/getTogether.git)]

Install dependencies for both the Flask backend and Flutter frontend.

# Flask Backend
 - Navigate to backend_get_together 
 - Run pipenv shell
 - Run python app.py

# Flutter Frontend
 - (API keys needed, to run w/o key: remove FETCH requests for NYC.gov & Ticketmaster from event_service.dart)
 - Navigate to get_together
 - Run flutter run

Update Firebase configuration in the Flutter app by replacing the google-services.json file with your own Firebase configuration file.


Contributing
Contributions are welcome! Please feel free to submit issues or pull requests for any bugs or improvements you'd like to see in the app.


