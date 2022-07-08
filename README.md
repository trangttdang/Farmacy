# FARMACY

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
Farmacy provides farmers with recommendations on the best crops to grow based on their market, geographic, and environmental patterns to optimal product yields

### App Evaluation
- **Category:** Agriculture
- **Mobile:** Farmacy helps farmers with chat and video call feature to connect with agriculture experts, weather API and push notifications feature to reminder when to plant, fertilize, and irrigate. These features make mobile app more than website
- **Story:** Given insightful data, recommendations on best crops, and crop schedule, farmers will have more informed decision on crops to grow to optimal product yields and decrease exposure to volatility
- **Market:** Farmacy targets on farmers who need help with their crop plan
- **Habit:** Farmers use Farmacy on a daily basis to check on the weather API along with reminders on when to plant, fertilize, and irrigate
- **Scope:** Technical Challenge is to analyze and provide insightful data, and provide recommendations to optimal product yields

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* Farmer can log in and sign up
* Based on recommendations, Farmers can choose which crops to grow or remove
* Farmer can manage when to plant, fertilize, and irrigate them with reminders/ notifications
* Farmer can chat with agriculture experts
* Farmer can view weather forecast

**Optional Nice-to-have Stories**

* Farmer can view data visualization of weather data, data oncrop variation datasets, soil data projections, market, geographic, and environmental patterns
* Farmer can make a video call with agriculture experts
* Farmer can view calendar of when to plant, fertilize, and irrigate
* Farmer can view knowledge hub with list of disease and treatments

### 2. Screen Archetypes
* Login Screen
  * User can login
* Registration Screen
  * User can create a new account
* Dashboard (Nice-to-have)
  * User can view data visualation on data oncrop variation datasets, soil data projections, market, geographic, and environmental patterns
* Weather Forecast
  *User can view weather forecast
* Recommendations
  *User can view recommendations on crops to grow
* Calendar
  * User can view schedule when to plant, fertilize, and irrigate crops
* My Crops
  *User can view their choosen crops' progress.
  
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

=> Recommendation Screen

* Recommendation Screen

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

<img src="https://i.imgur.com/AoxP5x6.jpg" width=400>

## Schema
### Models: Crops
| Property | Type	| Description |
| --- | --- | --- |
| objectId | DateTime	| unique id for the crop |
| plantedAt	| String	date when crop is planted
| image	| Image	| image of the crop |
| name	| String	| string name of the crop |
| schedule	| File	| file schedule on when to plant, fertilize, and irrigate |
| progress	| Number | percentage shows progress until it is harvested |

### Networking
- Weather Forecast Screen
(READ/GET) Query weather forecast in the next 10 days
- Calendar Screen
(READ/GET) Query combination of schedule of chosen crops
(CREATE/POST) Create a new tick "Done" for specific task
- My Crops Screen
(CREATE/POST) Create a new crop from Recommendation Screen to My Crops
(Delete) Delete the crop from My Crops
(READ/GET) Query information on each crop
- Recommendation
(READ/GET) Query top recommendations from analyzing data on weather, soil,..
