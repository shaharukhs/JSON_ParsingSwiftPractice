//
//  FirstViewController.swift
//  FakeRestAPIParsing
//
//  Created by Ascra on 28/06/17.
//  Copyright © 2017 Ascracom.ascratech. All rights reserved.
//

import UIKit
//import Constant
import NVActivityIndicatorView

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NVActivityIndicatorViewable {

	@IBOutlet weak var tableView: UITableView!
	
	var activityIndicatorView : NVActivityIndicatorView! = nil
	
	var titles = [String]()
	
	var parsedDict = [[String: Any]]()
	
	// MARK: - ViewDidLoad
	override func viewDidLoad() {
		super.viewDidLoad()
		print(Constant.webURL)
		
		
		
		// Select the initial row
		tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: UITableViewScrollPosition.none)
		tableView.delegate = self
		tableView.dataSource = self
		tableView.tableFooterView = UIView()
		
		// Do any additional setup after loading the view, typically from a nib.
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	override func viewDidAppear(_ animated: Bool) {
		
		UIApplication.shared.statusBarView?.backgroundColor = UIColor.init(hexCode: "#006055")
		
		if Constant.isConnectedToInternet() {
			webAPICall()
		} else {
			let alert = UIAlertController(title: "Alert", message: "No active internet connection", preferredStyle: UIAlertControllerStyle.alert)
			alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
			self.present(alert, animated: true, completion: nil)
		}
	}
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
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
	
	// MARK: - Call Web API
	func webAPICall(){

		self.startAnimationIndicatorView()
		let postsUrlString: String = Constant.webURL+"posts"
		guard let url = URL(string: postsUrlString) else {
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

				guard let parsedData = try? JSONSerialization.jsonObject(with: responseData) as! [[String: Any]] else {
									print("error trying to convert data to JSON 1")
									return
				}  // for NSDictionary declare as [[String: Any]]

				self.parsedDict = parsedData
				//					print(parsedData)
				
					for parse in parsedData {
						if let title = parse["title"] as? String {
							self.titles.append(title)
						}
					}
				
//				print(self.titles)
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

	// MARK: - TableView Delegates and DataSource
	
	func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int {
		return parsedDict.count 
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! FirstTableViewCell
		
		cell.titleLabel?.text = (self.parsedDict[indexPath.row]["title"] as? String)?.capitalized
		
		cell.bodyLabel?.text =  (self.parsedDict[indexPath.row]["body"] as? String)?.capitalized
		
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

}

//MARK: - Extension
extension UIApplication {
	var statusBarView: UIView? {
		return value(forKey: "statusBar") as? UIView
	}
}

