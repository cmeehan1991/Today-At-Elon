//
//  HeadlineFeed.swift
//  E-Net
//
//  Created by Connor Meehan on 1/7/19.
//  Copyright © 2019 CBM Web Development. All rights reserved.
//

import Foundation

protocol GetArticlesFeedProtocol: class{
    func getArticlesFeed(articleId: Array<String>, imageUrls: Array<String>, headlines: Array<String>, hasMore: Bool)
}

class GetArticles: NSObject{
    weak var delegate: GetArticlesFeedProtocol!
    
    func getArticles(section: String, page: Int){
        let requestUrl = URL(string: "https://webdev.elon.edu/u/e-net-no-wantads/wp-json/e-net/v1/posts/section=" + section + "&page=" + String(page))
        var request = URLRequest(url: requestUrl!)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request){
            data, response, error in
            if error != nil{
                return
            }
            self.parseJson(data: data!)
        }
        task.resume()
    }
    
    func parseJson(data: Data){
        do{
            let jsonResults = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSArray
            
            if jsonResults == nil{
                return
            }
            
            var id: Array<String> = Array()
            var imageUrl: Array<String> = Array()
            var headline: Array<String> = Array()
            var hasMore: Bool = false
            
            if let results = jsonResults{
                for i in 0..<(results.count){
                    let result = results[i] as! NSDictionary
                    
                    id.append(result["post_id"] as! String)
                    imageUrl.append(result["featured_image"] as! String)
                    headline.append(result["headline"] as! String)
                    hasMore = result["has_more"] as! Bool
                }
                DispatchQueue.main.async{
                    print(self.delegate)
                    if self.delegate != nil{
                        self.delegate.getArticlesFeed(articleId: id, imageUrls: imageUrl, headlines: headline, hasMore: hasMore)
                    }
                }
            }
        }catch{
            print("Error: " + error.localizedDescription)
        }
    }
}
