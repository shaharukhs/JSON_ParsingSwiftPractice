//
//  AlbumDetailsCollectionVC.swift
//  FakeRestAPIParsing
//
//  Created by Ascra on 30/06/17.
//  Copyright © 2017 Ascracom.ascratech. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Alamofire
import Kingfisher
import SKPhotoBrowser

class AlbumDetailsCollectionVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

	@IBOutlet weak var collectionView: UICollectionView!
	
	var activityIndicatorView : NVActivityIndicatorView! = nil
	var parsedDict = [[String: Any]]()
	
	var albumId : NSNumber = 0.0
	
	//MARK: - viewDidLoad
	override func viewDidLoad() {
		super.viewDidLoad()
		
		collectionView.dataSource = self
		collectionView.delegate = self
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
	
	//MARK: - Alomofire web call
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
						self.collectionView.reloadData()
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
	
	// MARK: - UICollectionViewDataSource protocol
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.parsedDict.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath) as! AlbumDetailsCollectionViewCell
		
		cell.albumTitleLabel.text = (self.parsedDict[indexPath.row]["title"] as? String)?.capitalized
		let url = URL(string: self.parsedDict[indexPath.row]["thumbnailUrl"] as! String)
		cell.albumImageView.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "placeholderImage"), options: nil, progressBlock: nil, completionHandler: nil)
		
		return cell
	}
	
	// MARK: - UICollectionViewDelegate protocol
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
		let screenSize: CGRect = UIScreen.main.bounds
		let screenWidth = screenSize.width
		return CGSize(width: (screenWidth/3) - 1, height: (screenWidth/3) - 1);
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
