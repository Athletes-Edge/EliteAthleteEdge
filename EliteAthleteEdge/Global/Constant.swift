//
//  Constant.swift
//  Futbolist
//
//  Created by Adeel on 19/12/2019.
//  Copyright © 2019 Buzzware. All rights reserved.
//

import UIKit

struct Constant {
    
       
    static let v2 = "v2"
    static let version = "api/"
    static let mainUrl2 = "https://buzzwaretech.com/bandy/Api"
    static let mainUrlChatGPT = "https://api.openai.com/v1"
    
    static let mainUrl = "https://buzzwaretech.com/bandy/Api"
    static let carUrl = "http://137.184.111.69:5000/api"
    static let mainGoogleUrl = "https://maps.googleapis.com/maps/api"
    static let cloudUrl = "https://us-central1-spark-91121.cloudfunctions.net/widgets"
    static let mainCloudFunctionUrl = "https://us-central1-athletes-edge-95ced.cloudfunctions.net"
    //static let mainUrl = "http://192.168.18.23:3000/" + version + v2
    static let jwt_secret = "cQfTjWnZr4u7x!A%D*G-JaNdRgUkXp2s5v8y/B?E(H+MbPeShVmYq3t6w9z$C&F)"
    static let googleWeApiKey = "AIzaSyCJNLALh3oEwF-O9ThRsBy0IUyTxPSxzs0"
    //Login ApiEndpoint
    static let driverAppUrl = "itms-apps://apple.com/app/id1512372278"
    static let userAppUrl = "https://apps.apple.com/us/app/iride-user-app/id1512373184"
    static let login_key = "login_key"
    static let location_key = "location_key"
    static let term_key = "https://eliteathletesedge.com/terms.html"
    // Message Api Endpoint
    static let privacy_key = "https://eliteathletesedge.com/privacy.html"
    
    static let routes = "routes"
    static let legs = "legs"
    static let steps = "steps"
    static let polyline = "polyline"
    static let distance = "distance"
    static let duration = "duration"
    static let value = "value"
    static let points = "points"
    static let error_message = "error_message"
    static let bookingid = "bookingid"
    
    // Product Api Endpoint
    static let cus_id = "cus_id"
    static let pm_id = "pm_id"
    static let amount = "amount"
    static let code = "code"
    static let Athletes_Edge = "Athletes Edge"
    static let All_Teams = "All Teams"
    static let Specific_Teams = "Specific Teams"
    
    // Orders Api Endpoints
    static let orders = "orders/"
            //// Orders Model key's
    static let contact_person = "contact_person"
    static let phoneNumber = "phoneNumber"
    static let address = "address"
    static let city = "city"
    static let state = "state"
    static let zipcode = "zipcode"
    static let password = "password"
    static let ordered_by = "ordered_by"
    static let delivery_address = "delivery_address"
    static let ordered_products = "ordered_products"
    static let order_status = "order_status"
    static let total_price = "total_price"
    static let origin = "origin"
    static let destination = "destination"
    static let key = "key"
    
    //// model key's
    static let token_key = "token"
    static let cart = "cart"
    static let cid = "cid"
    static let unit = "unit"

        //// model key's
    static let id = "id"
    static let store_id = "store_id"
    static let subcategory_id = "subcategory_id"
    static let name = "name"
    static let store_name = "store_name"
    static let subcategory_name = "subcategory_name"
    static let is_favorite = "is_favorite"
    static let category_id = "category_id"
    static let description = "description"
    static let price = "price"
    static let recurring = "recurring"
    static let interval_count = "interval_count"
    static let has_cases = "has_cases"
    static let price_per_case = "price_per_case"
    static let qty_per_case = "qty_per_case"
    static let image_url = "image_url"
    static let imageUrl = "imageUrl"
    static let social_type = "social_type"
    static let facebook_auth_token = "facebook_auth_token"
    static let google_auth_token = "google_auth_token"
    static let metadata = "metadata"
    static let meta = "meta"
    static let created_at = "created_at"
    static let favorite = "favorite"
    static let receiver_id = "receiver_id"
    static let receiver = "receiver"
    static let sender_id = "sender_id"
    static let is_read = "is_read"
    static let sender = "sender"
    static let address_name = "address_name"
    static let address_lat = "address_lat"
    static let address_lng = "address_lng"
    //static let sender = "sender"
    
    
      ////// Order By Model Key's
    static let firstName = "firstName"
    static let lastName = "lastName"
    static let firebase_token = "firebase_token"
    static let email = "email"
            ////// Delivery Address Model Key's
    static let street_address_1 = "street_address_1"
    static let street_address_2 = "street_address_2"
    
    static let state_id = "state_id"
    static let country_id = "country_id"
    static let latitude = "latitude"
    static let longitude = "longitude"
            ////// Quantity model Key's
    static let quantity = "quantity"
    static let product = "product"
        ////// Store model Key's
    static let store = "store"
        ////// Order Status model Key's
    static let updated_at = "updated_at"
    
    
    // MARK: Segues Identifiers
    static let to_Product_Detail = "toDetailVC"
    
    
    
