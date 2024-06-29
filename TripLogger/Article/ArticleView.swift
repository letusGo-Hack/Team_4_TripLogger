//
//  ArticleView.swift
//  TripLogger
//
//  Created by 현기엽 on 6/29/24.
//

import UIKit

final class ArticleView: UIView {
    
    struct ViewModel {
        let weather: ArticleWeatherView.ViewModel?
        let image: UIImage?
        let content: String?
    }
    
    let scrollView = UIScrollView()
    private let contentView = UIView()
    private let weatherView = ArticleWeatherView()
    private let imageView = UIImageView()
    private let textField = UITextField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(viewModel: ViewModel) {
        weatherView.isHidden = viewModel.weather == nil
        if let weather = viewModel.weather {
            weatherView.configure(viewModel: weather)
        }
        
        imageView.image = viewModel.image
        textField.text = viewModel.content
    }
    
    private func configureUI() {
        addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        scrollView.addSubview(contentView)
        
        contentView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.centerX.top.bottom.equalToSuperview()
        }
        
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(300)
        }
        contentView.addSubview(weatherView)
        weatherView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(8.0)
        }
        contentView.addSubview(textField)
        textField.contentVerticalAlignment = .top
        textField.snp.makeConstraints {
            $0.height.equalTo(500)
            $0.top.equalTo(imageView.snp.bottom).offset(12.0)
            $0.horizontalEdges.equalToSuperview().inset(12.0)
            $0.bottom.equalToSuperview()
        }
    }
}
