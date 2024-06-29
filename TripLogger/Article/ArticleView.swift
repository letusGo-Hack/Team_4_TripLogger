//
//  ArticleView.swift
//  TripLogger
//
//  Created by 현기엽 on 6/29/24.
//

import UIKit

final class ArticleView: UIView {
    
    let scrollView = UIScrollView()
    private let stackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        addSampleContents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        scrollView.addSubview(stackView)
        stackView.axis = .vertical
        stackView.snp.makeConstraints { make in
            make.centerX.width.verticalEdges.equalToSuperview()
        }
    }
    
    private func addSampleContents() {
        Array(repeating: 0, count: 5)
            .map { _ in
                return UIColor(red: Double.random(in: (0..<1)), green: Double.random(in: (0..<1)), blue: Double.random(in: (0..<1)), alpha: 1.0)
            }
            .map {
                let square = UIView()
                square.snp.makeConstraints { make in
                    make.height.equalTo(200)
                }
                square.backgroundColor = $0
                return square
            }
            .forEach { stackView.addArrangedSubview($0) }
    }
}
