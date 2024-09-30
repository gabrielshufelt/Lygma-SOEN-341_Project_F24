# Real-Ratings-SOEN-341_Project_F24
## Description

Real Ratings' Peer Assessment System is a simple and user-friendly app for students working on team projects. It lets students anonymously rate their teammates based on crtierias like cooperation, contributions, and work ethic, giving everyone a chance to provide honest feedback.


## Features

* __Easy Peer Reviews__: Students can rate teammates on a 7-point scale and leave optional comments, all anonymously.
* __Instructor Dashboard__: Instructors can create teams, see how students are performing, and export results in a handy CSV file.
* __Score Sharing__: After all reviews are in, students and instructors get an overview of scores and feedback, helping everyone improve.
* __Simple Login__: Role-based access for students and instructors with secure logins.

Real Ratings' PAS makes team evaluations easy and encourages fair feedback for everyone involved!


## Team Members
* __Daniel Ayasss__: Front-end Developer, and UI/UX Designer
* __Kourosh Fadaei Naeini__: Backend Developer
* __Yassine Hajou__: Full Stack Developer, and UI/UX Designer
* __Luqman Hakim__: Backend Developer, and Scrum Master
* __Ahmad Saadawi__: Full Stack Developer, and Dev-Ops
* __Gabriel Shufelt__: Lead Full Stack Developer, and Product Owner

## Development
### Windows Installation
1. Install the latest version of Ruby with the DevKit from [here](https://rubyinstaller.org/downloads/).
2. After installation is complete, make sure to check "Launch MSYS2"
3. Once the terminal opens, install all components by pressing `Enter`.
4. Once everything has been installed, press enter to close the MSYS2 terminal.
5. Download Precompiled Binaries for Windows, both sqlite-dll-win-x64-3460100.zip and sqlite-tools-win-x64-3460100.zip from [here](https://www.sqlite.org/download.html).
6. Extract both of these and place the contents of both these folders into a new folder at C:/sqlite.
7. Next, edit your PATH System environment variable and add 'C:/sqlite/' to it.
8. Download and Install Node.js from [NodeJS' prebuilt's installers](https://nodejs.org/en/download/prebuilt-installer/current).
9. In a new terminal, make sure npm was installed correctly: 
```
$ npm --version 
10.5.0
```
10. Next, in new terminal install yarn: 
```
npm install --global yarn
```
11. Make sure it was installed by opening a new terminal and typing:
```
$ yarn --version
1.22.22
```
12. Next, in a new terminal install rails: 
```
gem install rails
```
13. Make sure it was installed correctly by typing: 
```
$ rails --version
Rails 7.1.4
``` 

### Getting Started
* If you are using VSCode, navigate to File > Open Workspace from File. Select `lygma.code-workspace` located in the root directory of the project.
* Whenever you pull new changes from the repository, make sure to run `bundle install` (from your `source` folder). This will install any missing gems needed to run the application.
* In order to always have the most recent version of the database, make sure to run:
```
db:reset    # drops database, re-creates it, and runs pending migrations
db:seed     # populates the database with data defined in db/seeds.rb
```
* With all of these steps complete, you should be able to start your server by running `rails server` (from your `source` folder).
                                                                                                                                     