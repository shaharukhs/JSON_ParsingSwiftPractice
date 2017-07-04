//
//  UserPostViewController.swift
//  FakeRestAPIParsing
//
//  Created by Ascra on 28/06/17.
//  Copyright © 2017 Ascracom.ascratech. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class UserPostViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

	@IBOutlet weak var tableView: UITableView!

	var activityIndicatorView : NVActivityIndicatorView! = nil
	var userId : NSNumber = 0.0
	var parsedDict = [[String: Any]]()
	
    override func viewDidLoad() {
        super.viewDidLoad()

			// Select the initial row
			tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: UITableViewScrollPosition.none)
			tableView.delegate = self
			tableView.dataSource = self
			
			self.edgesForExtendedLayout = UIRectEdge()
			self.extendedLayoutIncludesOpaqueBars = false
			self.automaticallyAdjustsScrollViewInsets = false
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override func viewDidAppear(_ animated: Bool) {
		
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
		let UserIdString = (NSString(format: "%@", userId) as String)
		
		let urlString: String = Constant.webURL+"posts?userId="+UserIdString
		//		todoEndpoint = todoEndpoint+"posts"
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
				
				guard let parsedData = try? JSONSerialization.jsonObject(with: responseData) as! [[String: Any]] else {
					print("error trying to convert data to JSON")
					return
				}  // for NSDictionary declare as [[String: Any]]
				
				self.parsedDict = parsedData
				//					print(parsedData)

				DispatchQueue.main.async {
					self.tableView.reloadData()
					self.stopAnimationIndicatorView()
				}
				
			} catch  {
				print("error trying to convert data to JSON 3")
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
		
		cell.titleLabel?.text = self.parsedDict[indexPath.row]["title"] as? String
		
		cell.bodyLabel?.text =  self.parsedDict[indexPath.row]["body"] as? String
		
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
	
	// MARK: - Back button Click
	@IBAction func backButtonClick(_ sender: Any) {
		if let nav = self.navigationController {
			nav.popViewController(animated: true)
		} else {
			self.dismiss(animated: true, completion: nil)
		}
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
