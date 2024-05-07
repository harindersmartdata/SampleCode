//
//  UIViewcontroller+Ext.swift
//  TNC360
//
//  Created by Shiwani Thakur on 24/05/21.
//

import Foundation
import UIKit
import EventKit
import Photos

extension UIViewController {
    
    func addEventCalendar(title: String, notes: String, startdate: String,enddate: String,urlString: String, eventId: String?,type: String?){
        let eventStore : EKEventStore = EKEventStore()
        
        eventStore.requestAccess(to: .event) { (granted, error) in
            
            if (granted) && (error == nil) {
                print("granted \(granted)")
                print("error \(String(describing: error))")
                
                let event:EKEvent = EKEvent(eventStore: eventStore)
                
                event.title = title
                
                let startDateInDate =  TimeUtils.dateFromString(startdate, with: DateFormats.YYYY_MM_DD_T_HH_MM_SS_SSSZ)
                let endDateInDate =  TimeUtils.dateFromString(startdate, with: DateFormats.YYYY_MM_DD_T_HH_MM_SS_SSSZ)
                event.startDate = startDateInDate
                event.endDate = endDateInDate ?? Date() + 1
                event.notes = notes
                print("typessss",type as Any)
                print("urll","\(urlString ).\(eventId ?? "").\(type ?? "")")
                let urlString = "\(urlString ).\(eventId ?? "").\(type ?? "")"
                event.url = URL(string: urlString)
                
                let alarm = EKAlarm.init(absoluteDate: Date.init(timeInterval: -30, since: (event.startDate)!))
                
                event.addAlarm(alarm)
                event.calendar = eventStore.defaultCalendarForNewEvents
                do {
                    try eventStore.save(event, span: .thisEvent)
                } catch let error as NSError {
                    print("failed to save event with error : \(error)")
                }
                print("Saved Event")
                
                let userData = UserDefaults()
                userData.set(event.eventIdentifier, forKey: "calendarEventID")
                NotificationCenter.default.post(name: Notification.Name("addEventCalendar"), object: nil)
            }
            else {
                print("failed to save event with error : \(String(describing: error)) or access not granted")
            }
        }
    }
    
    func editEvent(title: String, notes: String, startdate: String,enddate: String,eventIdentifier: String,eventID: String?,type: String?){
        //let store = EKEventStore()
        let eventStore = EKEventStore()
        eventStore.requestAccess(to: .event) { granted, error in
            if !granted {
                return
            }
            //            let event = store.event(withIdentifier: eventIdentifier)
            //   let event:EKEvent = EKEvent(eventStore: eventStore)
            let startDateInDate =  TimeUtils.dateFromString(startdate, with: DateFormats.YYYY_MM_DD_T_HH_MM_SS_SSSZ)
            let startDateInDate2 =  Calendar.current.date(byAdding: .day, value: -1, to: startDateInDate!)!
            let endDateInDate = Calendar.current.date(byAdding: .day, value: 1, to: startDateInDate!)!
            
            let predicate = eventStore.predicateForEvents(withStart: startDateInDate2, end: endDateInDate, calendars: nil)
            
            let existingEvents = eventStore.events(matching: predicate)
            print("existingEvents",existingEvents)
            
            
            let getURL = "\(Bundle.main.bundleIdentifier ?? "").\(eventID ?? "").\(type ?? "")"
            let eventAlreadyExists = existingEvents.contains(where: {event in event.url == URL(string: getURL)
                
                let startDateInDate =  TimeUtils.dateFromString(startdate, with: DateFormats.YYYY_MM_DD_T_HH_MM_SS_SSSZ)
                
                let endDateInDate =  TimeUtils.dateFromString(startdate, with: DateFormats.YYYY_MM_DD_T_HH_MM_SS_SSSZ)
                event.title = title
                event.startDate = startDateInDate
                event.endDate = endDateInDate ?? Date() + 1
                event.notes = notes
                let alarm = EKAlarm.init(absoluteDate: Date.init(timeInterval: -30, since: (startDateInDate ?? Date())))
                event.addAlarm(alarm)
                // event.calendar = eventStore.defaultCalendarForNewEvents
                // store.saveEvent(event, span: .thisEvent, error: nil)
                do {
                    try eventStore.save((event) , span: .thisEvent)
                } catch let error as NSError {
                    print("failed to save event with error : \(error)")
                }
                //let userData = UserDefaults()
                return true
            })
            
            if eventAlreadyExists {
                
            } else {
            }
            
            
        }
    }
    
