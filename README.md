# FARMACY

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
Farmacy provides farmers with personalized plans on when to plant, fertilize, and irrigate based on weather and trend data to optimal product yields

### App Evaluation
- **Category:** Agriculture
- **Mobile:** Farmacy helps farmers with chat and video call (optional) feature to connect with agriculture experts, weather API and push notifications feature to reminder when to plant, fertilize, and irrigate. These features make mobile app more than website
- **Story:** Given insightful data, personalized plans on when to plant, fertilize, and irrigate, Farmacy can help increase the farmer’s yield
- **Market:** Farmacy targets on farmers who need help with their crop plan
- **Habit:** Farmers use Farmacy on a daily basis to check on the weather API along with reminders on when to plant, fertilize, and irrigate
- **Scope:** See technical challenge bellow

## Technical Challenge
- Implement an analytics algorithm using data mining techniques to suggest farmer when to plant, fertilize, and irrigate. To accomplish it, I will utilize weather, soil and other data specific to the area.
- Implement calendar on when to plant/fertilize/irrigate and allow farmers to view schedule on the specific day. This calendar will be modified synchronously per change of crops addition/removal
- Implement and push reminder notifications on when to plant/fertilize/irrigate based on calendar and tips of a day!
- Implement chat feature allowing farmers to connect with experts in the real time


## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* Farmer can log in/sign up and log out using Facebook SDK for iOS
* Farmer can add/delete crops to/from grow to My Crops list
* Farmer can view calendar to know when to plant, fertilize, and irrigate
* Farmer can view their crops' progress 
* Farmer can chat with agriculture experts 
* Farmer can view weather forecast
* Farmer can be notified the schedule by chat bot and via notifications
* Farmer can be advised with some tips of the day via notifications

**Optional Nice-to-have Stories**
* Farmer can view Farmacy's recommendations on the best crops to grow based on their market, geographic, and environmental patterns 
* Based on recommendations, Farmers can choose which crops to grow or remove 
* Farmer can view data visualization of weather data, data oncrop variation datasets, soil data projections, market, geographic, and environmental patterns
* Farmer can make a video call with agriculture experts
* Farmer can view knowledge hub with list of disease and treatments


### 2. Screen Archetypes

* Login Screen
   * User can login
* Registration Screen
   * User can create a new account
* Dashboard (Nice-to-have)
    * User can view data visualation on data oncrop variation datasets, soil data projections, market, geographic, and environmental patterns
* Weather Forecast
    * User can view weather forecast
* Recommendations (Nice-to-have)
    * User can view recommendations on crops to grow
* Calendar
    * User can view schedule when to plant, fertilize, and irrigate crops
* My Crops
    * User can view their choosen crops' progress.

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* My Crops
* Calendar
* Weather Forecast
* Dashboard (Nice-to-have)

**Flow Navigation** (Screen to Screen)

* Login Screen
   
   => My crops Screen
* Register Screen
   
   => Recommendation Screen (Nice-to-have)
* Recommendation Screen (Nice-to-have)
   
   => My Crops Screen (when the adding all crops to list clicked)
   
   => Dashboard (when the insightful icon is clicked)
* Calendar Screen
   
   => None
* Weather Forecast Screen

  => Calendar Screen (when calendar icon is clicked)
  
* My Crops Screen

  => Detail Crop Screen (when select specific crop cell)
  
  => Calendar Screen (when calendar icon is clicked)

## Wireframes

<img src="https://i.imgur.com/RPUwqYd.jpeg" width=900>

## Schema 
### Models: Crops
| Property | Type | Description |
| --- | --- | --- |
| objectId | String | unique id for the crop |
| plantedAt | DateTime | date when crop is planted |
| image | Image | image of the crop |
| name | String | string name of the crop | 
 | schedule | File | file schedule on when to plant, fertilize, and irrigate |
 | progress | Number | percentage shows progress until it is harvested |
 
(Updating)

### Networking
* Weather Forecast Screen
  * (READ/GET) Query weather forecast in the next 10 days
* Calendar Screen
  * (READ/GET) Query combination of schedule of chosen crops
  * (CREATE/POST) Create a new tick "Done" for specific task
* My Crops Screen
  * (CREATE/POST) Create a new crop from Recommendation Screen to My Crops
  * (Delete) Delete the crop from My Crops
  * (READ/GET) Query information on each crop
* Recommendation (Nice-to-have)
  * (READ/GET) Query top recommendations from analyzing data on weather, soil,..
