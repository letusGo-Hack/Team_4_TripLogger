//
//  ArticleViewController.swift
//  TripLogger
//
//  Created by 현기엽 on 6/29/24.
//

import UIKit

import PanModal
import SnapKit

final class ArticleViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureUI()
    }
    
    private func configureUI() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension ArticleViewController: PanModalPresentable {
    var panScrollable: UIScrollView? { scrollView }
    
    var shortFormHeight: PanModalHeight {
        return .contentHeight(300)
    }

    var longFormHeight: PanModalHeight {
        return .maxHeightWithTopInset(40)
    }
}
