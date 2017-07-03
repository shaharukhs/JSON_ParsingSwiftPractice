//
//  UserProfileDetailsVC.swift
//  FakeRestAPIParsing
//
//  Created by Ascra on 28/06/17.
//  Copyright © 2017 Ascracom.ascratech. All rights reserved.
//

import UIKit
import GoogleMaps
import SwiftyJSON

class UserProfileDetailsVC: UIViewController {

	var parsedDict = [String: Any]()
	
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var emailLabel: UILabel!
//	@IBOutlet weak var phoneLabel: UILabel!
//	@IBOutlet weak var webSiteLabel: UILabel!
	
	@IBOutlet weak var streetLabel: UILabel!
	@IBOutlet weak var suiteLabel: UILabel!
	@IBOutlet weak var cityLabel: UILabel!
	@IBOutlet weak var zipcodeLabel: UILabel!
	
	@IBOutlet weak var phoneTextView: UITextView!
	@IBOutlet weak var webTextView: UITextView!

	
//	@IBOutlet weak var companyLabel: UILabel!
	
	@IBOutlet weak var backButton: UIButton!
	@IBOutlet weak var mapView: GMSMapView!
	
		//MARK: - ViewDidLoad
    override func viewDidLoad() {
			super.viewDidLoad()

			updateUserDetails()
			loadMapView()
			
        // Do any additional setup after loading the view.
    }

	func updateUserDetails() {
		nameLabel.text = parsedDict["name"] as? String
		
		var emailString = "📨 : "
		emailString += (parsedDict["email"] as? String)!
		emailLabel.text = emailString
		
		var phoneString = "📞 : "
		phoneString += (parsedDict["phone"] as? String)!
		phoneTextView.text = phoneString
		
		var webString = "🌎 : "
		webString += (parsedDict["website"] as? String)!
		webTextView.text = webString
		
		let address = parsedDict["address"] as? [String : Any]
		streetLabel.text = address?["street"] as? String
		suiteLabel.text = address?["suite"] as? String
		cityLabel.text = address?["city"] as? String
		zipcodeLabel.text = address?["zipcode"] as? String
		
//		let company = parsedDict["company"] as? [String:Any]
//		companyLabel.text = company?["name"] as? String
	}
	
	
	func loadMapView() {
		
		let address = parsedDict["address"] as? [String : Any]
		let geoLocation = address?["geo"] as? [String : Any]
		
		let latitude = (geoLocation!["lat"] as! NSString).doubleValue
		let longitude = (geoLocation!["lng"] as! NSString).doubleValue
		
		let camera = GMSCameraPosition.camera(withLatitude:latitude , longitude: longitude, zoom: 3.0)
		mapView.camera = camera
		mapView.animate(to: camera)
		// Creates a marker in the center of the map.
		let marker = GMSMarker()
		marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//		marker.title = "Sydney"
//		marker.snippet = "Australia"
		marker.map = mapView
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
	
	//MARK: - Back Button Click
	@IBAction func backButtonClick(_ sender: Any) {
		if let nav = self.navigationController {
			nav.popViewController(animated: true)
		} else {
			self.dismiss(animated: true, completion: nil)
		}
	}
	
		//MARK: - View Post Button Click
	@IBAction func viewPostFromUser(_ sender: Any) {
		let viewController = self.storyboard?.instantiateViewController(withIdentifier: "UserPostViewController") as! UserPostViewController
		viewController.userId = parsedDict["id"] as! NSNumber
		//		self.tabBarController?.hidesBottomBarWhenPushed = false
		self.navigationController?.pushViewController(viewController, animated: true)
	}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
