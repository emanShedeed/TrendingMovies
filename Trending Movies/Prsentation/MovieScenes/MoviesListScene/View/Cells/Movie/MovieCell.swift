//
//  MovieCell.swift
//  Trending Movies
//
//  Created by Eman Shedeed on 08/02/2024.
//

import UIKit



import UIKit
import RxSwift

// MARK: - MovieCell

class MovieCell: UICollectionViewCell {
    // UI elements
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 2
        label.textColor = .white
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()

    // Dispose bag for managing disposables
    private var disposeBag = DisposeBag()

    // ViewModel associated with the cell
    var viewModel: MovieCellViewModel? {
        didSet {
            bindViewModel()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        // Add UI elements to the contentView
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        contentView.backgroundColor = .blackPrimary
        
        // Set up constraints
        // imageView
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 150) // Adjust height as needed
        ])
        
        // titleLabel
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])
        
        // dateLabel
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    private func bindViewModel() {
        guard let viewModel = viewModel else { return }

        // Bind ViewModel properties to UI elements
        viewModel.title
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.releaseDate
            .bind(to: dateLabel.rx.text)
            .disposed(by: disposeBag)

        // Load image asynchronously
        viewModel.image
            .subscribe(onNext: { [weak self] imageData in
                guard let data = imageData else { return }
                DispatchQueue.main.async {
                    self?.imageView.image = UIImage(data: data)
                }
            })
            .disposed(by: disposeBag)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        imageView.image = nil
    }
}
