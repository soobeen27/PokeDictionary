//
//  DetailViewModel.swift
//  PokeDictionary
//
//  Created by Soo Jang on 8/6/24.
//

import Foundation
import RxSwift

class DetailViewModel {
    var pokeDetail = PublishSubject<PokeDetail>()
    var pokeResult = PublishSubject<PokeResult>()
    
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
                  let url = URL(string: urlString) else { return }
            
            NetworkManager.shared.fetch(url: url).subscribe(onSuccess: { (detail: PokeDetail) in
                print(detail)
                self.pokeDetail.onNext(detail)
            }).disposed(by: self.disposeBag)
        })
        .disposed(by: disposeBag)
    }
}
