//
//  ViewController.swift
//  PokeDictionary
//
//  Created by Soo Jang on 8/5/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class MainViewController: UIViewController {
    var mainViewModel = MainViewModel()
    let disposeBag = DisposeBag()
    
    lazy var pokeBallImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = .pokemonBall
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    lazy var pokeCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        let collectionCellWidth = (view.frame.width) / 3
        flowLayout.itemSize = CGSize(width: collectionCellWidth, height: collectionCellWidth)
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0

        let collect = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collect.register(PokeCollectionViewCell.self, 
                         forCellWithReuseIdentifier: CellIdentifier.pokeCollectionViewCell)
        collect.backgroundColor = .darkRed
        return collect
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        setCollectionView()
        collectionViewCellSelected()
    }

    func setCollectionView() {
        mainViewModel.pokeImages
            .observe(on: MainScheduler.instance)
            .bind(to: pokeCollectionView.rx.items(
                cellIdentifier: CellIdentifier.pokeCollectionViewCell,
                cellType: PokeCollectionViewCell.self)) { (row, element, cell) in
                cell.setImgae(pokeImage: element)
            }
            .disposed(by: disposeBag)
    }
    
    func collectionViewCellSelected() {
        pokeCollectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self else { return }
                let detailVC = DetailViewController()
                detailVC.detailViewModel.getPokeResult(data: self.mainViewModel.getPokeDetailUrl(index: indexPath.row))
                self.navigationController?.pushViewController(detailVC, animated: true)
            })
            .disposed(by: disposeBag)
    }

    private func setLayout() {
        view.backgroundColor = .mainRed
        
        [pokeBallImageView, pokeCollectionView]
            .forEach {
                view.addSubview($0)
            }
        pokeBallImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(64)
            $0.size.equalTo(CGSize(width: 64, height: 64))
        }
        pokeCollectionView.snp.makeConstraints {
            $0.top.equalTo(pokeBallImageView.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }

}

