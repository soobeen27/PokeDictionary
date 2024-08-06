//
//  MainViewModel.swift
//  PokeDictionary
//
//  Created by Soo Jang on 8/5/24.
//

import UIKit
import RxSwift

class MainViewModel {
    let pokeUrls = BehaviorSubject(value: [PokeResult]())
    let pokeImages = BehaviorSubject(value: [UIImage]())

    private let disposeBag = DisposeBag()
    
    init() {
        fetchPokeList()
        fetchPokeImages()
    }

    func fetchPokeList() {
        let limit = 20
        let offset = 0
        guard let url = URL(string: PokeAPI.listUrlString(limit: String(limit), offset: String(offset))) else { return }
        NetworkManager.shared.fetch(url: url).subscribe(onSuccess: {
            [weak self] (pokeResponse: PokeList) in
            guard let self = self else { return }
            self.pokeUrls.onNext(pokeResponse.results)
        })
        .disposed(by: disposeBag)
    }
    
    func fetchPokeImages() {
        pokeUrls.subscribe(onNext: { urls in
            let images = urls.map { [weak self] url -> Single<UIImage> in
                guard let self,
                      let pokeUrl = url.url,
                      let pokeID = pokeUrl.getPokeID,
                      let imageUrl = PokeAPI.imageUrl(id: pokeID)
                else {
                    return .error(NetworkError.invalidUrl)
                }
                return self.fetchImage(imageUrl)
            }
            Observable.from(images)
                .concat()
                .toArray()
                .subscribe(onSuccess: {[weak self] images in
                guard let self else { return }
                self.pokeImages.onNext(images)
            })
            .disposed(by: self.disposeBag)
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

