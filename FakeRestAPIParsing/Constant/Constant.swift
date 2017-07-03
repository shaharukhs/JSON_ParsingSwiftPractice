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

extension UIColor {
	convenience init(hexCode: String) {
		let hex = hexCode.trimmingCharacters(in: NSCharacterSet.alphanumerics.inverted)
		var int = UInt32()
		Scanner(string: hex).scanHexInt32(&int)
		let a, r, g, b: UInt32
		switch hex.characters.count {
		case 3:
			(a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
		case 6:
			(a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
		case 8:
			(a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
		default:
			(a, r, g, b) = (1, 1, 1, 0)
		}
		self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
	}
}




/*
struct Constant1 {
	static let webURL = "https://jsonplaceholder.typicode.com/"
}
 */


