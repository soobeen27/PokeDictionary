//
//  DetailViewController.swift
//  PokeDictionary
//
//  Created by Soo Jang on 8/6/24.
//

import UIKit
import SnapKit

class DetailViewController: UIViewController {
    var detailViewModel = DetailViewModel()
    
    lazy var pokeStackView: UIStackView = {
        let stv = UIStackView(arrangedSubviews: [pokeImageView, numNameLabel, typeLabel, heightLabel, weightLabel])
        stv.axis = .vertical
        stv.distribution = .equalSpacing
        stv.backgroundColor = .darkRed
        stv.spacing = 8
        return stv
    }()
    
    let pokeImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    let numNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    let typeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()
    
    let heightLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()
    
    let weightLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
    }

    private func setLayout() {
        view.backgroundColor = .mainRed
        
        
    }
}
