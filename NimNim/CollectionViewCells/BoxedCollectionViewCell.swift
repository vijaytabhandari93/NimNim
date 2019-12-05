//
//  BoxedCollectionViewCell.swift
//  NimNim
//
//  Created by Raghav Vij on 15/10/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit

class BoxedCollectionViewCell: UICollectionViewCell {

    //Variables
    var preferences:[PreferenceModel]? //made a global variable
    @IBAction func rightButtonPressed(_ sender: Any) {
        if let preferences = preferences, preferences.count > 1 {
            //Setting the model
            let leftPreference = preferences[0]
            leftPreference.isSelected = false
            let rightPreference = preferences[1]
            rightPreference.isSelected = true
            
            //Setup the ui
            setupUI()
        }
    }
    @IBAction func leftButtonpressed(_ sender: Any) {
        if let preferences = preferences, preferences.count > 1 {
            //Setting up the model
            let leftPreference = preferences[0]
            leftPreference.isSelected = true
            let rightPreference = preferences[1]
            rightPreference.isSelected = false
            
            //Setup the ui
            setupUI()
        }
    }
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subLabel: UILabel!
    @IBOutlet weak var leftImage: UIImageView!
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightImage: UIImageView!
    @IBOutlet weak var rightLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func configureCell(withPreferenceModelArray model:[PreferenceModel]?) {
        if let model = model {
            preferences = model
        }
        setupUI()
    }
    
    func setupUI() {
        if let preferences = preferences, preferences.count > 1 {
            let leftPreference = preferences[0]
            let rightPreference = preferences[1]
            let selectedTintColor = Colors.nimnimGreen
            let unselectedTintColor = Colors.nimnimGrey
            //Setting up left preference
            if let isSelected = leftPreference.isSelected, isSelected == true {
                leftImage.downloadImage(withUrl: leftPreference.icon) { (image, error) in
                    let newImage = image?.withRenderingMode(.alwaysTemplate)
                    self.leftImage.image = newImage
                    self.leftImage.tintColor = selectedTintColor
                }
                leftLabel.textColor = Colors.nimnimGreen
            }else {
                leftImage.downloadImage(withUrl: leftPreference.icon) { (image, error) in
                    let newImage = image?.withRenderingMode(.alwaysTemplate)
                    self.leftImage.image = newImage
                    self.leftImage.tintColor = unselectedTintColor
                }
                leftLabel.textColor = Colors.nimnimGrey
            }
            
            //Setting up right preference
            if let isSelected = rightPreference.isSelected, isSelected == true {
                rightImage.downloadImage(withUrl: rightPreference.icon) { (image, error) in
                    let newImage = image?.withRenderingMode(.alwaysTemplate)
                    self.rightImage.image = newImage
                    self.rightImage.tintColor = selectedTintColor
                }
                rightLabel.textColor = Colors.nimnimGreen
            }else {
                rightImage.downloadImage(withUrl: rightPreference.icon) { (image, error) in
                    let newImage = image?.withRenderingMode(.alwaysTemplate)
                    self.rightImage.image = newImage
                    self.rightImage.tintColor = unselectedTintColor
                }
                rightLabel.textColor = Colors.nimnimGrey
            }
        }
    }

}
