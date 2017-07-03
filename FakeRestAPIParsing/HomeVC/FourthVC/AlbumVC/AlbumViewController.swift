//
//  AlbumViewController.swift
//  FakeRestAPIParsing
//
//  Created by Ascra on 29/06/17.
//  Copyright © 2017 Ascracom.ascratech. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Alamofire

class AlbumViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate {

	let tabbarController : UITabBarController! = nil
	
	var activityIndicatorView : NVActivityIndicatorView! = nil
	var parsedDict = [[String: Any]]()
	
	@IBOutlet weak var tableView: UITableView!
	
	//MARK: - ViewDidLoad
    override func viewDidLoad() {
			super.viewDidLoad()

			// Select the initial row
			tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: UITableViewScrollPosition.none)
			tableView.delegate = self
			tableView.dataSource = self
			tableView.tableFooterView = UIView()
		
			self.navigationController?.interactivePopGestureRecognizer?.delegate = self
			self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
			// Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override func viewDidAppear(_ animated: Bool) {
		
		if Constant.isConnectedToInternet() {
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
	func startAnimationView() {
		let frame = CGRect(x: self.view.frame.size.width/2, y: self.view.frame.size.height/2, width: 30, height: 30)
		
		self.activityIndicatorView = NVActivityIndicatorView(frame: frame, type: NVActivityIndicatorType(rawValue: NVActivityIndicatorType.ballClipRotateMultiple.rawValue), color: UIColor.orange)
		
		self.view.addSubview(activityIndicatorView)
		activityIndicatorView.startAnimating()
	}
	
	func stopAnimationView() {
		DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
			self.activityIndicatorView.stopAnimating()
		}
	}
	
	//MARK: - Alomofire
	func callAlmofireWebService()
	{
		self.startAnimationView()
		Alamofire.request(Constant.webURL+"albums", headers:nil).responseJSON { response in
			//  debugPrint(response)
//			print("response:\(response)")
			
			switch response.result
			{
			case .success:
//				print("response :: \(response.result)")
				do {
					let json = try JSONSerialization.jsonObject(with: response.data! as Data, options: .allowFragments)
				//				print("josn: \(json)")
				
					self.parsedDict = json as! [[String : Any]]
					
					self.tabbarController?.tabBar.items?[4].badgeValue = (NSString(format: "%@", self.parsedDict.count) as String)

					DispatchQueue.main.async {
						self.tableView.reloadData()
						self.stopAnimationView()
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
		return parsedDict.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! AlbumTableViewCell
		let idNumber : NSNumber = (self.parsedDict[indexPath.row]["id"] as? NSNumber)!
		
		cell.idCount.text = (NSString(format: "%@", idNumber) as String)
		cell.titleLabel.text = (self.parsedDict[indexPath.row]["title"] as? String)?.localizedCapitalized

		return cell
		
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//		let viewController = self.storyboard?.instantiateViewController(withIdentifier: "AlbumDetailsViewController") as! AlbumDetailsViewController
		let viewController = self.storyboard?.instantiateViewController(withIdentifier: "AlbumDetailsCollectionVC") as! AlbumDetailsCollectionVC
		viewController.albumId = (self.parsedDict[indexPath.row]["id"] as! NSNumber)
		self.navigationController?.pushViewController(viewController, animated: true)
		tableView.deselectRow(at: indexPath, animated: false)
		
	}

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
	{
		return UITableViewAutomaticDimension
	}
	
	func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
	{
		return 44.0
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
