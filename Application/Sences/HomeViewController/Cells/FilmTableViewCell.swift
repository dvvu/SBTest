//
//  FilmTableViewCell.swift
//  Application
//
//  Created by Vu Doan on 12/23/19.
//  Copyright © 2019 Vu Doan. All rights reserved.
//

import UIKit
import SDWebImage

class FilmTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var filmImageView: UIImageView!
    @IBOutlet weak var popularityLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupData(_ item: MovieItem) {
        titleLabel.text = item.title
        popularityLabel.text = "\(item.popularity ?? 0) "
        filmImageView.sd_setImage(with: URL(string: Constant.rootImage + (item.posterPath ?? "")), placeholderImage: UIImage(named: "ic_placeholder"))
    }
    
}
