//
//  CRWIntentSendMessageHandler.swift
//  CommunicationToSiri
//
//  Created by crw on 2016/10/9.
//  Copyright © 2016年 crw. All rights reserved.
//

import Intents

class CRWIntentSendMessageHandler : NSObject , INSendMessageIntentHandling{
    
    let contacts = ["陈经理","陈小哥","胖子","胖子2号"]
    
    func resolveRecipients(forSendMessage intent: INSendMessageIntent, with completion: @escaping ([INPersonResolutionResult]) -> Void) {
        
        if let recipients = intent.recipients {
            
            // If no recipients were provided we'll need to prompt for a value.
            if recipients.count == 0 {
                completion([INPersonResolutionResult.needsValue()])
                return
            }
            
            var resolutionResults = [INPersonResolutionResult]()
            for recipient in recipients {
                
                var matchingContacts : [INPerson] = []
                
                contacts.forEach({ (contact) in
                    if contact.hasPrefix(recipient.displayName) {
                        
                        let handle = INPersonHandle.init(value: contact + "test", type:.unknown)
                        
                        matchingContacts.append(INPerson.init(personHandle: handle, nameComponents:nil, displayName: contact, image: nil, contactIdentifier: nil, customIdentifier: nil))
                    }
                })
                
                switch matchingContacts.count {
                case 2  ... Int.max:
                    // We need Siri's help to ask user to pick one from the matches.
                    resolutionResults += [INPersonResolutionResult.disambiguation(with: matchingContacts)]
                    
                case 1:
                    // We have exactly one matching contact
                    resolutionResults += [INPersonResolutionResult.success(with: recipient)]
                    
                case 0:
                    // We have no contacts matching the description provided
                    resolutionResults += [INPersonResolutionResult.unsupported()]
                    
                default:
                    break
                    
                }
            }
            completion(resolutionResults)
        }
        
    }
    
    func resolveContent(forSendMessage intent: INSendMessageIntent, with completion: @escaping (INStringResolutionResult) -> Void) {
        if let text = intent.content, !text.isEmpty {
            completion(INStringResolutionResult.success(with: text))
        } else {
            completion(INStringResolutionResult.needsValue())
        }
    }
    
    func confirm(sendMessage intent: INSendMessageIntent, completion: @escaping (INSendMessageIntentResponse) -> Void) {
        
        if hasLogin() {
            completion(INSendMessageIntentResponse(code: .success, userActivity: nil))
        }else{
            
            // Creating our own user activity to include error information.
            let userActivity = NSUserActivity(activityType: String(describing: INSendMessageIntent.self))
            userActivity.userInfo = [NSString(string: "error"):NSString(string: "UserLoggedOut")]
            
            completion(INSendMessageIntentResponse(code: .failureRequiringAppLaunch, userActivity: userActivity))
        }
    }
    
    func handle(sendMessage intent: INSendMessageIntent, completion: @escaping (INSendMessageIntentResponse) -> Void) {
       
        if intent.recipients != nil && intent.content != nil {
            // Send the message.
            let success = sendMessage(content: intent.content!,contacts: intent.recipients!)
            completion(INSendMessageIntentResponse(code: success ? .success : .failure, userActivity: nil))
        }
        else {
            completion(INSendMessageIntentResponse(code: .failure, userActivity: nil))
        }
    }
    
    func hasLogin() -> Bool {
        return true
    }
    
    func sendMessage(content:String,contacts:[INPerson]) -> Bool {
        contacts.forEach { (person) in
            print("send \(content) to \(person.displayName),success!")
        }
        return true
    }
}
