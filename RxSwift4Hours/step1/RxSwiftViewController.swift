//
//  RxSwiftViewController.swift
//  RxSwiftIn4Hours
//
//  Created by iamchiwon on 21/12/2018.
//  Copyright © 2018 n.code. All rights reserved.
//

import RxSwift
import UIKit

class RxSwiftViewController: UIViewController {
    // MARK: - Field

    var counter: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            self.counter += 1
            self.countLabel.text = "\(self.counter)"
        }
    }

    // MARK: - IBOutlet

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var countLabel: UILabel!

    // MARK: - IBAction

    var disposeBag: DisposeBag = DisposeBag() //새로운걸 만들었다.
    
    @IBAction func onLoadImage(_ sender: Any) {
        imageView.image = nil

        rxswiftLoadImage(from: LARGER_IMAGE_URL)
            .observe(on: MainScheduler.instance)
            .subscribe({ result in // subscribe 는 disposable 을 반환한다.
                switch result {
                case let .next(image):
                    self.imageView.image = image

                case let .error(err):
                    print(err.localizedDescription)

                case .completed:
                    break
                }
            })
            .disposed(by: disposeBag) // 리턴되는걸 disposedBag 에 넣어준다.
    }

    @IBAction func onCancel(_ sender: Any) {
        // TODO: cancel image loading
        disposeBag = DisposeBag() // 취소시킬 때 새롭게 할당해주면 초기화 시킬 수 있다.
    }

    // MARK: - RxSwift

    func rxswiftLoadImage(from imageUrl: String) -> Observable<UIImage?> {
        return Observable.create { seal in
            asyncLoadImage(from: imageUrl) { image in
                seal.onNext(image)
                seal.onCompleted()
            }
            return Disposables.create()
        }
    }
}
