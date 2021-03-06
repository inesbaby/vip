//
//  ProductInformationController.swift
//  vip
//
//  Created by Ines on 2020/3/16.
//  Copyright © 2020 Ines. All rights reserved.
//

import UIKit
import Firebase

class ProductInformationController: UIViewController {
    var ref: DatabaseReference!

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var evaluationLabel: UILabel!
    @IBOutlet weak var sellerEvaluationLabel: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    var index  = Int()
    override func viewDidLoad() {
        super.viewDidLoad()
        print("index",index)
        setLabel(index: index)
        let myColor : UIColor = UIColor( red: 137/255, green: 137/255, blue:128/255, alpha: 1.0 )
        productImage.layer.cornerRadius = 45
        productImage.layer.borderWidth = 1
        productImage.layer.borderColor = myColor.cgColor
     
    }
    
    
    func setLabel(index:Int){
        Database.database().reference().child("Product")
            .queryOrderedByKey()
            .observeSingleEvent(of: .value, with: { snapshot in 
                if let datas = snapshot.children.allObjects as? [DataSnapshot] {
                    let nameResults = datas.compactMap({
                        ($0.value as! [String: Any])["ProductName"]
                    })
                    let priceResults = datas.compactMap({
                        ($0.value as! [String: Any])["Price"]
                    })
                    let descriptionResults = datas.compactMap({
                        ($0.value as! [String: Any])["Description"]
                    })
                    let productEvaluationResults = datas.compactMap({
                        ($0.value as! [String: Any])["ProductEvaluation"]
                    })
                    let sellerEvaluationResults = datas.compactMap({
                        ($0.value as! [String: Any])["SellerEvaluation"]
                                       })
                    let imageResults = datas.compactMap({
                        ($0.value as! [String: Any])["imageURL"]
                    })
                    
                    self.nameLabel.text = nameResults[index] as? String
                    self.priceLabel.text = (priceResults[index] as! String) + "元"
                    self.descriptionLabel.text = "產品描述 " + (descriptionResults[index] as! String)
                    self.evaluationLabel.text = "產品評價 " + (productEvaluationResults[index] as! String)
                    self.sellerEvaluationLabel.text = "商家評價 " + (sellerEvaluationResults[index] as! String)
                    self.productImage.image = UIImage(named:"logo")
                    let productImageUrl = imageResults[index] 
                    if let imageUrl = URL(string: productImageUrl as! String){
                        URLSession.shared.dataTask(with: imageUrl) { (data, response, error) in
                            if error != nil {
                                print("Download Image Task Fail: \(error!.localizedDescription)")
                            }
                            else if let imageData = data {
                                DispatchQueue.main.async { 
                                    self.productImage.image = UIImage(data: imageData)
                                }
                            }
                            
                        }.resume()
                        
                    }
                }
                
                
            })
    }
    
        
    @IBAction func back(_ sender: Any) {        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    

}
