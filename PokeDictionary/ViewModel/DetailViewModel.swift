//
//  DetailViewModel.swift
//  PokeDictionary
//
//  Created by Soo Jang on 8/6/24.
//

import Foundation
import RxSwift

class DetailViewModel {
    var pokeDetails: PublishSubject<PokeDetail>?
    
    private let disposeBag = DisposeBag()
    
    func fetchPokeDetail() {
//        pokeUrls.subscribe(onNext: { pokeUrls in
//            let details = pokeUrls.map { pokeUrl -> Single<PokeDetail> in
//                guard let url = URL(string: pokeUrl.url!) else {
//                    return .error(NetworkError.invalidUrl)
//                }
//                return NetworkManager.shared.fetch(url: url)
//            }
//            Observable.from(details)
//                .concat()
//                .toArray()
//                .subscribe(onSuccess: { [weak self] details in
//                guard let self = self else { return }
//                self.pokeDetails.onNext(details)
//            })
//            .disposed(by: self.disposeBag)
//        })
//        .disposed(by: disposeBag)
    }
}
