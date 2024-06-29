//
//  ArticleViewController.swift
//  TripLogger
//
//  Created by 현기엽 on 6/29/24.
//

import UIKit

import PanModal

final class ArticleViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
}

extension ArticleViewController: PanModalPresentable {
    var panScrollable: UIScrollView? { nil }
    
    var shortFormHeight: PanModalHeight {
        return .contentHeight(300)
    }

    var longFormHeight: PanModalHeight {
        return .maxHeightWithTopInset(40)
    }
}
