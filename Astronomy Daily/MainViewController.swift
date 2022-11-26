//
//  ViewController.swift
//  Astronomy Daily
//
//  Created by Nathan Hoellein on 9/24/22.
//

import UIKit

protocol UpdatedDataProtocol {
    func updatedData(dailyData: DailyData)
}

class MainViewController: UIViewController {

    var titleLabel: UILabel
    var dateLabel: UILabel
    var imageView: UIImageView
    var copyrightLabel: UILabel
    var authorLabel: UILabel
    var descriptionLabel: UILabel
    var viewModel: MainViewModel
   
    required init?(coder: NSCoder) {
        self.viewModel = MainViewModel()
        self.titleLabel = UILabel(frame: .zero)
        self.dateLabel = UILabel(frame: .zero)
        self.imageView = UIImageView(frame: .zero)
        self.copyrightLabel = UILabel(frame: .zero)
        self.authorLabel = UILabel(frame: .zero)
        self.descriptionLabel = UILabel(frame: .zero)
        
        super.init(coder: coder)
        self.viewModel.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.text = viewModel.title
        titleLabel.font = UIFont.systemFont(ofSize: 36.0, weight: .bold)
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.textAlignment = .center
        dateLabel.text = viewModel.date
        dateLabel.font = UIFont.systemFont(ofSize: 16.0, weight: .bold)
        dateLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.cropImage(image: viewModel.image, imageView: imageView)
        imageView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        let imageViewTap = UITapGestureRecognizer(target: self, action: #selector(imageViewTap))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(imageViewTap)
        
        copyrightLabel.translatesAutoresizingMaskIntoConstraints = false
        copyrightLabel.textAlignment = .left
        copyrightLabel.font = UIFont.systemFont(ofSize: 16.0, weight: .semibold)
        copyrightLabel.text = viewModel.copyright
        
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        authorLabel.textAlignment = .right
        authorLabel.font = UIFont.systemFont(ofSize: 16.0, weight: .semibold)
        authorLabel.text = viewModel.author
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.numberOfLines = 0
        descriptionLabel.sizeToFit()
        descriptionLabel.font = UIFont.systemFont(ofSize: 18.0, weight: .regular)
        descriptionLabel.text = viewModel.description
        descriptionLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
        
        
        self.setupConstraints(titleLabel: titleLabel,
                              dateLabel: dateLabel,
                              imageView: imageView,
                              copyrightLabel: copyrightLabel,
                              authorLabel: authorLabel,
                              description: descriptionLabel)
        
        let leftSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipegesture(gesture:)))
        leftSwipeGesture.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(leftSwipeGesture)
        let rightSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipegesture(gesture:)))
        rightSwipeGesture.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(rightSwipeGesture)
    }
    
    @objc
    private func swipegesture(gesture: UISwipeGestureRecognizer) {
        switch gesture.direction {
        case .left:
            viewModel.nextImage()
        case .right:
            viewModel.previousImage()
        case .up, .down:
            return
        default:
            return
        }
    }
    
    @objc
    private func imageViewTap() {
        guard let image = viewModel.image else {
            return
        }
        let detailViewController = ImageDetailViewController(image: image)
        let navigationController = UINavigationController(rootViewController: detailViewController)
        self.present(navigationController, animated: true)
    }
    
    private func setupConstraints(titleLabel: UILabel,
                                  dateLabel: UILabel,
                                  imageView: UIImageView,
                                  copyrightLabel: UILabel,
                                  authorLabel: UILabel,
                                  description: UILabel) {
        
        let titleView = UIView(frame: .zero)
        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(titleLabel)
        titleView.addSubview(dateLabel)
        titleView.addConstraints([
            titleLabel.topAnchor.constraint(equalTo: titleView.topAnchor, constant: 10.0),
            titleLabel.leadingAnchor.constraint(equalTo: titleView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: titleView.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: dateLabel.topAnchor, constant: -10.0),
            dateLabel.leadingAnchor.constraint(equalTo: titleView.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: titleView.trailingAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: titleView.bottomAnchor, constant: -10)
        ])
        
        let descriptionView = UIView(frame: .zero)
        descriptionView.translatesAutoresizingMaskIntoConstraints = false
        descriptionView.addSubview(description)
        descriptionView.addConstraints([
            description.topAnchor.constraint(equalTo: descriptionView.topAnchor, constant: 30.0),
            description.leadingAnchor.constraint(equalTo: descriptionView.leadingAnchor),
            description.trailingAnchor.constraint(equalTo: descriptionView.trailingAnchor),
            description.bottomAnchor.constraint(equalTo: descriptionView.bottomAnchor, constant: -10.0),
        ])
        
        imageView.addConstraints([
            imageView.heightAnchor.constraint(equalToConstant: 300),
            imageView.widthAnchor.constraint(greaterThanOrEqualToConstant: 300)
        ])
        
        let copyrightView = UIView(frame: .zero)
        copyrightView.translatesAutoresizingMaskIntoConstraints = false
        copyrightView.addSubview(copyrightLabel)
        copyrightView.addConstraints([
            copyrightLabel.topAnchor.constraint(equalTo: copyrightView.topAnchor),
            copyrightLabel.leadingAnchor.constraint(equalTo: copyrightView.leadingAnchor),
            copyrightLabel.trailingAnchor.constraint(equalTo: copyrightView.trailingAnchor),
            copyrightLabel.bottomAnchor.constraint(equalTo: copyrightView.bottomAnchor)
        ])
        
        let authorView = UIView(frame: .zero)
        authorView.translatesAutoresizingMaskIntoConstraints = false
        authorView.addSubview(authorLabel)
        authorView.addConstraints([
            authorLabel.topAnchor.constraint(equalTo: authorView.topAnchor),
            authorLabel.leadingAnchor.constraint(equalTo: authorView.leadingAnchor),
            authorLabel.trailingAnchor.constraint(equalTo: authorView.trailingAnchor),
            authorLabel.bottomAnchor.constraint(equalTo: authorView.bottomAnchor)
        ])
        
        let byLineView = UIStackView(arrangedSubviews: [copyrightView, authorView])
        byLineView.translatesAutoresizingMaskIntoConstraints = false
        byLineView.axis = .horizontal
        byLineView.distribution = .fill
        byLineView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        let stackView = UIStackView(arrangedSubviews: [titleView,
                                                      imageView,
                                                      byLineView,
                                                      descriptionView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        
        let scrollView = UIScrollView(frame: .zero)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        
        scrollView.addSubview(stackView)
        
        self.view.addSubview(scrollView)
        
        let heightConstraint = stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        heightConstraint.priority = .defaultLow
        self.view.addConstraints([
            scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 17.0),
            scrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 17.0),
            scrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -17.0),
            scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            heightConstraint
        ])
    }
    
    private func cropImage(image: UIImage?, imageView: UIImageView) {
        guard let image = image else {
            return
        }
        let widthRatio = image.size.width / image.size.height
        let heightRatio = image.size.height / image.size.width
        
        let scaleFactor = min(
            widthRatio,
            heightRatio
        )
        
        let scaledImageSize = CGSize(width: image.size.width * scaleFactor,
                                     height: image.size.height * scaleFactor)
            
        let renderer = UIGraphicsImageRenderer(size: scaledImageSize)
        let scaledImage = renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: scaledImageSize))
        }
        imageView.image = image
    }
}

extension MainViewController: UpdatedDataProtocol {
    
    func updatedData(dailyData: DailyData) {
        DispatchQueue.main.async {
            self.titleLabel.text = dailyData.title
            self.dateLabel.text = dailyData.date
            self.descriptionLabel.text = dailyData.explanation
            self.copyrightLabel.text = dailyData.copyright ?? ""
            self.authorLabel.text = dailyData.author ?? ""
        }
        print(dailyData.description)
        Task {
            let data = await self.viewModel.getImage(url: dailyData.url)
            if let data = data {
                let image = UIImage(data: data)
                self.cropImage(image: image, imageView: imageView)
                self.viewModel.image = image
                if !self.viewModel.dataSaved {
                    let dailyData = DailyData(title: dailyData.title,
                                              url: dailyData.url,
                                              explanation: dailyData.explanation,
                                              date: dailyData.date,
                                              media_type: dailyData.media_type,
                                              copyright: dailyData.copyright,
                                              author: dailyData.author,
                                              imageData: data)
                    self.viewModel.saveToStorage(dailyData: dailyData)
                }
            }
        }
    }
}

