//
//  ShoeTaskAddedCollectionViewCell.swift
//  NimNim
//
//  Created by Raghav Vij on 28/01/20.
//  Copyright © 2020 NimNim. All rights reserved.
//

import UIKit

protocol ShoeTaskAddedCollectionViewCellDelegate:class {
    func editTapped(withIndexPath indexPath : IndexPath?)
    func deleteTapped(withIndexPath indexPath : IndexPath?)
}
class ShoeTaskAddedCollectionViewCell: UICollectionViewCell {
    
    var IndexPath  : IndexPath?
    weak var delegate:ShoeTaskAddedCollectionViewCellDelegate?
    
    @IBOutlet weak var taskNumberLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        delegate?.deleteTapped(withIndexPath : self.IndexPath)
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
        delegate?.editTapped(withIndexPath : self.IndexPath)
    }
    
    
}
