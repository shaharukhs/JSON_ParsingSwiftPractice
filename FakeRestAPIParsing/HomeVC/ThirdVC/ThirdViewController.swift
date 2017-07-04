//
//  ThirdViewController.swift
//  FakeRestAPIParsing
//
//  Created by Ascra on 28/06/17.
//  Copyright © 2017 Ascracom.ascratech. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Alamofire

class ThirdViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate,UISearchControllerDelegate, UISearchResultsUpdating {

		var activityIndicatorView : NVActivityIndicatorView! = nil
		@IBOutlet weak var tableView: UITableView!
	
		var parsedDict = [[String: Any]]()
	  var filteredDict = [[String: Any]]()
	
	let searchController = UISearchController(searchResultsController: nil)
	
	// MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

			// Select the initial row
			tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: UITableViewScrollPosition.none)
			tableView.delegate = self
			tableView.dataSource = self
			tableView.tableFooterView = UIView()
			self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)

			self.navigationController?.interactivePopGestureRecognizer?.delegate = self
			self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
			
			searchController.searchResultsUpdater = self as? UISearchResultsUpdating
			searchController.dimsBackgroundDuringPresentation = false
			searchController.delegate = self
			definesPresentationContext = true
			tableView.tableHeaderView = searchController.searchBar
			
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override func viewDidAppear(_ animated: Bool) {
		
		if Constant.isConnectedToInternet() {
			//			getUserProfileWebCall()
			callAlmofireWebService()
		} else {
			let alert = UIAlertController(title: "Alert", message: "No active internet connection", preferredStyle: UIAlertControllerStyle.alert)
			alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
			self.present(alert, animated: true, completion: nil)
		}
	}
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}

	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
		return true
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
	
	// MARK: -  web service call for all users
	func getUserProfileWebCall(){
	
		self.startAnimationIndicatorView()
		let urlString: String = Constant.webURL+"users"
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
					print("error trying to convert data to JSON 1")
					return
				}  // for NSDictionary declare as [[String: Any]]
				
				self.parsedDict = parsedData
				//					print(parsedData)
				
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
	
	
	//MARK: - Alomofire
	func callAlmofireWebService()
	{
		self.startAnimationIndicatorView()
		Alamofire.request(Constant.webURL+"users", headers:nil).responseJSON { response in
			//  debugPrint(response)
			print("response:\(response)")
			
			switch response.result
			{
			case .success: print("response :: \(response.result)")
			do {
				let json = try JSONSerialization.jsonObject(with: response.data! as Data, options: .allowFragments)
//				print("josn: \(json)")
				
				self.parsedDict = json as! [[String : Any]]
				
				DispatchQueue.main.async {
					self.tableView.reloadData()
					self.stopAnimationIndicatorView()
				}
				
			} catch {
				print("error in JSONSerialization")
			}
				break
			case .failure: break
			}
		}
		
	}
	
	//MARK: - TableView Delegates and DataSource

	func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int {
		if searchController.isActive {
			return filteredDict.count
  }
			return parsedDict.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{

		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! ThirdTableViewCell
		
		let userNameString :String
		let userEmailString :String
		
		if searchController.isActive {
			userNameString = "Name : " + (self.filteredDict[indexPath.row]["name"] as? String)!
			userEmailString = "Email : " + (self.filteredDict[indexPath.row]["email"] as? String)!
		} else {
			userNameString = "Name : " + (self.parsedDict[indexPath.row]["name"] as? String)!
			userEmailString = "Email : " + (self.parsedDict[indexPath.row]["email"] as? String)!
		}
		

		cell.nameLabel.text = userNameString
		cell.emailLabel.text = userEmailString

		return cell
		
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let viewController = self.storyboard?.instantiateViewController(withIdentifier: "UserProfileDetailsVC") as! UserProfileDetailsVC
		if searchController.isActive {
			searchController.isActive = false
			viewController.parsedDict = self.filteredDict[indexPath.row] as [String : Any]
		} else {
			viewController.parsedDict = self.parsedDict[indexPath.row] as [String : Any]
		}
		
		self.navigationController?.pushViewController(viewController, animated: true)
		tableView.deselectRow(at: indexPath, animated: false)
		
	}
	
	func filterContentForSearchText(searchText: String, scope: String = "All") {
		if searchController.searchBar.text == "" {
			filteredDict = self.parsedDict
		} else {
			filteredDict = parsedDict.filter( { $0.description.contains(searchText)})
		}
		
		tableView.reloadData()
	}
	
	func updateSearchResults(for searchController: UISearchController) {
		filterContentForSearchText(searchText: searchController.searchBar.text!)
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
