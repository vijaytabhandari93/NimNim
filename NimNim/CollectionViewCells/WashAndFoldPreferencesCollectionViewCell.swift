//
//  WashAndFoldPreferencesCollectionViewCell.swift
//  NimNim
//
//  Created by Raghav Vij on 04/10/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit

class WashAndFoldPreferencesCollectionViewCell: UICollectionViewCell {

    //IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightImageView: UIImageView!
    @IBOutlet weak var rightLabel: UILabel!
    
    //Variables
    var preferences:[PreferenceModel]? //made a global variable
    
    //IBActions
    @IBAction func leftButtonTapped(_ sender: Any) {
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
    @IBAction func rightButtonTapped(_ sender: Any) {
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
                leftImageView.downloadImage(withUrl: leftPreference.icon) { (image, error) in
                    let newImage = image?.withRenderingMode(.alwaysTemplate)
                    self.leftImageView.image = newImage
                    self.leftImageView.tintColor = selectedTintColor
                }
                leftLabel.textColor = Colors.nimnimGreen
            }else {
                leftImageView.downloadImage(withUrl: leftPreference.icon) { (image, error) in
                    let newImage = image?.withRenderingMode(.alwaysTemplate)
                    self.leftImageView.image = newImage
                    self.leftImageView.tintColor = unselectedTintColor
                }
                leftLabel.textColor = Colors.nimnimGrey
            }
            
            //Setting up right preference
            if let isSelected = rightPreference.isSelected, isSelected == true {
                rightImageView.downloadImage(withUrl: rightPreference.icon) { (image, error) in
                    let newImage = image?.withRenderingMode(.alwaysTemplate)
                    self.rightImageView.image = newImage
                    self.rightImageView.tintColor = selectedTintColor
                }
                rightLabel.textColor = Colors.nimnimGreen
            }else {
                rightImageView.downloadImage(withUrl: rightPreference.icon) { (image, error) in
                    let newImage = image?.withRenderingMode(.alwaysTemplate)
                    self.rightImageView.image = newImage
                    self.rightImageView.tintColor = unselectedTintColor
                }
                rightLabel.textColor = Colors.nimnimGrey
            }
        }
    }
}
