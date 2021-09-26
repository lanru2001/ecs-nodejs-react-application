#Dockerizing the App

Use multi-stage builds for efficient docker images. Building efficient Docker images are very important for faster downloads and lesser surface attacks. In this multi-stage build, building a React app and put those static assets in the build folder is the first step. The second step involves taking those static build files and serve those with node server.

Stage 1

Start from the base image node:10

There are two package.json files: one is for nodejs server and another is for React UI. We need to copy these into the Docker file system and install all the dependencies.

We need this step first to build images faster in case there is a change in the source later. We don’t want to repeat installing dependencies every time we change any source files.

Copy all the source files.

Install all the dependencies.

Run npm run build to build the React App and all the assets will be created under build a folder within a my-app folder.

Stage 2

Start from the base image node:10

Take the build from stage 1 and copy all the files into ./my-app/build folder.

Copy the nodejs package.json into ./api folder

Install all the dependencies

Finally, copy the server.js into the same folder

Have this command node ./api/server.js with the CMD. This automatically runs when we run the image.


Nodejs-React Application Architecture Design

![image](https://user-images.githubusercontent.com/59709429/134820678-2f6a7a5e-9b5a-4399-87bc-198242c5279a.png)

Tech stack:
- Nodejs
- React
- Mysql
- Bash Scripting 
- AWS (ECS, ECR, IAM, SECURITY GROUP, ALB, FARGATE AND VPC)
