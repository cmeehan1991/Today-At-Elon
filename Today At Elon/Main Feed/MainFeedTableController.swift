//
//  MainFeedTableController.swift
//  Today at Elon
//
//  Created by Connor Meehan on 1/7/19.
//  Copyright © 2019 CBM Web Development. All rights reserved.
//

import UIKit
import SDWebImage

class MainFeedTableController: UIViewController, UITableViewDataSource, UITableViewDelegate, GetArticlesFeedProtocol{
    @IBOutlet weak var feedTable: UITableView!
    @IBOutlet weak var activityIndicator : UIActivityIndicatorView!
    
    var articleId : Array<String> = Array(), imageUrls : Array<String> = Array(), headlines : Array<String> = Array(), page: Int = 1, hasMore: Bool = false, isLoadingResults: Bool = false
    let feedModel = GetArticles()
    
    func getArticlesFeed(articleId: Array<String>, imageUrls: Array<String>, headlines: Array<String>, hasMore: Bool) {
        self.articleId += articleId
        self.imageUrls += imageUrls
        self.headlines += headlines
        self.hasMore = hasMore
        
        feedTable.reloadData()
        feedTable.isHidden = false
        activityIndicator.stopAnimating()
        isLoadingResults = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articleId.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell") as! MainFeedTableViewCellController
        cell.headline?.text = headlines[indexPath.row]
        cell.headline?.sizeToFit()
                
        let imageUrl = self.imageUrls[indexPath.row]
        cell.featuredImage?.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "placeholder.png"))
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.width
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.size.height && isLoadingResults == false && hasMore == true{
            self.page += 1
            
            isLoadingResults = true
            feedModel.getArticles(section: "headlines", page: page)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "ArticleViewController") as? ArticleController
        
        vc?.articleId = articleId[indexPath.row]
        
        self.navigationController?.pushViewController(vc!, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
    
    
    override func loadView(){
        super.loadView()
        
        
        self.feedTable.delegate = self
        self.feedTable.dataSource = self
        

        
        //feedTable.isHidden = true
        activityIndicator.startAnimating()
        
        feedModel.delegate = self
        feedModel.getArticles(section: "headlines", page: page)
        isLoadingResults = true
    }
    
    override func viewDidLoad() {
        super .viewDidLoad()
    }
}
