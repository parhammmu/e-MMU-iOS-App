//
//  AppConstant.swift
//  e-MMU
//
//  Created by Parham on 25/12/2014.
//  Copyright (c) 2014 Parham Majdabadi. All rights reserved.
//

import Foundation

// Colours
let BG_COLOUR = UIColor(red: 249.0/255.0, green: 249.0/255.0, blue: 249.0/255.0, alpha: 1.0)
let NAVIGATION_COLOUR = UIColor(red: 33.0/255.0, green: 204.0/255.0, blue: 159.0/255.0, alpha: 1.0)
let NAVIGATION_TINT_COLOUR = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
let HEADER_FONT_COLOUR = UIColor(red: 236.0/255.0, green: 236.0/255.0, blue: 238.0/255.0, alpha: 1.0)
let BODY_FONT_COLOUR = UIColor(red: 53.0/255.0, green: 57.0/255.0, blue: 65.0/255.0, alpha: 1.0)
let BORDER_COLOUR = UIColor(red: 213.0/255.0, green: 213.0/255.0, blue: 213.0/255.0, alpha: 1.0)
let MENU_BG = UIColor(red: 43.0/255.0, green: 47.0/255.0, blue: 62.0/255.0, alpha: 1.0)
let BUTTON_COLOUR = UIColor(red: 33.0/255.0, green: 204.0/255.0, blue: 159.0/255.0, alpha: 1.0)
let MENU_FONT_BODY_COLOUR = UIColor.whiteColor()
let MENU_BORDER_COLOUR = UIColor(red: 53.0/255.0, green: 58.0/255, blue: 76.0/255.0, alpha: 1.0)
let MAIN_FONT_COLOUR = UIColor(red: 43.0/255.0, green: 47.0/255.0, blue: 62.0/255.0, alpha: 1.0)
let GRAY_COLOUR = UIColor(red: 246.0/255.0, green: 246.0/255.0, blue: 246.0/255.0, alpha: 1.0)
let GRAY_FONT_COLOUR = UIColor(red: 198.0/255.0, green: 198.0/255.0, blue: 198.0/255.0, alpha: 1.0)


// Fonts
let BODY_FONT = UIFont(name: "OpenSans", size: 13.0)
let PROFILE_BODY_FONT = UIFont(name: "OpenSans", size: 16.0)
let HEADER_FONT = UIFont(name: "Roboto-Bold", size: 16.0)
let MENU_BODY_FONT = UIFont(name: "OpenSans", size: 14.0)
let MENU_HEADER_FONT = UIFont(name: "OpenSans", size: 25.0)
let MENU_NAME_FONT = UIFont(name: "Roboto-Bold", size: 20.0)
let BUTTON_FONT = UIFont(name: "OpenSans", size: 22.0)

// News images
let BUSINESS_CATEGORY_IMAGES = ["business-cat", "business-cat1"]
let EDUCATION_CATEGORY_IMAGES = ["education-cat", "education-cat1"]
let RESEARCH_CATEGORY_IMAGES = ["research-cat", "research-cat1"]

// Keys for class names
let CONVERSATION_KEY = "Conversation"
let CONVERSATION_TEXT_KEY = "ConversationText"
let BLACKLIST_KEY = "Blacklist"

// Keys for attribute names
let OBJECT_ID_KEY = "objectId"
let UPDATED_AT_KEY = "updateAt"
let CREATED_AT_KEY = "createdAt"
let BLACK_LIST_USERS_KEY = "users"
let CONVERSATION_IS_VALID_KEY = "isValid"
let CONVERSATION_USER_ONE_KEY = "userOne"
let CONVERSATION_USER_TWO_KEY = "userTwo"
let CONVERSATION_TEXT_BELONG_TO_KEY = "belongTo"
let CONVERSATION_TEXT_CONVERSATION_ID_KEY = "conversationId"
let CONVERSATION_TEXT_TEXT_KEY = "text"
let USER_AGE_KEY = "age"
let USER_BLACKLIST_KEY = "blacklist"
let USER_PICTURES_KEY = "pictures"
let USER_LAST_NAME_KEY = "lastName"
let USER_FIRST_NAME_KEY = "firstName"
let USER_GENDER_KEY = "gender"
let USER_FACULTY_KEY = "faculty"
let USER_EMAIL_KEY = "email"
let USER_About_KEY = "about"
let USER_STUDENT_NUMBER = "studentNumber"

let RECEIVE_PUSH_KEY = "receivePush"


// Enums
enum Faculty : String {
    case Business = "Faculty of Business and Law"
    case Education = "Faculty of Education"
    case Health = "Faculty of Health, Psychology and Social Care"
    case Humanity = "Faculty of Humanities, Languages and Social Science"
    case Science = "Faculty of Science and Engineering"
    case Hollings = "Hollings Faculty"
    case Art = "Manchester School of Art"
    case Cheshire = "Cheshire campus"
    case All = "All"
}

enum Sex : String {
    case Male = "male"
    case Female = "female"
}