    func removeEvent(eventIdentifier: String,title: String, notes: String, startdate: String,enddate: String,eventID: String?,type: String?){
        let store = EKEventStore()
        store.requestAccess(to: .event) { granted, error in
            if !granted {
                return
            }
            
            let startDateInDate =  TimeUtils.dateFromString(startdate, with: DateFormats.YYYY_MM_DD_T_HH_MM_SS_SSSZ)
            let startDateInDate2 =  Calendar.current.date(byAdding: .day, value: -1, to: startDateInDate!)!
            let endDateInDate = Calendar.current.date(byAdding: .day, value: 1, to: startDateInDate!)!
            
            let predicate = store.predicateForEvents(withStart: startDateInDate2, end: endDateInDate, calendars: nil)
            
            let existingEvents = store.events(matching: predicate)
            print("existingEvents",existingEvents)
            
            let getURL = "\(Bundle.main.bundleIdentifier ?? "").\(eventID ?? "").\(type ?? "")"
            
            let getUTCTimeStart = startDateInDate?.convertToUTC(DateFormats.YYYY_MM_DD_T_HH_MM_SS_SSSZ)
            let startDateInDateUTC =  TimeUtils.dateFromString(getUTCTimeStart, with: DateFormats.YYYY_MM_DD_T_HH_MM_SS_SSSZ)
            //let startDateInDate =  TimeUtils.dateFromString(startdate, with: DateFormats.YYYY_MM_DD_T_HH_MM_SS_SSSZ)
            
            let eventAlreadyExists = existingEvents.contains(where: {event in event.url == URL(string: getURL)
            })
            print("startDateInDateUTC",startDateInDateUTC as Any)
            if(eventAlreadyExists == true){
                let eventToRemove = store.event(withIdentifier: eventIdentifier)
                if let eventToRemove = eventToRemove {
                    var _: Error? = nil
                    do {
                        try store.remove(eventToRemove, span: .thisEvent, commit: true)
                    } catch _ {
                    }
                }
            }
        }
    }
    
    
    
    func eventAlreadyExistOrNot(startDateEvent: String,endDateEvent: String,eventTitle: String, notes: String,eventIdentifier: String, eventID: String?,type: String?){
        
        let eventStore = EKEventStore()
        eventStore.requestAccess(to: .event) { granted, error in
            if !granted {
                return
            }
            let startDateInDate =  TimeUtils.dateFromString(startDateEvent, with: DateFormats.YYYY_MM_DD_T_HH_MM_SS_SSSZ)
            let startDateInDate2 =  Calendar.current.date(byAdding: .day, value: -1, to: startDateInDate!)!
            let endDateInDate = Calendar.current.date(byAdding: .day, value: 1, to: startDateInDate!)!
            
            let predicate = eventStore.predicateForEvents(withStart: startDateInDate2, end: endDateInDate, calendars: nil)
            
            let existingEvents = eventStore.events(matching: predicate)
            print("existingEvents",existingEvents)
            
            
            let getURL = "\(Bundle.main.bundleIdentifier ?? "").\(eventID ?? "").\(type ?? "")"
            let eventAlreadyExists = existingEvents.contains(where: {event in event.url == URL(string: getURL)})
            
            // Matching event found, don't add it again, just display alert
            if eventAlreadyExists {
                print("exist")
                let startDateInDate =  TimeUtils.dateFromString(startDateEvent, with: DateFormats.YYYY_MM_DD_T_HH_MM_SS_SSSZ)
                let calendar = Calendar.current
                let dateInHours = calendar.date(byAdding: .hour, value: 5, to: startDateInDate!)
                let date = dateInHours?.toString(with:DateFormats.YYYY_MM_DD_T_HH_MM_SS_SSSZ)
                self.editEvent(title: eventTitle, notes: notes, startdate: date!, enddate: date!, eventIdentifier: eventIdentifier,eventID: eventID, type: type)
                
            } else {
                print("notexist")
                
                // Event doesn't exist yet, add it to calendar
                do {
                    self.addEventCalendar(title: eventTitle, notes: notes, startdate: startDateEvent, enddate: startDateEvent, urlString:Bundle.main.bundleIdentifier ?? "", eventId: eventID, type: type)
                }
                //          catch {
                //          print("Error occurred")
                //        }
            }
            
            
        }
    }
    
