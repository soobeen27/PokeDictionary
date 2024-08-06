//
//  DetailViewController.swift
//  PokeDictionary
//
//  Created by Soo Jang on 8/6/24.
//

import UIKit
import SnapKit
import RxSwift

class DetailViewController: UIViewController {
    var detailViewModel = DetailViewModel()
    private let disposeBag = DisposeBag()
    
    lazy var pokeStackView: UIStackView = {
        let stv = UIStackView(arrangedSubviews: [numNameLabel, typeLabel, heightLabel, weightLabel])
        stv.axis = .vertical
        stv.distribution = .fillEqually
        stv.spacing = 8
        return stv
    }()
    
    lazy var pokeView: UIView = {
        let v = UIView()
        [pokeImageView, pokeStackView]
            .forEach {
                v.addSubview($0)
            }
        v.backgroundColor = .darkRed
        return v
    }()
    
    let pokeImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
//        iv.backgroundColor = .white
        return iv
    }()
    
    let numNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    let typeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    let heightLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    let weightLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        setData()
    }

    private func setLayout() {
        view.backgroundColor = .mainRed
        
        [pokeView]
            .forEach {
                view.addSubview($0)
            }
        
        pokeView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(100)
            $0.leading.trailing.equalToSuperview().inset(40)
            $0.height.equalTo(500)
        }
        pokeView.layer.cornerRadius = 20
        pokeImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(40)
            $0.size.equalTo(CGSize(width: 240, height: 240))
        }
        pokeStackView.snp.makeConstraints {
            $0.top.equalTo(pokeImageView.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-40)
        }
    }
    
    private func setData() {
        detailViewModel.pokeDetail
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] detail in
                guard let self,
                      let num = detail.id,
                      let name = detail.name,
                      let type = detail.types?.first?.type?.name,
                      let height = detail.height,
                      let weight = detail.weight,
                      let koreanType = PokemonTypeName(rawValue: type)?.displayName
                else { return }
                
                self.numNameLabel.text = "No.\(num) \(PokemonTranslator.getKoreanName(for: name))"
                self.typeLabel.text = "타입: \(koreanType)"
                self.heightLabel.text = "키: \(String(format: "%.1f", Float(height) * 0.1)) m"
                self.weightLabel.text = "몸무게: \(String(format: "%.1f", Float(weight) * 0.1)) kg"
        })
        .disposed(by: disposeBag)
        detailViewModel.pokeImage
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] image in
                guard let self else { return }
                self.pokeImageView.image = image
            })
            .disposed(by: disposeBag)
    }
}
