# Nature ID 

## Table of Contents

1. [Overview](#Overview)
2. [Product Spec](#Product-Spec)
3. [Wireframes](#Wireframes)
4. [Schema](#Schema)

## Overview

### Description

Nature ID is an application that allows users to take pictures of plants and animals and identify them. The application will use a machine learning model to identify the plants and animals. The application will be able to handle cases where the model is not sure what the image is and allow the user to take more pictures or another picture to get a more accurate identification.

### Features

1. Small machine learning model that can process images offline and be able to stored on the device. The model would be a fine tuned model based on a pre-trained model and trained on Kaggle dataset of plants and animals. 

2. Capable of taking pictures. 

3. Capable of giving a list of what the model thinks the image is.

4. Handle cases where the model is not sure what the image is.

5. Allow the user to take more pictures or another picture to get a more accurate identification.

### App Evaluation

- **Category:**
    - Nature
- **Mobile:**
    - Mobile is essential for this application as it requires a camera to take pictures of plants and animals.
- **Story:**
    - The application will allow users to take pictures of plants and animals and identify them.
- **Market:**
    - The market for this application is for people who are interested in nature and want to identify plants and animals.
- **Habit:**
    - This application can be used whenever a user is unsure of what a plant or animal is or when they are out camping or hiking and want to know interesting flora and fauna.
- **Scope:**
    - The application will start with a simple machine learning model that can identify plants and animals. If time allows, more features can be added such as more refined views and augmented reality.

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

1. As a user, I want to be able to take a picture of a plant or animal so that I can identify it.

2. As a user, I want to be able to see a list of what the model thinks the image is so that I can verify if it is correct.

3. As a user, I want to be able to take more pictures or another picture if the model is not sure what the image is so that I can get a more accurate identification.


### 2. Screen Archetypes

* Camera Screen
   * As a user, I want to be able to take a picture of a plant or animal so that I can identify it.

* Detail Screen
    * As a user, I want to be able to see a list of what the model thinks the image is so that I can verify if it is correct.

* More Pictures Screen
    * As a user, I want to be able to take more pictures or another picture if the model is not sure what the image is so that I can get a more accurate identification.


### 3. Navigation


**Flow Navigation** (Screen to Screen)

* Camera Screen
   * Detail Screen
   * More Pictures Screen

* Detail Screen
    * Camera Screen

* More Pictures Screen
    * Camera Screen


## Wireframes

![Identification Application Wireframe](./wireframe.png)


## Schema 

[This section will be completed in Unit 9]

### Models

#### Image

   | Property      | Type     | Description |
   | ------------- | -------- | ------------|
   | imageID       | String   | unique id for the image (default field) |
   | image         | File     | image that the user takes |
   | createdAt     | DateTime | date when image is created (default field) |
   | updatedAt     | DateTime | date when image is last updated (default field) |

#### Identification

    | Property      | Type     | Description |
    | ------------- | -------- | ------------|
    | imageID       | String   | unique id for the image (default field) |
    | output        | String   | output of the machine learning model | 

### Networking

This application does not require a network connection as the machine learning model will be stored on the device and the images will be processed on the device offline. If the application were to include networking then I would take the images and send it over to one of the several Image Recognition APIs available such as Google Vision API, Microsoft Azure Computer Vision API, or IBM Watson Visual Recognition API. The API would then return the output of the machine learning model which would be displayed to the user.


## Demo 

![Identification Application Demo](./demo.gif)


## Sprints 

1. [x] Sprint 1: Set up the project specifications, build the camera screen 

2. [] Sprint 2: identify machine learning model, research core ml and converting model from pytorch to core ml.  

3. [] Sprint 3: Build and refine camera screen and detail processing screen.

4. [] Sprint 4: Implement machine learning model and image processing.

5. [] Sprint 5: Test and refine application. Add more refined views. If time allows, incorporate more ar functionality.




