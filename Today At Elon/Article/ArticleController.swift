//
//  Article Controller.swift
//  E-Net
//
//  Created by Connor Meehan on 1/7/19.
//  Copyright © 2019 CBM Web Development. All rights reserved.
//

import UIKit
import SDWebImage

class ArticleController: UIViewController, GetArticleProtocol{
    @IBOutlet weak var scrollView : UIScrollView!
    @IBOutlet weak var activityIndicator : UIActivityIndicatorView!
    @IBOutlet weak var featuredImageView : UIImageView!
    @IBOutlet weak var articleTitle : UILabel!
    @IBOutlet weak var byLine : UILabel!
    @IBOutlet weak var publishDate : UILabel!
    @IBOutlet weak var excerpt : UITextView!
    @IBOutlet weak var content : UITextView!
    @IBOutlet weak var contentView: UIView!
    
    var articleId = String()
    var permalink = String()
    func articleData(featuredImage: String, title: String, byLine: String, publishDate: String, excerpt: String, content: String, permalink: String) {
    
        if featuredImage != ""{ // Check if the image exists before trying to fetch it
            
            let url = URL(string: featuredImage)
            featuredImageView?.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder.png"))
        }
        
        // Set the rest of the article content
        self.articleTitle.text = title
        self.byLine.text = byLine
        self.publishDate.text = publishDate
        self.excerpt.text = excerpt
        self.content.text = content
        
        self.permalink = permalink
        
        self.articleTitle.sizeToFit()
        self.excerpt.sizeToFit()
        self.content.sizeToFit()
        
        self.contentView.sizeToFit()
        
        self.contentView.frame.size.height = self.featuredImageView.frame.size.height + self.articleTitle.frame.size.height + self.excerpt.frame.size.height + self.content.frame.size.height + 100
        
        
        self.scrollView.contentSize = CGSize(width: self.contentView.frame.size.width, height: self.contentView.frame.size.height)//self.contentView.frame.size
        
        
        // Stop the activity indicator. 
        activityIndicator.stopAnimating()
        scrollView.isHidden = false
    }
    
    @objc func shareArticle(){
        let shareText = title
        let website = URL(string: self.permalink)
        let itemsToShare = [website, shareText] as [Any]
        let activityViewController = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
        
        present(activityViewController, animated: true, completion: nil)
    }

    override func loadView(){
        super.loadView()
        scrollView.isHidden = true
        activityIndicator.startAnimating()
        
        let articleModel = GetArticleModel()
        articleModel.delegate = self
        articleModel.getArticle(articleId: articleId)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .action, target: self, action: #selector(shareArticle))
        self.navigationItem.rightBarButtonItem = rightBarButtonItem

        print(self.contentView.frame.size.height)
        
    }
}