    //  func openNotificationScreens()
    //  {
    //    let userData = UserDefaults()
    //    //userData.setValue("fromPush", forKey: "fromPush")
    //    if let pushCome = userData.value(forKey: "fromPush") as? String
    //    {
    //
    //      switch pushCome
    //      {
    //      case notificationTypes.newMessage:
    //
    //        self.openChatScreenIntial()
    //
    //      case notificationTypes.postCreated:
    //        self.openPostsScreen()
    //
    //      case notificationTypes.postLiked:
    //
    //        self.openPostsScreen()
    //      case notificationTypes.replyOnComment:
    //        self.openPostsScreen()
    //
    //      case notificationTypes.commentOnPost:
    //        self.openPostsScreen()
    //
    //      case notificationTypes.eventAdded:
    //        self.openEventScreen()
    //
    //      case notificationTypes.eventJoined:
    //        self.openEventScreen()
    //
    //      case notificationTypes.eventCancelled:
    //        self.openEventScreen()
    //
    //      case notificationTypes.planCreated:
    //        self.openProgramManagementCustomer()
    //        // self.openEventScreen()
    //
    //      case notificationTypes.planPurchased:
    //        self.openTrainerHomeScreen()
    //
    //      case notificationTypes.planExpire: break
    //
    //
    //      case notificationTypes.planDeactivatedByCustomer:
    //        self.openTrainerHomeScreen()
    //
    //      default:
    //        break;
    //
    //        //openChatScreen()
    //
    //      }
    //      userData.removeObject(forKey: "fromPush")
    //    }
    //
    //    else
    //    {
    //
    //    }
    //    NotificationCenter.default.addObserver(self, selector: #selector(openChatScreen), name: NSNotification.Name(Chat.notificationObserverLists), object: nil)
    //    NotificationCenter.default.addObserver(self, selector: #selector(openPostsScreen), name: NSNotification.Name(Community.notificationObserverPosts), object: nil)
    //    NotificationCenter.default.addObserver(self, selector: #selector(openPostsScreen), name: NSNotification.Name(Community.notificationObserverPostsLiked), object: nil)
    //
    //    NotificationCenter.default.addObserver(self, selector: #selector(openPostsScreen), name: NSNotification.Name(Community.notificationObservercommentOnPost), object: nil)
    //    NotificationCenter.default.addObserver(self, selector: #selector(openEventScreen), name: NSNotification.Name(Community.notificationObservereventAdded), object: nil)
    //    NotificationCenter.default.addObserver(self, selector: #selector(openEventScreen), name: NSNotification.Name(Community.notificationObservereventJoined), object: nil)
    //    NotificationCenter.default.addObserver(self, selector: #selector(openEventScreen), name: NSNotification.Name(Community.notificationObservereventCancelled), object: nil)
    //    NotificationCenter.default.addObserver(self, selector: #selector(openProgramManagementCustomer), name: NSNotification.Name(Community.notificationObserverplanCreated), object: nil)
    //    //  NotificationCenter.default.addObserver(self, selector: #selector(openTrainerHomeScreen), name: NSNotification.Name(Community.notificationObserverplanPurchased), object: nil)
    //    //NotificationCenter.default.addObserver(self, selector: #selector(openPostsScreen), name: NSNotification.Name(Community.notificationObserverplanExpire), object: nil)
    //    //  NotificationCenter.default.addObserver(self, selector: #selector(openTrainerHomeScreen), name: NSNotification.Name(Community.notificationObserverplanDeactivatedByCustomer), object: nil)
    //  }
    //  @objc func openChatScreen()
    //  {
    //    let viewController:UIViewController = UIStoryboard(name: StoryBoards.Chat, bundle: nil).instantiateViewController(withIdentifier: Controller.chatsViewController) as! chatsViewController
    //    self.navigationController?.pushViewController(viewController, animated: false)
    //  }
    //  @objc func openChatScreenIntial()
    //  {
    //    let viewController:UIViewController = UIStoryboard(name: StoryBoards.Chat, bundle: nil).instantiateViewController(withIdentifier: Controller.ChatListViewController) as! ChatListViewController
    //    self.navigationController?.pushViewController(viewController, animated: false)
    //  }
    //  @objc func openPostsScreen()
    //  {
    //    let viewController:CommunitiesViewController = UIStoryboard(name: StoryBoards.Community, bundle: nil).instantiateViewController(withIdentifier: Controller.CommunitiesViewController) as! CommunitiesViewController
    //    viewController.screenFrom = "PostNotification"
    //    self.navigationController?.pushViewController(viewController, animated: false)
    //  }
    //  @objc func openEventScreen()
    //  {
    //    let viewController:TEventsViewController = UIStoryboard(name: StoryBoards.Event, bundle: nil).instantiateViewController(withIdentifier: Controller.TEventsViewController) as! TEventsViewController
    //    viewController.isSideMenu = true
    //    self.navigationController?.pushViewController(viewController, animated: false)
    //  }
    //  @objc func openTrainerHomeScreen()
    //  {
    //    let vc = AppStoryboard.TrainerHome.instance.instantiateViewController(withIdentifier: THomeVC.className) as! THomeVC
    //    self.navigationController?.pushViewController(vc, animated: false)
    //  }
    //  @objc func openProgramManagementCustomer()
    //  {
    //    let vc = AppStoryboard.Home.instance.instantiateViewController(withIdentifier: CProgramMgmntVC.className) as! CProgramMgmntVC
    //    self.navigationController?.pushViewController(vc, animated: false)
    //  }
    //
    