    static let gstPrice = 13.0
    static let servicePrice = 2.92
    static let defLatt = 43.54762429
    static let defLong = -79.62600543
    static let Card = "Card"
    static let card_id = "card_id"
    static let card_num = "card_num"
    static let card_month = "card_month"
    static let card_year = "card_year"
    static let card_cvv = "card_cvv"
    static let card_sid = "card_sid"
    static let card_postcode = "card_postcode"
    static let client_secret = "client_secret"
    
    static let token = "token"
    static let exp_month = "exp_month"
    static let exp_year = "exp_year"
    static let success = "success"
    static let sucess = "sucess"
    static let return_data = "return_data"
    static let error = "error"
    static let errors = "errors"
    static let message = "message"
    static let username = "username"
    static let role = "role"
    
    static let repeat_password = "repeat_password"
    static let phone = "phone"
    static let status = "status"
    static let unlike = "unlike"
    static let like = "like"
    static let data = "data"
    static let statusCode = "statusCode"
    
    static let street_address = "street_address"
    static let order = "order"
    
    static let stripeId = "stripeId"
    static let ca_firstname = "ca_firstname"
    static let ca_lastname = "ca_lastname"
    static let ca_email = "ca_email"
    //static let email = "email"
    static let ca_username = "ca_username"
    static let ca_password = "ca_password"
    static let ca_oath_id = "ca_oath_id"
    static let ca_type = "ca_type"
    static let ca_image_url = "ca_image_url"
    static let image = "image"
    
    static let ca_id = "ca_id"
    static let ca_status = "ca_status"
    static let is_verify = "is_verify"
    static let ca_created_at = "ca_created_at"
    static let ca_create_day = "ca_create_day"
    static let ca_create_month = "ca_create_month"
    static let ca_create_year = "ca_create_year"
    static let ca_address = "ca_address"
    static let ca_lat = "ca_lat"
    static let ca_lng = "ca_lng"
    static let ca_age = "ca_age"
    
    
    static let result = "result"
    static let orderTypeDate = "orderTypeDate"
    
    static let order_lat = "order_lat"
    static let order_lng = "order_lng"
    static let order_address = "order_address"
    static let lat = "lat"
    static let lng = "lng"
    static let main_cat_name = "main_cat_name"
    static let lowerlimittime = "lowerlimittime"
    static let upperlimittime = "upperlimittime"
    static let customer_id = "customer_id"
    static let user_id = "user_id"
    static let user_lat = "user_lat"
    static let user_long = "user_long"
    static let token_id = "token_id"
    
    
    static let cat_id = "cat_id"
    static let cat_index = "cat_index"
    static let cat_name = "cat_name"
    //static let id = "id"
    static let preview = "preview"
    static let msg = "msg"
    
    
    static let feature_video = "feature_video"
    static let video_id = "video_id"
    static let video_url = "video_url"
    
    static let res_id = "res_id"
    static let res_index = "res_index"
    static let res_name = "res_name"
    
    
    
    static let restaurant_id = "restaurant_id"
    static let restaurant_name = "restaurant_name"
    static let restaurant_description = "restaurant_description"
    static let res_image_url = "res_image_url"
    static let meal_type = "meal_type"
    static let meal_prepration_start_time = "meal_prepration_start_time"
    static let meal_prepration_end_time = "meal_prepration_end_time"
    static let meal_real_price = "meal_real_price"
    static let meals_id = "meals_id"
    static let meals_image_url = "meals_image_url"
    static let meals_days_id = "meals_days_id"
    static let restaurant_lat = "restaurant_lat"
    static let restaurant_lng = "restaurant_lng"
    static let restaurant_address = "restaurant_address"
    static let res_complete_Address = "res_complete_Address"
    static let day = "day"
    static let discount_price = "discount_price"
    static let totalquantity = "totalquantity"
    static let available_quantity = "available_quantity"
    static let inserted_date = "inserted_date"
    static let like_status = "like_status"
    static let remaining_quantity = "remaining_quantity"
    
    static let meail = "meail"
    static let meal_status = "meal_status"
    static let meal_inserted_date = "meal_inserted_date"
    static let meals_days = "meals_days"
    //static let quantity = "quantity"
    static let meals_upload = "meals_upload"
    
    static let restaurant_branch_name = "restaurant_branch_name"
    static let restaurant_phone_no = "restaurant_phone_no"
    
    static let notification_id = "notification_id"
    static let notification_text = "notification_text"
    static let notification_inserted_date = "notification_inserted_date"
    static let isNotify = "isNotify"
    
    
    static let order_id = "order_id"
    static let status_code_id = "status_code_id"
    static let order_deliver_time = "order_deliver_time"
    static let order_deliver_date = "order_deliver_date"
    static let bill = "bill"
    static let order_quantity = "order_quantity"
    static let order_type = "order_type"
    
