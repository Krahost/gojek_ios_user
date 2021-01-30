//
//  XSocketIOManager.swift
//  GoJekUser
//
//  Created by Rajes on 06/05/19.
//  Copyright © 2019 Appoets. All rights reserved.
//


import UIKit
import SocketIO

typealias SocketInputTuple = (RoomKey: String, RoomID: String, listenerKey: RoomListener)

class XSocketIOManager: NSObject {
    
    static let sharedInstance = XSocketIOManager()
    
    let manager = SocketManager(socketURL: URL(string: APPConstant.socketBaseUrl)!, config: [.log(false), .compress,.reconnects(true),.forcePolling(true),.reconnectWait(5)])
    var socket: SocketIOClient?
    var connectedWithRoom = false
    var connectedRoomType:String!
    
    override init() {
        super.init()
        socket = manager.defaultSocket
    }
    
    //Connect socket
    func establishSocketConnection() {
        print("---establishSocketConnection---")
        
        switch socket?.status ??  SocketIOStatus.notConnected {
        case .notConnected,.disconnected:
            socket?.connect()
        case .connecting,.connected:
            break
        }
    }
    
    //Disconnect socket
    func closeSocketConnection() {
        
        print("Manually disconnect socket")
        connectedWithRoom = false
        socket?.disconnect()
    }
    
    func socketIsConnected() -> Bool {
        return socket?.status == SocketIOStatus.connected ? true : false
    }
    
    func sendSocketRequest(requestId: Int,serviceType: ActiveStatus,listenerType: RoomListener,completion: @escaping ()->Void){
        if XSocketIOManager.sharedInstance.connectedWithRoom { return }
        let saltKey = APPConstant.salt_key.fromBase64() ?? ""
        BackGroundRequestManager.share.startBackGroundRequest(type: .ModuleWise, roomId: "room_\(saltKey)_R\(requestId)_\(serviceType.rawValue)", listener: listenerType)
        BackGroundRequestManager.share.requestCallback = {
            completion()
            print("socket call back")
        }
    }
    
    func checkSocketRequest(inputValue: SocketInputTuple, completionHandler: @escaping() -> Void) {
        print("Socket Connected--->",socketIsConnected())
        print("listener Key for Room \(inputValue.RoomID) : \(inputValue.listenerKey.rawValue)")
        if socket?.status == SocketIOStatus.notConnected {
            establishSocketConnection()
        }
        else if !self.connectedWithRoom {
            socket?.emit(inputValue.RoomKey, inputValue.RoomID, completion: {
                print("Socket emit data success")
            })
            
            socket?.on(Constant.SocketStatus, callback: { (data, ack) in
                print("Socket status \(data)")
                self.connectedWithRoom = true
                self.connectedRoomType = inputValue.RoomID
            })
          socket?.on(Constant.SettingUpdate, callback: { (data, ack) in
                       print("listener status \(data)")
                       completionHandler()
                   })
            
            socket?.on(inputValue.listenerKey.rawValue, callback: { (data, ack) in
                print("listener status \(data)")
                completionHandler()
            })
        }
    }
    
    func chatCheckSocketRequest(input: String, completionHandler: @escaping(_ result: ChatDataEntity) -> Void) {
        if socket?.status == SocketIOStatus.notConnected {
            establishSocketConnection()
        }
        else {
            socket?.emit(Constant.JoinPrivateChatRoom, input, completion: {
                print("Chat Socket room connected")
            })
            
            socket?.on(Constant.NewMessage, callback: { (data, ack) in
                print("Chat listener status \(data)")
                guard let dict = data[0] as? [String: Any] else { return }
                guard let placeDetail = ChatDataEntity.init(JSON: dict) else { return }
                completionHandler(placeDetail)
            })
        }
    }
    
    //Send message via socket room
    func setChatToSocketRequest(input: Dictionary<String, Any>) {
        if socket?.status == SocketIOStatus.notConnected {
            establishSocketConnection()
        }
        else {
            
            socket?.emit(Constant.JoinPrivateChatRoom, input, completion: {
                print("Chat Socket room connected")
            })
            
            socket?.emit(Constant.SendMessage, input, completion: {
                print("Send meesage Chat Socket room")
            })
        }
    }
    
    func checkProviderNewLocation(completionHandler: @escaping(_ result: SocketLocation) -> Void) {
        if socket?.status == SocketIOStatus.notConnected {
            establishSocketConnection()
        }
        else {
            socket?.on(Constant.UpdateLocation, callback: { (data, ack) in
                print("Provider listener status \(data)")
                guard let dict = data[0] as? [String: Any] else { return }
                guard let placeDetail = SocketLocation.init(JSON: dict) else { return }
                completionHandler(placeDetail)
            })
        }
    }
    
    func checkSettingUpdate(completionHandler:@escaping () -> Void) {

        if socket?.status == SocketIOStatus.notConnected {
            establishSocketConnection()
        }
        else {
            socket?.on(Constant.SettingUpdate, callback: { (data, ack) in
                print("listener status \(data)")
                completionHandler()
            })
        }
    }
    
    func leaveCurrentRoom() {
        
        guard let conectedRoom = connectedRoomType else { return }
        print("emit laeve room data key: \(conectedRoom) ")
        socket?.emit(Constant.LeaveRoom, conectedRoom, completion: {
            print("Socket emit data success")
        })
        
        self.socket?.on(Constant.SocketStatus, callback: { (data, ack) in
            print("Socket status \(data)")
            
        })
    }
}

class SocketUtitils {
    class func construtRoomKey(requestID:String,serviceType:ActiveStatus) -> String {
        let saltKey = APPConstant.salt_key.fromBase64() ?? ""
        return "room_\(saltKey)_R\(requestID)_\(serviceType.rawValue)"
    }
}
