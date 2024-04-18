# Teacher's Assistant MySQL, Flask, and Appsmith App

## Overview

Teacher’s Assistant (TA) is an all-in-one class management system for college courses combined into one service, integrating capabilities like assignment posting/submission, discussion boards, TA management, course registration, office hours, and course feedback into one platform. Currently, professors, TAs, students, and administrators find themselves navigating too many platforms for essential course operations, wasting time and diverting both time and energy away from important course content. This can result in many challenges, such as professors being unable to cover their entire curriculum within the span of a semester, students missing out on potential learning opportunities, TAs feeling overworked as students come with questions about content that had to be taught quickly in class, and administrators feeling troubled by constant requests to fix backend issues on numerous platforms. By consolidating these functionalities into one place, users will only need to become familiar with one interface, and universities can be better prepared to troubleshoot issues on one technology system. While pre-existing education platforms like Canvas and Gradescope include some of the functionalities listed above, Teacher’s Assistant offers a new way to streamline all necessary course management tools in one location, alleviating stress and anxiety for professors, students, TAs, and administrators all semester long. 

This repo contains the setup for the world's next Learning Management Superapp, Teacher's Assistant, with 3 Docker containers: 
1. A MySQL 8 container for the SQL schema and test data 
2. A Python Flask container to implement a REST API
3. A Local AppSmith Server for the presentation 

In the repo, you will find many important resources, including a docker-compose file explaining how to set up and run the program, a secrets folder where you will store your user passwords, a flask-app folder containing Blueprints for the project's routes, and a db folder containing the database for this project. These tables were built off of the user stories we created for the personas of Teacher's Assistant, which include Students, Professors, TAs, and Academic Coordinators. 

This project primarily relies on Python, SQL, Docker, and Appsmith frameworks. 

## Getting set up

*Before* starting, ensure that Docker Desktop is installed. You will also likely need a space to view the code in the repo, such as Visual Studio Code.

To start this program:
* Clone this repository under green "Code" dropdown button.
* Once all files are downloaded, open the folder with the docker-compose.yml file. Run `docker compose build` in the terminal/command prompt to build the images.
* Start the containers with `docker compose up` or `docker compose up -d` to run in detached mode so the containers run in the background.

Additionally, every user will need to do the following:
* Create a file named `db_root_password.txt` in the `secrets/ folder` and put inside of it the root password for MySQL.
* Create a file named `db_password.txt` in the `secrets/` folder and put inside of it the password you want to use for the a non-root user named webapp.

Now, you should be all set! Be sure to utilize our Teacher's Assistant AppSmith repo [here.](https://github.com/ankudovychm/TeachersAssiatantAPPSMITH/tree/master?tab=readme-ov-file)

We hope you enjoy using Teacher's Assistant!

## Contributors

This app was created as the final project for CS3200: Database Design at Northeastern University. The final stage project was completed by: 
* Mikhail Ankudovych 
* Sophie Sawyers 
* Laura Boelsterli