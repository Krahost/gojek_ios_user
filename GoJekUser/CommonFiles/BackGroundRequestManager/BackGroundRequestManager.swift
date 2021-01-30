//
//  BackGroundRequestManager.swift
//  GoJekUser
//
//  Created by Rajes on 06/05/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import Foundation

enum BackGroundRequestType {
    case CommonRequest
    case ModuleWise
//    case SettingUpdate
}

enum ActiveStatus: String {
    case active = "ACTIVE"
    case transport = "TRANSPORT"
    case delivery = "DELIVERY"
    case service = "SERVICE"
    case order = "ORDER"
}

class BackGroundRequestManager {
    
    static var share = BackGroundRequestManager()
    
    private weak var timer:Timer!
    
    var requestCallback: (() -> ())? = nil
    
    func startBackGroundRequest(type: BackGroundRequestType, roomId: String,listener: RoomListener) {
        
        print("startBackGroundRequest")
        if !XSocketIOManager.sharedInstance.socketIsConnected() {
            
            XSocketIOManager.sharedInstance.establishSocketConnection()
            initiateTimerFunction(type: type, roomId: roomId, listener: listener)
            
            
        } else if !XSocketIOManager.sharedInstance.connectedWithRoom || XSocketIOManager.sharedInstance.connectedRoomType != roomId {
            resetBackGroudTask()
            checkSocketConnection(requesType: type,roomID:roomId, moduleKey: listener)
            
        }
        
        
    }
    
    func initiateTimerFunction(type: BackGroundRequestType, roomId: String,listener: RoomListener) {
        let context = ["RequestType": type,"roomID": roomId,"ListenerKey": listener] as [String : Any]
        if self.timer == nil {
            self.timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(timerFunction), userInfo: context, repeats: true)
            self.requestCallback?()
            print("Background thread initiated")
            
        }
    }
    
    func checkSocketConnection(requesType:BackGroundRequestType,roomID:String,moduleKey:RoomListener) {
        
        if XSocketIOManager.sharedInstance.socketIsConnected() {
            if XSocketIOManager.sharedInstance.connectedWithRoom { stopBackGroundRequest() }
            switch requesType {
            case .CommonRequest:
                initiateCommonRoomRequest(roomID: roomID, listener: moduleKey)
            case .ModuleWise:
                initiatePrivateRoomtRequest(roomID: roomID,listener: moduleKey)
            }
        } else {
            DispatchQueue.main.async {
                XSocketIOManager.sharedInstance.establishSocketConnection()
                self.checkSocketConnection(requesType: requesType, roomID: roomID,moduleKey: moduleKey)
            }
        }
    }
    
   func initiateCommonRoomRequest(roomID: String,listener: RoomListener) {
        XSocketIOManager.sharedInstance.checkSocketRequest(inputValue: (Constant.CommonUserRoom,roomID,listener)) {
            self.requestCallback?()
        }
    }
    func initiateRequest(listener: RoomListener) {
        XSocketIOManager.sharedInstance.checkSettingUpdate(completionHandler: {
            self.requestCallback?()
        })
    }
    
    
    func initiatePrivateRoomtRequest(roomID: String,listener: RoomListener) {
        XSocketIOManager.sharedInstance.checkSocketRequest(inputValue: (Constant.PrivateRoomKey,roomID,listener)) {
            self.requestCallback?()
        }
    }
    
    @objc func timerFunction(timerData: Timer) {
        
        print("Fire timer function")
        print("socket not connected timer alive")
        print("time interval \(Date().timeIntervalSinceNow)")
        guard let context = timerData.userInfo as? [String: Any] else { return }
        if XSocketIOManager.sharedInstance.socketIsConnected() && XSocketIOManager.sharedInstance.connectedWithRoom {
            stopBackGroundRequest()
        } else {
            if let type = context["RequestType"] as? BackGroundRequestType,let key = context["roomID"] as? String,
                let listener = context["ListenerKey"] as? RoomListener {
                //checkSocketConnection(requesType: type, roomID: key, moduleKey: listener)
                startBackGroundRequest(type: type, roomId: key, listener: listener)
            }
            requestCallback?()
        }
        
        
       
    }
    
    func stopBackGroundRequest() {
        DispatchQueue.main.async {
            if let _ = self.timer {
                self.timer.invalidate()
                self.timer = nil
                self.stopBackGroundRequest()
                print("stopBackGroundRequest")
            }
        }
    }
    
    func resetBackGroudTask() {
        stopBackGroundRequest()
        XSocketIOManager.sharedInstance.connectedWithRoom = false
        XSocketIOManager.sharedInstance.leaveCurrentRoom()
    }
    
}

