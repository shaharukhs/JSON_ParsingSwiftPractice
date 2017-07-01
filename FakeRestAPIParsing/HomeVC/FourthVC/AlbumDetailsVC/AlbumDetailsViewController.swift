//
//  AlbumDetailsViewController.swift
//  FakeRestAPIParsing
//
//  Created by Ascra on 29/06/17.
//  Copyright © 2017 Ascracom.ascratech. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Alamofire
import Kingfisher
import SKPhotoBrowser

class AlbumDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {


	@IBOutlet weak var tableView: UITableView!
	var activityIndicatorView : NVActivityIndicatorView! = nil
	var parsedDict = [[String: Any]]()
	
	var albumId : NSNumber = 0.0
	
	//MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
			// Select the initial row
			tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: UITableViewScrollPosition.none)
			tableView.delegate = self
			tableView.dataSource = self
			tableView.tableFooterView = UIView()
			
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
		
		let UserIdString = (NSString(format: "%@", albumId) as String)
		let UrlString = Constant.webURL+"albums/"+UserIdString+"/photos"
		
		Alamofire.request(UrlString, headers:nil).responseJSON { response in
			//  debugPrint(response)
			//			print("response:\(response)")
			
			switch response.result
			{
			case .success:
				//				print("response :: \(response.result)")
				do {
					let json = try JSONSerialization.jsonObject(with: response.data! as Data, options: .allowFragments)
//									print("josn: \(json)")
					
					self.parsedDict = json as! [[String : Any]]
					
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
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! AlbumDetailsTableViewCell
		
		cell.titleLabel.text = self.parsedDict[indexPath.row]["title"] as? String
		
		let url = URL(string: self.parsedDict[indexPath.row]["url"] as! String)
		cell.albumImageView.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "placeholderImage"), options: nil, progressBlock: nil, completionHandler: nil)
		
		return cell
		
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		// 1. create URL Array
		var images = [SKPhoto]()
		let photo = SKPhoto.photoWithImageURL(self.parsedDict[indexPath.row]["url"] as! String)
		photo.shouldCachePhotoURLImage = true // you can use image cache by true(NSCache)
		images.append(photo)
		
		// 2. create PhotoBrowser Instance, and present.
		let browser = SKPhotoBrowser(photos: images)
		browser.initializePageIndex(0)
		present(browser, animated: true, completion: {})
	}

	//MARK: - Back button
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
