//
//  SecondViewController.swift
//  FakeRestAPIParsing
//
//  Created by Ascra on 28/06/17.
//  Copyright © 2017 Ascracom.ascratech. All rights reserved.
//

import UIKit
import Kingfisher
import NVActivityIndicatorView
import SKPhotoBrowser

class SecondViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

	@IBOutlet weak var tableView: UITableView!

	var userProfile = [[String : Any]]()
	
	var activityIndicatorView : NVActivityIndicatorView! = nil
	var parsedDict = [String: Any]()
	var parsedDataArray = [[String : Any]]()
	
	// MARK: - ViewDidLoad
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Select the initial row
		tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: UITableViewScrollPosition.none)
		tableView.delegate = self
		tableView.dataSource = self
		tableView.tableFooterView = UIView()
		
		if Constant.isConnectedToInternet() {
			getUsersWebCall(pagenumber: "1")
		}
		// Do any additional setup after loading the view, typically from a nib.
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	override func viewDidAppear(_ animated: Bool) {
		
		if !Constant.isConnectedToInternet() {
			let alert = UIAlertController(title: "Alert", message: "No active internet connection", preferredStyle: UIAlertControllerStyle.alert)
			alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
			self.present(alert, animated: true, completion: nil)
		}
	}
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
	
	// MARK: -  web service call for all users
	func getUsersWebCall( pagenumber : String){
		let pagenumber = pagenumber
		
		self.startAnimationIndicatorView()
		let urlString: String = Constant.getUsersURL+pagenumber
		
		guard let url = URL(string: urlString) else {
			print("Error: cannot create URL")
			return
		}
		
		let urlRequest = URLRequest(url: url)
		
		let session = URLSession.shared
		
		let task = session.dataTask(with: urlRequest) {
			(data, response, error) in
			// check for any errors
			guard error == nil else {
    print("error calling GET on /post")
				
    print(error!)
    return
			}
			// make sure we got data
			guard let responseData = data else {
    print("Error: did not receive data")
    return
			}
			// parse the result as JSON, since that's what the API provides
			do {
				
				guard let parsedData = try? JSONSerialization.jsonObject(with: responseData) as! [String: Any] else {
					print("error trying to convert data to JSON 1")
					return
				}  // for NSDictionary declare as [[String: Any]]
				
				self.parsedDict = parsedData
				

				self.parsedDataArray = parsedData["data"] as! [[String : Any]]
				
				for parse in self.parsedDataArray {
					self.userProfile.append(parse)
				}

//				print(self.userProfile)
				
				DispatchQueue.main.async {
					self.tableView.reloadData()
					self.stopAnimationIndicatorView()
				}
				
			} catch  {
						print("error trying to convert data to JSON 2")
						return
			}
		}
		task.resume()
	}
	

	// MARK: - Activity Indicator
	
	func startAnimationIndicatorView() {
		let frame = CGRect(x: self.view.frame.size.width/2, y: self.view.frame.size.height/2, width: 30, height: 30)
		
		self.activityIndicatorView = NVActivityIndicatorView(frame: frame, type: NVActivityIndicatorType(rawValue: NVActivityIndicatorType.ballClipRotateMultiple.rawValue), color: UIColor.orange)
		
		self.view.addSubview(activityIndicatorView)
		activityIndicatorView.startAnimating()
	}
	
	func stopAnimationIndicatorView() {
		DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
			self.activityIndicatorView.stopAnimating()
		}
	}
	
	// MARK: - TableView Delegates and DataSource
	
	func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int {
		return userProfile.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SecondTableViewCell
		
		
		let userFirstNameString = self.userProfile[indexPath.row]["first_name"] as? String
		
		let userLastNameString = self.userProfile[indexPath.row]["last_name"] as? String

		cell.firstNameLabel.text = userFirstNameString
		cell.LastNameLabel.text = userLastNameString
		
		let url = URL(string: self.userProfile[indexPath.row]["avatar"] as! String)
		cell.userImageView.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "profileImage"), options: nil, progressBlock: nil, completionHandler: nil)
		
		return cell
		
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
	{
		return UITableViewAutomaticDimension
	}
	
	func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
	{
		return 44.0
	}
	
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		let lastElement = userProfile.count - 1
		
		let currentPage = (self.parsedDict["page"] as! NSString).intValue
		let totalPages : NSNumber = self.parsedDict["total_pages"] as! NSNumber 
		let pageCount = NSNumber(value:currentPage+1)
		
		if totalPages.int32Value != currentPage {
			if indexPath.row == lastElement {
				// handle your logic here to get more items, add it to dataSource and reload tableview
				if Constant.isConnectedToInternet() {
						DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
							self.stopAnimationIndicatorView()
							self.getUsersWebCall(pagenumber: (NSString(format: "%@", pageCount) as String))
						}
				} else {
					let alert = UIAlertController(title: "Alert", message: "No active internet connection", preferredStyle: UIAlertControllerStyle.alert)
					alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
					self.present(alert, animated: true, completion: nil)
				}
				
			}
		} else {
			self.stopAnimationIndicatorView()
		}
		
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		// 1. create URL Array
		var images = [SKPhoto]()
		let photo = SKPhoto.photoWithImageURL(self.userProfile[indexPath.row]["avatar"] as! String)
		photo.shouldCachePhotoURLImage = true // you can use image cache by true(NSCache)
		images.append(photo)
		
		// 2. create PhotoBrowser Instance, and present.
		let browser = SKPhotoBrowser(photos: images)
		browser.initializePageIndex(0)
		present(browser, animated: true, completion: {})
	}

}

