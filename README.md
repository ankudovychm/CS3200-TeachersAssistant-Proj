# Teacher's Assistant MySQL, Flask, and Appsmith App

Teacher’s Assistant (TA) is an all-in-one class management system for college courses combined into one service, integrating capabilities like assignment posting/submission, discussion boards, TA management, course registration, office hours, and course feedback into one platform. While pre-existing education platforms like Canvas and Gradescope include some of the functionalities listed above, Teacher’s Assistant offers a new way to streamline all necessary course management tools in one location, alleviating stress and anxiety for professors, students, TAs, and administrators all semester long. 

This repo contains the setup for the world's next learning management superapp, Teacher's Assistant, with 3 Docker containers: 
1. A MySQL 8 container for the SQL schema and test data 
2. A Python Flask container to implement a REST API
3. A Local AppSmith Server for the presentation 

Before starting, ensure that Docker Desktop is installed.

To start this program:
* Clone this repository under green "Code" dropdown button.
* Once all files are downloaded, open the folder with the docker-compose.yml file. Run `docker compose build` in the terminal/command prompt to build the images.
* Start the containers with `docker compose up` or `docker compose up -d` to run in detached mode so the containers run in the background.

Additionally, every user will need to do the following:
* Create a file named db_root_password.txt in the secrets/ folder and put inside of it the root password for MySQL.
* Create a file named db_password.txt in the secrets/ folder and put inside of it the password you want to use for the a non-root user named webapp.

This app was created as the final project for CS3200: Database Design at Northeastern University. The final stage project was completed by: 
* Mikhail Ankudovych 
* Sophie Sawyers 
* Laura Boelsterli