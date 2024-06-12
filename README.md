# mds_flutter_app

A new Flutter project.

## Overview

mds_flutter_app is a Flutter application designed for managing users, universes, characters, and chats. It provides a user-friendly interface to interact with a backend API for various operations related to these entities.

## Features

- User Authentication: Sign up and login functionalities.
- User Management: Retrieve and update logged user details.
- Universe Management: Create, retrieve, update, and delete universes.
- Character Management: Manage characters within a universe.
- Chat Functionality: Create chats, send and retrieve messages.

### Installation

1. Clone the repository:

```bash
git clone https://github.com/leslk/mds_flutter_app.git
cd mds_flutter_app
```

2. Install dependencies:

```bash
flutter pub get
```

3. Run the app:

```bash
flutter run
```

## Directory Structure

- lib: Contains the main application code.
- services: Contains the HttpService class for API interactions and utils file that contains token class to ease token handling.
- models: Defines the data models for users, universes, characters, chats, and messages.
