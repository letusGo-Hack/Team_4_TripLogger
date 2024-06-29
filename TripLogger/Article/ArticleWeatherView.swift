//
//  ArticleWeatherView.swift
//  TripLogger
//
//  Created by 현기엽 on 6/29/24.
//

import UIKit

final class ArticleWeatherView: UIStackView {
    
    struct ViewModel {
        let image: UIImage
        let temperature: CGFloat
    }
    
    private let imageView = UIImageView()
    private let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        spacing = 4.0
        addArrangedSubview(imageView)
        imageView.tintColor = .white
        addArrangedSubview(label)
        label.textColor = .white
    }
    
    func configure(viewModel: ViewModel) {
        imageView.image = viewModel.image
        label.text = "\(viewModel.temperature)°C"
    }
}
