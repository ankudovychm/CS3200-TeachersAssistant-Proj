# Teacher's Assistant MySQL, Flask, and Appsmith App

Teacher’s Assistant (TA) is an all-in-one class management system for college courses combined into one service, integrating capabilities like assignment posting/submission, discussion boards, TA management, course registration, office hours, and course feedback into one platform. While pre-existing education platforms like Canvas and Gradescope include some of the functionalities listed above, Teacher’s Assistant offers a new way to streamline all necessary course management tools in one location, alleviating stress and anxiety for professors, students, TAs, and administrators all semester long. 

This repo contains the setup for the world's next learning management superapp, Teacher's Assistant, with 3 Docker containers: 
1. A MySQL 8 container for the SQL schema and test data 
2. A Python Flask container to implement a REST API
3. A Local AppSmith Server for the presentation 


To start this program:
* Clone this repository under green "Code" dropdown button.
* Once all files are downloaded, open and run `docker compose build` in the terminal.
* Start the containers with `docker compose up -d` so the containers run in the background.

This app was created as the final project for CS3200: Database Design at Northeastern University. The final stage project was completed by: 
* Mikhail Ankudovych 
* Sophie Sawyers 
* Laura Boelsterli

