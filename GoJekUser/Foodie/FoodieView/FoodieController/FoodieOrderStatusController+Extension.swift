//
//  FoodieOrderStatusController+Extension.swift
//  GoJekUser
//
//  Created by CSS on 05/05/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

extension FoodieOrderStatusViewController {
    
    // Handle Request Data
    
    func handleRequest(request: FoodieOrderDetailEntity) {
        
        guard let status = request.responseData?.status, request.responseData?.id != nil else { return }
        let currentRequest = request.responseData
        switch status {
        case foodieOrderStatus.searching.rawValue: break
          //  self.showLoaderView()
//            self.perform(#selector(self.validateRequest), with: self, afterDelay: APPConstant.AppDetails.taxiRequestInterval)
//            isdrawPollyline = false
            
        case foodieOrderStatus.accepted.rawValue, foodieOrderStatus.started.rawValue, foodieOrderStatus.arrived.rawValue, foodieOrderStatus.pickedup.rawValue : break
//            self.loaderView?.isHidden = true
//
//            if  self.isTapCancelOnRide == false {
//                self.showRideStatusView(with: request)
//            }
//
//            if !isdrawPollyline{
//                self.sourceLocationDetail = SourceDestinationLocation(address: currentRequest?.s_address, locationCoordinate: LocationCoordinate(latitude: currentRequest?.s_latitude ?? 0, longitude: currentRequest?.s_longitude ?? 0))
//                self.destinationDetail = SourceDestinationLocation(address: currentRequest?.d_address, locationCoordinate:LocationCoordinate(latitude: currentRequest?.d_latitude ?? 0, longitude: currentRequest?.d_longitude ?? 0) )
//                drawPolyline()
//            }
//
            
        case foodieOrderStatus.dropped.rawValue: break
//            self.showInvoice(with: request)
//            riderStatus = .none
//            isInvoiceShowed = true
            
        case TaxiRideStatus.completed.rawValue: break
//            self.rideStatusView?.isHidden = true
//            self.rideStatusView = nil
//            let requestVal = request.responseData?.data?.first
//            LoadingIndicator.hide()
//            // Card payment with wallet and without wallet folw
//
//            if requestVal?.payment_mode == PaymentType.CARD.rawValue {
//                if requestVal?.use_wallet == 1 {
//                    if requestVal?.paid == 0 {
//                        self.showInvoice(with: request)
//                    }
//                    else {
//                        if isInvoiceShowed {
//                            self.showRatingView(with: request)
//                        }else {
//                            self.showInvoice(with: request)
//                        }
//                    }
//                }
//                else {
//                    if isInvoiceShowed || requestVal?.paid == 1 {
//                        showRatingView(with: request)
//                    }
//                    else {
//                        showInvoice(with: request)
//                    }
//                }
//            }
                // cash payment with wallet and without wallet
//            else {
//                if requestVal?.use_wallet == 1 {
//                    if requestVal?.paid == 0 {
//                        self.showInvoice(with: request)
//                    }
//                    else {
//                        if isInvoiceShowed {
//                            self.showRatingView(with: request)
//                        }
//                        else {
//                            self.showInvoice(with: request)
//                        }
//                    }
//                }
//                else {
//                    if isInvoiceShowed {
//                        self.showRatingView(with: request)
//                    }
//                    else{
//                        showInvoice(with: request)
//                    }
//                }
//            }
            
        default:
            break
        }
       // self.removeUnnecessaryView(with: TaxiRideStatus(rawValue: status) ?? .none)
    }
    
    
    // for remove unnecesary view
    func removeUnnecessaryView(with status: TaxiRideStatus) {

//        if ![TaxiRideStatus.searching.rawValue].contains(status.rawValue) {
//            self.loaderView?.isHidden = true
//        }
    }
    
  
}

