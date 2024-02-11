//
//  GenreCell.swift
//  Trending Movies
//
//  Created by Eman Shedeed on 08/02/2024.
//

import UIKit
import RxSwift

class GenreCell: UICollectionViewCell {
    var genreNameLabel: UILabel!
    private var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        // Apply corner radius and border to contentView
        contentView.layer.cornerRadius = contentView.frame.height / 2
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.yellow.cgColor
        
        genreNameLabel = UILabel(frame: contentView.bounds)
        genreNameLabel.textAlignment = .center
        genreNameLabel.textColor = .white
        contentView.addSubview(genreNameLabel)
        
        // Set constraints for genreNameLabel
        genreNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            genreNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            genreNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            genreNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            genreNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func bind(viewModel: GenreCellViewModel) {
        viewModel.genreName
            .bind(to: genreNameLabel.rx.text)
            .disposed(by: disposeBag)
    }
    // Function to decorate the selected cell
    func decorate() {
        contentView.backgroundColor = .yellow
        genreNameLabel.textColor = .black
    }
    
    // Function to reset the UI of the genre cell
    func resetUI() {
        contentView.backgroundColor = .black
        genreNameLabel.textColor = .white
    }
}