    static let card_number = "card_number"
    
    // FIREBASE NODES ....
    static let WEB_URL = "https://writearticlesforme.com"
    static let NODE_USERS = "Users"
    static let NODE_PRODUCTS = "Products"
    static let NODE_CHECK = "CheckIn"
    static let NODE_CHECKQues = "CheckInQuestions"

    static let NODE_SUBSCRIPTIONS = "Subscriptions"
    
    static let NODE_QUAIZ = "Quaiz"
    static let NODE_INSTRUMNETS = "Instrumentalist"
    static let NODE_SCHEDULE = "Schedules"

    static let NODE_CATEGORY = "Category"
    static let NODE_COMMENTS = "Comments"
    static let NODE_VERSES = "Verse"
    static let NODE_SONGNOTI = "SongNotification"

    
    static let NODE_RATINGS = "Ratings"

    static let NODE_REACTS = "VideoReacts"
    static let NODE_PROFESSION = "Profession"
    static let NODE_SONGS = "Songs"
    static let NODE_DATES = "Dates"
    static let NODE_Teams = "Teams"
    static let NODE_NOTES = "Notes"
    static let NODE_COURSES = "Courses"
    static let NODE_COURSE_Statistic = "CourseStatistic"
    static let NODE_Statistic = "Statistic"
    static let NODE_COACHES = "Coaches"
    static let NODE_CATEGORIES = "Categories"
    static let NODE_QUESTIONS = "questions"
    static let NODE_COURSEOVERVIEW = "CourseOverview"
    static let NODE_RATING = "rating"
    static let NODE_INVITATIONS = "Invitation"
    static let NODE_CHAPTERS = "Chapters"
    
    static let NODE_REPORT = "Reports"
    static let NODE_BANNERS = "Banners"
    static let NODE_RECORDS = "Records"
    static let NODE_MEMOS = "Memos"

    static let NODE_REPLIES = "Replies"
    static let NODE_PACKAGES = "Packages"
    static let NODE_INSURANCE = "Insurance"
    static let NODE_BUSINESS = "Business"
    static let NODE_REFERENCE = "Reference"
    static let NODE_SETTINGS = "Settings"
    static let NODE_PRICES = "Prices"
    static let NODE_PROMOTIONS = "Promotions"
    
    static let NODE_CONTACT = "contact"
    static let NODE_CHARGES = "charges"
    static let NODE_LIMITS = "limits"
    static let NODE_REQUEST_RIDES = "RequestRides"
    static let NODE_NOTI = "Notification"
    static let NODE_SCHEDULED_RIDES = "ScheduledRides"
    static let NODE_EMERGENCY = "Emergency"
    static let NODE_CURRENT_USER_UID = "currentUserUID"
    static let NODE_COUNTRY = "Country"
    static let NODE_BRANCHES = "Branches"
    static let NODE_COUNTRY_ID = "countryId"
    static let NODE_PURPOSE_TYPES = "PurposeTypes"
    static let NODE_BRANCH_ID = "branchId"
    static let NODE_PURPOSE_ID = "purposeId"
    static let NODE_CHATS = "Chats"
    static let NODE_ADMINCHAT = "AdminChat"
    static let NODE_CONVERSATIONS = "Conversations"
    static let NODE_USER_BRANCHES = "userBranches"
    static let NODE_MY_REQUESTS = "MyRequests"
    static let NODE_REQUESTS = "Requests"
    static let NODE_BOOKINGS = "Bookings"

    static let Montserrat_Regular = "Montserrat-Regular"
    static let Montserrat_Italic = "Montserrat-Italic"
    static let Montserrat_ExtraLight = "Montserrat-ExtraLight"
    static let Montserrat_Thin = "Montserrat-Thin"
    static let Montserrat_ExtraLightItalic = "Montserrat-ExtraLightItalic"
    static let Montserrat_ThinItalic = "Montserrat-ThinItalic"
    static let Montserrat_Light = "Montserrat-Light"
    static let Montserrat_LightItalic = "Montserrat-LightItalic"
    static let Montserrat_Medium = "Montserrat-Medium"
    static let Montserrat_MediumItalic = "Montserrat-MediumItalic"
    static let Montserrat_SemiBold = "Montserrat-SemiBold"
    static let Montserrat_SemiBoldItalic = "Montserrat-SemiBoldItalic"
    static let Montserrat_Bold = "Montserrat-Bold"
    static let Montserrat_BoldItalic = "Montserrat-BoldItalic"
    static let Montserrat_ExtraBoldItalic = "Montserrat-ExtraBoldItalic"
    static let Montserrat_Black = "Montserrat-Black"
    static let Montserrat_BlackItalic = "Montserrat-BlackItalic"





    
}