    func goToSettings(messgae: String)
    {
        let configAlert: AlertUI = ("", messgae)
        UIAlertController.showAlert(configAlert, sender: self, actions: AlertAction.setting, AlertAction.cancel) { (onClick) in
            if(onClick == AlertAction.setting)
            {
                UIApplication.goToSettings()
            }
            else
            {
                self.dismiss(animated: false, completion: nil)
            }
        }
    }
    
    func checkCameraPermissions()
    {
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            print("authorized")
            break // The user has previously granted access to the camera.
            //self.setupCaptureSession()
            
        case .notDetermined: // The user has not yet been asked for camera access.
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    
                    print("granted")
                    //self.setupCaptureSession()
                }
            }
            break
            
        case .denied:
            print("denied")
            
            let configAlert: AlertUI = ("", AlertMessage.cameraPermission)
            UIAlertController.showAlert(configAlert, sender: self, actions: AlertAction.setting, AlertAction.cancel) { (onClick) in
                if(onClick == AlertAction.setting)
                {
                    UIApplication.goToSettings()
                }
                else
                {
                    self.dismiss(animated: false, completion: nil)
                }
            }
            
            
            // The user has previously denied access.
            return
            
        case .restricted: // The user can't grant access due to restrictions.
            print("restricted")
            return
            
        default:
            return
        }
    }
    
    
    
    func checkPhotosPermissions()
    {
        let status = PHPhotoLibrary.authorizationStatus()
        
        if (status == PHAuthorizationStatus.authorized) {
            // Access has been granted.
        }
        
        else if (status == PHAuthorizationStatus.denied) {
            // Access has been denied.
            let configAlert: AlertUI = ("", AlertMessage.photosPermission)
            UIAlertController.showAlert(configAlert, sender: self, actions: AlertAction.setting, AlertAction.cancel) { (onClick) in
                if(onClick == AlertAction.setting)
                {
                    UIApplication.goToSettings()          }
                else
                {
                    self.dismiss(animated: false, completion: nil)
                }
            }
        }
        
        else if (status == PHAuthorizationStatus.notDetermined) {
            
            // Access has not been determined.
            PHPhotoLibrary.requestAuthorization({ (newStatus) in
                
                if (newStatus == PHAuthorizationStatus.authorized) {
                    
                }
                
                else {
                    
                }
            })
        }
        
        else if (status == PHAuthorizationStatus.restricted) {
            // Restricted access - normally won't happen.
        }
    }
    
    //  func openRunDetails()
    //  {
    //    NotificationCenter.default.addObserver(self, selector: #selector(openRunDetailsTap), name: NSNotification.Name(runDetailsNotify.openRunDetailFromLink), object: nil)
    //
    //  }
    
    //  @objc func openRunDetailsTap()
    //  {
    //    let storyboard = AppStoryboard.Home.instance
    //    if let vc = storyboard.instantiateViewController(withIdentifier: RunDetailVC.className ) as? RunDetailVC {
    //      vc.runRecordId = runningIds.recordID
    //      //vc.runIdentifierId = self.activeRunObj?.identifier
    //      self.navigationController?.pushViewController(vc, animated: true)
    //    }
    //  }
    //
    
}

