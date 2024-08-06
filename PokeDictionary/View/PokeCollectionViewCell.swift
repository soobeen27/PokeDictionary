//
//  PokeCollectionViewCell.swift
//  PokeDictionary
//
//  Created by Soo Jang on 8/6/24.
//

import UIKit
import SnapKit

class PokeCollectionViewCell: UICollectionViewCell {

    private let pokeImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .cellBackground
        iv.image = .none
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        self.contentView.addSubview(pokeImageView)
        self.backgroundColor = .clear
        
        pokeImageView.layer.cornerRadius = 8
        pokeImageView.clipsToBounds = true
        
        pokeImageView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
        }
    }
    func setImgae(pokeImage: UIImage) {
        pokeImageView.image = pokeImage
    }
    
}
