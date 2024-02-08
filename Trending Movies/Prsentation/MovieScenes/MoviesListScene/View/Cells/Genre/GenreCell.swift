//
//  GenreCell.swift
//  Trending Movies
//
//  Created by Mohamed on 08/02/2024.
//


import UIKit
import RxSwift
import RxCocoa

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
        genreNameLabel = UILabel(frame: contentView.bounds)
        genreNameLabel.textAlignment = .center
        contentView.addSubview(genreNameLabel)
    }

    func bind(viewModel: GenreCellViewModel) {
        viewModel.genreName
            .bind(to: genreNameLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
