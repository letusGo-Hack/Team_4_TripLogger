//
//  ViewController.swift
//  TripLogger
//
//  Created by 현기엽 on 6/29/24.
//

import UIKit

import SnapKit

class ViewController: UIViewController {

    // snapkit test
    private let myView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let presentArticleButton = {
        let button = UIButton()
        button.configuration = .plain()
        button.setTitle("presentArticle", for: .normal)
        return button
    }()
    
    private func configureUI() {
        view.backgroundColor = .yellow
        view.addSubview(myView)
        myView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(300)
        }
        
        presentArticleButton.addAction(
            .init { [weak self] _ in
                let viewController = ArticleViewController()
                self?.presentPanModal(viewController)
            }, 
            for: .touchUpInside
        )
        view.addSubview(presentArticleButton)
        presentArticleButton.snp.makeConstraints {
            $0.bottom.trailing.equalToSuperview().inset(12)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureUI()
    }
}

