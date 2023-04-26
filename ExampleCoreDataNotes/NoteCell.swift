//
//  NoteCell.swift
//  ExampleCoreDataNotes
//
//  Created by Mohan K on 17/03/23.
//

import UIKit

class NoteCell: UITableViewCell {

    
    @IBOutlet weak var Viewbg: UIView!
    @IBOutlet weak var TextLabelContent: UILabel!
    @IBOutlet weak var Viewpriority: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        configureView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class var identifier : String{ return String(describing : self)
        
    }
    
    class var nib : UINib{ return UINib(nibName: identifier, bundle: nil)}
    
    func configureView() {
        self.backgroundColor = .clear
        self.selectionStyle = .none
        self.Viewbg.backgroundColor = .red
        self.Viewbg.layer.cornerRadius = 8
        TextLabelContent.textColor = .blue
        Viewpriority.layer.cornerRadius = 4
    }
}
