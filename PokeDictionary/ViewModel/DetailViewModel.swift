//
//  DetailViewModel.swift
//  PokeDictionary
//
//  Created by Soo Jang on 8/6/24.
//

import UIKit
import RxSwift
import RxCocoa

class DetailViewModel {
    var pokeDetail = PublishSubject<PokeDetail>()
    var pokeResult = PublishSubject<PokeResult>()
    var pokeImage = PublishSubject<UIImage>()
    
    private let disposeBag = DisposeBag()
    
    init() {
        fetchPokeDetail()
    }
    
    func getPokeResult(data: Observable<PokeResult>) {
        data.bind(to: pokeResult)
            .disposed(by: disposeBag)
    }
    
    func fetchPokeDetail() {
        pokeResult.subscribe(onNext: { [weak self] result in
            guard let self,
                  let urlString = result.url,
                  let detailUrl = URL(string: urlString) else { return }
            
            NetworkManager.shared.fetch(url: detailUrl).subscribe(onSuccess: { (detail: PokeDetail) in
                print(detail)
                self.pokeDetail.onNext(detail)
                guard let id = detail.id,
                      let imageUrl = PokeAPI.imageUrl(id: "\(id)")
                else { return }
                self.fetchImage(imageUrl).subscribe(onSuccess: { image in
                    self.pokeImage.onNext(image)
                }).disposed(by: self.disposeBag)
            }).disposed(by: self.disposeBag)
        })
        .disposed(by: disposeBag)
    }
    
    func fetchImage(_ url: URL) -> Single<UIImage> {
        return Single.create { observer in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    observer(.success(image))
                } else {
                    observer(.failure(NetworkError.dataFetchFail))
                }
            } else {
                observer(.failure(NetworkError.invalidUrl))
            }
            return Disposables.create()
        }
    }
}
