//
//  FirebaseDataProvider.swift
//  BPTGoogleMap
//
//  Created by Basith on 24/04/20.
//  Copyright © 2020 Agaze. All rights reserved.
//

import Foundation 
import Firebase


class FirebaseDatabaseData {
    var Fbref: DatabaseReference!
    
    func writeMessageToFirebase(firstchild: String,
                                secondchild: String,
                                text: String,
                                thirdchild: String,
                                thirdchildname: String,
                                timeStamp: String) {
        Fbref = Database.database().reference()
        let key = Fbref.child("CRFT_MSGS").child(firstchild).child(secondchild).childByAutoId().key
        let post = ["message": text,
                    "send": true,
                    "sender_id": thirdchild,
                    "sender_name":thirdchildname,
                    "timestamp": timeStamp] as [String : Any]
        
        let childUpdates = ["/CRFT_MSGS/\(firstchild)/\(secondchild)/\(key)": post]
        
        Fbref.updateChildValues(childUpdates) {
            (error:Error?, ref:DatabaseReference) in
            if let error = error {
                print("Data could not be saved: \(error).")
            } else {
                print("Data saved successfully!")
                
            }
        }
    }
    
    func writeMessageToFirebase(rootNode: String,
                                firstchild: String,
                                secondchild: String,
                                dataDicToWrite: [String:Any],
                                CallBack: @escaping (Bool)->Void) -> Void {
        Fbref = Database.database().reference()
        var retVal = true
        let key = Fbref.child(rootNode).child(firstchild).child(secondchild).childByAutoId().key
        
        let childUpdates = [ "\(rootNode)/\(firstchild)/\(secondchild)/\(key)": dataDicToWrite]
        
        Fbref.updateChildValues(childUpdates) {
            (error:Error?, ref:DatabaseReference) in
            if let error = error {
                assertionFailure("writeToFirebase failed")
                retVal = false
            }
            
            CallBack(retVal)
        }
    }
    
    // receiver msg check prev checkreceivemsg
    func readMessageFromFB(rootNode: String,  // salondata node
        firstchild: String,//ownerid node
        secondChild: String,//object_id of salon
        CallBack: @escaping ([String : Any])->Void) -> Void {// return collection of key:value
        Fbref = Database.database().reference()
        let fbnodeRef = Fbref.child(rootNode).child(firstchild).child(secondChild)
        let receiver = fbnodeRef.queryOrderedByKey()
        
        var receiverSnapshotDic = Dictionary<String, Any>()
        var tempDic = Dictionary<String, Any>()
        
        receiver.observeSingleEvent(of: .value) { (snapShot) in
            if snapShot.hasChildren(){
                receiverSnapshotDic = ( (snapShot.value as! NSMutableDictionary) as! [String : Any])
                tempDic = receiverSnapshotDic["barber"] as! [String : Any]
            }else{
                receiverSnapshotDic.removeAll()
                tempDic.removeAll()
            }
            CallBack(tempDic)
        }
        
    }
} /* end of class FirebaseDatabaseData */
