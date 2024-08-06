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
    let pokeDetails = BehaviorSubject(value: [PokeDetail]())
    let pokeImages = BehaviorSubject(value: [UIImage]())

    private let disposeBag = DisposeBag()
    
    init() {
        fetchPokeList()
        fetchPokeDetail()
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
        }).disposed(by: disposeBag)
    }

    func fetchPokeDetail() {
        pokeUrls.subscribe(onNext: { pokeUrls in
            let details = pokeUrls.map { pokeUrl -> Single<PokeDetail> in
                guard let url = URL(string: pokeUrl.url!) else {
                    return .error(NetworkError.invalidUrl)
                }
                return NetworkManager.shared.fetch(url: url)
            }
            Observable.from(details).concat().toArray().subscribe(onSuccess: { [weak self] details in
                guard let self = self else { return }
                self.pokeDetails.onNext(details)
            }).disposed(by: self.disposeBag)
        }).disposed(by: disposeBag)
    }
    
    func fetchPokeImages() {
        pokeDetails.subscribe(onNext: { details in
            let images = details.map { [weak self] detail -> Single<UIImage> in
                guard let url = URL(string: detail.sprites?.other?.officialArtwork?.urlString ?? ""), let self = self else { return .error(NetworkError.invalidUrl) }
                return fetchImage(url)
            }
            Observable.from(images).concat().toArray().subscribe(onSuccess: {[weak self] images in
                guard let self = self else { return }
                self.pokeImages.onNext(images)
            }).disposed(by: self.disposeBag)
        }).disposed(by: disposeBag)
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

