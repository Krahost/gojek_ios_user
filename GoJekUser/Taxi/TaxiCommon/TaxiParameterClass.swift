//
//  TaxiParameterClass.swift
//  GoJekUser
//
//  Created by Ansar on 21/06/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import Foundation
import Alamofire

extension Parameters {
    
   static func setTaxiRequestParameter(requestEntity: TaxiReuqestEntity) -> Parameters {
        var param: Parameters = [TaxiConstant.s_latitude: requestEntity.s_latitude ?? 0,
                                 TaxiConstant.s_longitude: requestEntity.s_longitude ?? 0,
                                 TaxiConstant.service_type: requestEntity.service_type ?? 0,
                                 TaxiConstant.d_latitude: requestEntity.d_latitude ?? 0,
                                 TaxiConstant.d_longitude: requestEntity.d_longitude ?? 0,
                                 TaxiConstant.distance: requestEntity.distance ?? 0.0,
                                 TaxiConstant.payment_mode: requestEntity.payment_mode ?? PaymentType.CASH.rawValue,
                                 TaxiConstant.use_wallet: requestEntity.use_wallet ?? 0,
                                 TaxiConstant.wheelchair: requestEntity.wheel_chair ?? 0,
                                 TaxiConstant.child_seat: requestEntity.child_seat ?? 0,
                                 TaxiConstant.someone: requestEntity.someone ?? 0,
                                 TaxiConstant.someone_name: requestEntity.someone_name ?? "",
                                 TaxiConstant.someone_mobile: requestEntity.someone_mobile ?? "",
                                 TaxiConstant.someone_email: requestEntity.someone_email ?? "",
                                 TaxiConstant.promocode_id: requestEntity.promocode_id ?? 0,
                                 TaxiConstant.s_address:requestEntity.s_address ?? "",
                                 TaxiConstant.d_address :requestEntity.d_address ?? "",
                                 TaxiConstant.ride_type_id : requestEntity.rideTypeId ?? 0]
        
        if requestEntity.payment_mode == PaymentType.CARD.rawValue {
            param[TaxiConstant.card_id] = requestEntity.card_id ?? ""
        }
    if requestEntity.isSchedule == true {
            param[TaxiConstant.schedule_date] = requestEntity.schedule_date ?? ""
            param[TaxiConstant.schedule_time] = requestEntity.schedule_time ?? ""
        }
        return param
    }
    
    static func setEstimateFareParameter(requestEntity: TaxiReuqestEntity) -> Parameters {
        let parameter: Parameters = [TaxiConstant.s_latitude: requestEntity.s_latitude ?? 0,
                                     TaxiConstant.s_longitude: requestEntity.s_longitude ?? 0,
                                     TaxiConstant.service_type: requestEntity.service_type ?? 0,
                                     TaxiConstant.d_latitude: requestEntity.d_latitude ?? 0,
                                     TaxiConstant.d_longitude: requestEntity.d_longitude ?? 0,
                                     TaxiConstant.payment_mode: requestEntity.payment_mode ?? "",TaxiConstant.promocode_id : requestEntity.promocode_id ?? 0,TaxiConstant.max_amount : requestEntity.max_amount ?? 0, TaxiConstant.percentage : requestEntity.percentage ?? 0]
        return parameter
    }
}
