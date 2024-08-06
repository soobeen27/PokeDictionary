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
    var isLoading = false
    var limit = 20

    private let disposeBag = DisposeBag()
    
    init() {
        fetchPokeList(limit: limit)
        fetchPokeImages()
    }

    func fetchPokeList(limit: Int) {
        isLoading = true
        guard let url = URL(string: PokeAPI.listUrlString(limit: String(limit), offset: String(limit - 20))) else { return }
        NetworkManager.shared.fetch(url: url).subscribe(onSuccess: {
            [weak self] (pokeResponse: PokeList) in
            guard let self else { return }
            var currentResults = try! self.pokeUrls.value()
            currentResults.append(contentsOf: pokeResponse.results)
            
            self.pokeUrls.onNext(currentResults)
            self.isLoading = false
        }, onFailure: { [weak self] error in
            guard let self else { return }
            self.isLoading = false
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
    // collectionview selected 됐을때 데이터 전달
    func getPokeDetailUrl(index: Int) -> Observable<PokeResult>{
        return pokeUrls.compactMap { array in
            array.indices.contains(index) ? array[index] : nil
        }
    }
}

