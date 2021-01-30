//
//  TransactionEntity.swift
//  GoJekUser
//
//  Created by  on 09/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import Foundation
import ObjectMapper

struct TransactionEntity : Mappable {
    var statusCode : String?
    var title : String?
    var message : String?
    var responseData : TransactionResponseData?
    var error : [String]?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        statusCode <- map["statusCode"]
        title <- map["title"]
        message <- map["message"]
        responseData <- map["responseData"]
        error <- map["error"]
    }
    
}

struct TransactionResponseData : Mappable {
    var current_page : Int?
    var transactionList : [TransactionList]?
    var first_page_url : String?
    var from : Int?
    var last_page : Int?
    var last_page_url : String?
    var next_page_url : String?
    var path : String?
    var per_page : Int?
    var prev_page_url : String?
    var to : Int?
    var total : Int?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        current_page <- map["current_page"]
        transactionList <- map["data"]
        first_page_url <- map["first_page_url"]
        from <- map["from"]
        last_page <- map["last_page"]
        last_page_url <- map["last_page_url"]
        next_page_url <- map["next_page_url"]
        path <- map["path"]
        per_page <- map["per_page"]
        prev_page_url <- map["prev_page_url"]
        to <- map["to"]
        total <- map["total_records"]
    }
    
}


struct TransactionList : Mappable {
    var id : Int?
    var user_id : Int?
    var company_id : Int?
    var transaction_id : Int?
    var transaction_alias : String?
    var transaction_desc : String?
    var type : String?
    var amount : Double?
    var open_balance : Int?
    var close_balance : Int?
    var payment_log : Payment_log?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        user_id <- map["user_id"]
        company_id <- map["company_id"]
        transaction_id <- map["transaction_id"]
        transaction_alias <- map["transaction_alias"]
        transaction_desc <- map["transaction_desc"]
        type <- map["type"]
        amount <- map["amount"]
        open_balance <- map["open_balance"]
        close_balance <- map["close_balance"]
        payment_log <- map["payment_log"]
    }
    
}


struct Payment_log : Mappable {
    var id : Int?
    var company_id : Int?
    var is_wallet : Int?
    var user_type : String?
    var payment_mode : String?
    var user_id : Int?
    var amount : Int?
    var transaction_code : String?
    var transaction_id : String?
    var response : String?
    var created_type : String?
    var created_by : Int?
    var modified_type : String?
    var modified_by : Int?
    var deleted_type : String?
    var deleted_by : String?
    var created_at : String?
    var updated_at : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        company_id <- map["company_id"]
        is_wallet <- map["is_wallet"]
        user_type <- map["user_type"]
        payment_mode <- map["payment_mode"]
        user_id <- map["user_id"]
        amount <- map["amount"]
        transaction_code <- map["transaction_code"]
        transaction_id <- map["transaction_id"]
        response <- map["response"]
        created_type <- map["created_type"]
        created_by <- map["created_by"]
        modified_type <- map["modified_type"]
        modified_by <- map["modified_by"]
        deleted_type <- map["deleted_type"]
        deleted_by <- map["deleted_by"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
    }
    
}
