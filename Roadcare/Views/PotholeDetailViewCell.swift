//
//  PotholeDetailViewCell.swift
//  Roadcare
//
//  Created by macbook on 4/10/19.
//  Copyright © 2019 macbook. All rights reserved.
//

import UIKit

class PotholeDetailViewCell: UITableViewCell {
    static let ID = "PotholeDetailViewCell"
    
    @IBOutlet weak var tfAddress: UITextField!
    @IBOutlet weak var tfDate: UITextField!
    @IBOutlet weak var tfNumber: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleButton: UIButton!
    @IBOutlet weak var detailsButton: SimpleButton!
    @IBOutlet weak var reportButton: SimpleButton!
    @IBOutlet weak var constraintContentHeight: NSLayoutConstraint!
    @IBOutlet weak var bodyView: UIView!
    @IBOutlet weak var ivRepairedStatus: UIImageView!
    @IBOutlet weak var lblRepairedStatus: UILabel!
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    public func setupView(details: PotholeDetails) {
        let street = details.metaBox?.street_name ?? ""
        let city = details.metaBox?.city ?? ""
        self.titleLabel.text = street + ", " + city
        self.tfAddress.text = street + ", " + city
        self.tfDate.text = details.date ?? ""
        var num = details.metaBox!.reported_number ?? ""
        if num == "" { num = "1" }
        self.tfNumber.text = num
        
        let status = details.metaBox?.repaired_status ?? ""
        if status.lowercased() == REPAIRED.lowercased() {
            self.lblRepairedStatus.text = REPAIRED
            self.ivRepairedStatus.image = UIImage(named: "ic_plus")
        } else {
            self.lblRepairedStatus.text = NOT_REPAIRED
            self.ivRepairedStatus.image = UIImage(named: "ic_minus")
        }
    }
}

