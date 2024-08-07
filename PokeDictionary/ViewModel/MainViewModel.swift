//
//  MainViewModel.swift
//  PokeDictionary
//
//  Created by Soo Jang on 8/5/24.
//

import UIKit
import RxSwift
import RxCocoa

class MainViewModel {
    let pokeImages = BehaviorRelay(value: [UIImage]())
    var isLoading = false
    var offset = 1

    private let disposeBag = DisposeBag()
    
    init() {
        fetchPokeImages()
    }

    func fetchPokeImages() {
        guard !isLoading else { return }
        isLoading = true
        
        let startId = offset
        let endId = offset + 19
        let imageSingles = (startId...endId)
            .compactMap { [weak self] id -> Single<UIImage>? in
            guard let self = self, let url = PokeAPI.imageUrl(id: "\(id)") else {
                return nil
            }
            return self.fetchImage(url)
        }

        Single.zip(imageSingles)
            .subscribe(onSuccess: { [weak self] newImages in
                guard let self = self else { return }
                var currentImages = self.pokeImages.value
                currentImages.append(contentsOf: newImages)
                self.pokeImages.accept(currentImages)
                self.offset += 20
                self.isLoading = false
            }, onFailure: { [weak self] _ in
                self?.isLoading = false
            })
            .disposed(by: disposeBag)
    }
    
    func fetchImage(_ url: URL) -> Single<UIImage> {
        return Single.create { observer in
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    observer(.failure(error))
                } else if let data = data, let image = UIImage(data: data) {
                    observer(.success(image))
                } else {
                    observer(.failure(NetworkError.dataFetchFail))
                }
            }
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
    }

    func getPokeID(index: Int) -> Observable<Int>{
        return Observable.just(index)
    }
}

