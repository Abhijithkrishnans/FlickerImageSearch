//
//  ImageCollectionViewCell.swift
//  SAPFLICKER
//
//  Created by Abhijithkrishnan on 22/01/22.
//

import UIKit
import SDWebImage

class ImageCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var imgCellImage: UIImageView!
    
    func configureCellWith(_ image:SFImageEssentialDataModelProtocol) {
        imgCellImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
        imgCellImage.sd_setImage(with: URL(string: buildUrlString(image)), placeholderImage: UIImage(named: "placeholder"))
    }
    
    func buildUrlString(_ imageData:SFImageEssentialDataModelProtocol) -> String {
        return   "https://\(SFConstants.fieldNames.farm)\(imageData.farm ?? 0).\(SFConstants.networking.singleImagebaseURL)/\(imageData.server ?? "")/\(imageData.id ?? "")_\(imageData.secret ?? "")\(SFConstants.fieldNames.JPG)"
    }
}
