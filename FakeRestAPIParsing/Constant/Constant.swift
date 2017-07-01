//
//  Constant.swift
//  FakeRestAPIParsing
//
//  Created by Ascra on 28/06/17.
//  Copyright © 2017 Ascracom.ascratech. All rights reserved.
//

import UIKit
import Alamofire

class Constant: NSObject {

	static let webURL = "https://jsonplaceholder.typicode.com/"
	
	static let getUsersURL  = "https://reqres.in/api/users?page="
	
//	static let googleMapAPI = "AIzaSyCpmAtjH0U3GHi0uSPvFHfv0_2i4DDdqME"
	static let googleMapAPI = "AIzaSyDJzsI1ZEnzvCQ3K2DDGf5mrkqBIYKhc4k"
	
	
	class func isConnectedToInternet() ->Bool {
		return NetworkReachabilityManager()!.isReachable
	}
	
	/*
	func startNetworkReachabilityObserver() {
		let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "www.google.com")
		reachabilityManager?.listener = { status in
			
			switch status {
				
			case .NotReachable:
				print("The network is not reachable")
				
			case .Unknown :
				print("It is unknown whether the network is reachable")
				
			case .Reachable(.EthernetOrWiFi):
				print("The network is reachable over the WiFi connection")
				
			case .Reachable(.WWAN):
				print("The network is reachable over the WWAN connection")
				
			}
		}
		
		// start listening
		reachabilityManager?.startListening()
	}
  */
	
}






/*
struct Constant1 {
	static let webURL = "https://jsonplaceholder.typicode.com/"
}
 */


