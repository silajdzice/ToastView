// The Swift Programming Language
// https://docs.swift.org/swift-book
// swift-tools-version:5.3

import Foundation
import UIKit

public struct ToastViewModel {
    var title: String
    var description: String
    var duration: Double
    var icon: UIImage?
    var closeIcon: UIImage?
    var backgroundColor: UIColor
    var textColor: UIColor
    var progressViewColor: UIColor
    var iconDimensions: CGFloat = 16
    
    public init(title: String, description: String, duration: Double = 2.0, icon: UIImage?, closeIcon: UIImage?, backgroundColor: UIColor, textColor: UIColor, progressViewColor: UIColor, iconDimensions: CGFloat = 16) {
        self.title = title
        self.description = description
        self.duration = duration
        self.icon = icon
        self.closeIcon = closeIcon
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.progressViewColor = progressViewColor
        self.iconDimensions = iconDimensions
    }
}

public class ToastView: UIView {
    private var loaderViewWidthConstraint: NSLayoutConstraint?
    var timer = Timer()
    var time = 0.0
    var duration: Double = 2
    var progressRefreshInterval = 0.01
    var viewModel: ToastViewModel? {
        didSet {
            updateUI()
            layout()
        }
    }
    
    public init(viewModel: ToastViewModel) {
        defer {
            self.viewModel = viewModel
        }
        super.init(frame: .zero)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var icon: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.addShadow(color: .black)
        view.layer.cornerRadius = 8
        return view
    }()
    
    private lazy var loaderView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var closeIcon: UIImageView = {
        let view = UIImageView()
        view.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeView))
        view.addGestureRecognizer(tapGesture)
        return view
    }()
    
    func updateUI() {
        guard let viewModel = viewModel else { return }
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
        titleLabel.textColor = viewModel.textColor
        descriptionLabel.textColor = viewModel.textColor
        icon.image = viewModel.icon
        closeIcon.image = viewModel.closeIcon
        containerView.backgroundColor = viewModel.backgroundColor
        loaderView.backgroundColor = viewModel.progressViewColor
        self.duration = viewModel.duration
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: progressRefreshInterval, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
    }
    
    func layout() {
        addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        [icon, titleLabel, descriptionLabel, loaderView, closeIcon].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview($0)
        }
        
        // Icon constraints
        NSLayoutConstraint.activate([
            icon.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            icon.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            icon.widthAnchor.constraint(equalToConstant: viewModel?.iconDimensions ?? 16),
            icon.heightAnchor.constraint(equalToConstant: viewModel?.iconDimensions ?? 16)
        ])
        
        // Close icon constraints
        NSLayoutConstraint.activate([
            closeIcon.widthAnchor.constraint(equalToConstant: viewModel?.iconDimensions ?? 16),
            closeIcon.heightAnchor.constraint(equalToConstant: viewModel?.iconDimensions ?? 16),
            closeIcon.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            closeIcon.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8)
        ])
        
        // Title label constraints
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: closeIcon.leadingAnchor, constant: -8),
            titleLabel.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 8)
        ])
        
        // Container view constraints
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -8),
            containerView.bottomAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
        // Loader view constraints
        loaderView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loaderView.heightAnchor.constraint(equalToConstant: 3),
            loaderView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            loaderView.topAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        loaderViewWidthConstraint = loaderView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width)
        loaderViewWidthConstraint?.isActive = true
        
        // Description label constraints
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            descriptionLabel.trailingAnchor.constraint(equalTo: closeIcon.leadingAnchor, constant: -8),
            descriptionLabel.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 8)
        ])
        
        // Self constraints
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: containerView.topAnchor, constant: -8),
            self.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 12),
            self.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - (16 * 2))
        ])
    }
    
    @objc
    func updateProgress() {
        time += progressRefreshInterval
        let progress = min(time / duration, 1.0)
        let screenSize = UIScreen.main.bounds.size.width
        let newWidth: CGFloat = screenSize * (1 - progress)
        
        loaderViewWidthConstraint?.constant = newWidth
        
        UIView.animate(withDuration: progressRefreshInterval) {
            self.layoutIfNeeded()
        }
    }
    
    @objc
    func closeView() {
        self.timer.invalidate()
        self.fadeOut(duration: 0.5) {
            self.removeFromSuperview()
        }
    }
    
    public func show() {
        alpha = 0
        runTimer()
        
        if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
            window.addSubview(self)
            self.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                self.centerXAnchor.constraint(equalTo: window.centerXAnchor),
                self.bottomAnchor.constraint(equalTo: window.safeAreaLayoutGuide.bottomAnchor, constant: -48)
            ])
        }
        
        fadeIn(duration: 0.3)
        let deadlineTime = DispatchTime.now() + DispatchTimeInterval.milliseconds(Int(duration * 1000))
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) { [weak self] in
            self?.closeView()
        }
    }
}
