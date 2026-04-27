//
//  CoinImageDataService.swift
//  CryptoDha
//
//  Created by Rosh on 26/04/26.
//

import Combine
import Foundation
import SwiftUI

class CoinImageDataService {
    
    let coin: Coin
    var cancellable: AnyCancellable?
    @Published var error: Error?
    @Published var image: UIImage?
    
    let localFileManager = LocalFileManager.instance
    let folder = "coin_images"
    init(coin: Coin) {
        self.coin = coin
        self.getCoinImage()
    }
    
    func getCoinImage() {
        if let image = localFileManager.getImage(file: coin.id, folder: folder) {
            self.image = image
            print("Image from localFileManager")
        } else {
            downloadCoinImage()
            print("Image downloaded")

        }
    }
    
    func downloadCoinImage() {
        guard let url = URL(string: coin.image) else { return }
        let urlRequest = URLRequest(url: url)
        cancellable = NetworkManager.download(url: urlRequest).sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                self.error = error
            }
        }, receiveValue: { [weak self] data in
            guard let self = self, let image = UIImage(data: data) else {return}
            self.image = image
            self.localFileManager.saveImage(image: image, file: coin.id, folder: folder)
            self.cancellable?.cancel()
        })
    }
}
