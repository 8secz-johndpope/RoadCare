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
}

