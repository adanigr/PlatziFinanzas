//
//  CellTableViewCell.swift
//  PlatziFinanzas
//
//  Created by Adan Reséndiz on 2/19/19.
//  Copyright © 2019 Adan Reséndiz. All rights reserved.
//

import UIKit

class CellTableViewCell: UITableViewCell {

    @IBOutlet weak var LabelName: UILabel!
    @IBOutlet weak var LabelDescription: UILabel!
    @IBOutlet weak var LabelValue: UILabel!
    @IBOutlet weak var LabelDate: UILabel!
    @IBOutlet weak var LabelTime: UILabel!
    
    //var cellViewModel: CellViewModel// = CellViewModel?() {
//        didSet{
//            setupView()
//        }
//    }
    
//    class GmCar {
//        var driver: GmDriver {
//            didSet {
//                driver.car = self
//            }
//        }
//        init() {
//            driver = GmDriver()
//        }
//    }
    
    //class GmCar {
        var cellViewModel: CellViewModel! {
            didSet {
                setupView()
                //cellViewModel = self
            }
        }
//        init() {
//            cellViewModel = CellViewModel()
//        }
    //}
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //setupView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupView(){
        LabelName.text = cellViewModel.name
        LabelDescription.text = cellViewModel.description
        LabelValue.text = cellViewModel.value
        LabelDate.text = cellViewModel.date
        LabelTime.text = cellViewModel.time
    }
}
