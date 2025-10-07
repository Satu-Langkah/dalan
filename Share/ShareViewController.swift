//
//  ShareViewController.swift
//  Share
//
//  Created by Jerry Febriano on 29/09/25.
//

import UIKit
import UniformTypeIdentifiers
import SwiftData

@MainActor
final class ShareViewController: UIViewController {
    
    private var viewModel: ShareViewModel?
    private let toastView = UIView()
    private let toastLabel = UILabel()
    private var currentProvider: NSItemProvider?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewModel()
        setupToastView()
        extractAndProcessURL()

        // TODO: I still don't know how the fuck I remove the dismiss
        // animation when the `viewWillDisappear` is called.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupTransparentBackground()
        super.viewWillAppear(animated)
    }
    
    // MARK: - Setup
    
    private func setupTransparentBackground() {
        // Walk up the view hierarchy and make all superviews transparent
        var current: UIView? = view
        while let superview = current?.superview{
            superview.backgroundColor = .clear
            superview.isOpaque = false
            current = superview
        }
    }
    
    private func setupViewModel() {
        do {
            let modelContainer = try ModelContainer.createSharedContainer()
            let modelContext = ModelContext(modelContainer)
            self.viewModel = ShareViewModel(modelContext: modelContext)
        } catch {
            print("Failed to create ModelContainer: \(error)")
            closeExtension()
        }
    }
    
    private func setupToastView() {
        toastView.backgroundColor = .systemBackground
        toastView.layer.shadowColor = UIColor.black.cgColor
        toastView.layer.shadowOpacity = 0.1
        toastView.layer.shadowOffset = CGSize(width: 0, height: 2)
        toastView.layer.shadowRadius = 8
        toastView.layer.cornerCurve = .continuous
        toastView.translatesAutoresizingMaskIntoConstraints = false
        toastView.alpha = 0
        view.addSubview(toastView)
        
        toastLabel.font = .systemFont(ofSize: 16, weight: .medium)
        toastLabel.textAlignment = .center
        toastLabel.numberOfLines = 0
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        toastView.addSubview(toastLabel)
        
        NSLayoutConstraint.activate([
            toastView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            toastView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            toastView.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, multiplier: 0.8),
            toastView.heightAnchor.constraint(greaterThanOrEqualToConstant: 20),
            
            toastLabel.topAnchor.constraint(equalTo: toastView.topAnchor, constant: 10),
            toastLabel.leadingAnchor.constraint(equalTo: toastView.leadingAnchor, constant: 30),
            toastLabel.trailingAnchor.constraint(equalTo: toastView.trailingAnchor, constant: -30),
            toastLabel.bottomAnchor.constraint(equalTo: toastView.bottomAnchor, constant: -10)
        ])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Make the toast fully rounded (pill shape) based on its current height
        toastView.layer.cornerRadius = toastView.bounds.height / 2
    }
    
    // MARK: - URL Processing
    
    private func extractAndProcessURL() {
        guard let item = extensionContext?.inputItems.first as? NSExtensionItem,
              let provider = item.attachments?.first else {
            showToast(message: "No content to share", success: false)
            return
        }

        // Prefer explicit typed loading to avoid expectedValueClass warnings
        if provider.canLoadObject(ofClass: URL.self) {
            self.currentProvider = provider
            _ = provider.loadObject(ofClass: URL.self) { [weak self] (url, error) in
                guard let self else { return }
                if let url = url {
                    Task { @MainActor in
                        self.processURL(url.absoluteString)
                    }
                } else {
                    Task { @MainActor in
                        if let provider = self.currentProvider {
                            self.tryPlainText(provider: provider)
                        } else {
                            self.showToast(message: "Only links are supported", success: false)
                        }
                    }
                }
            }
        } else {
            self.currentProvider = provider
            tryPlainText(provider: provider)
        }
    }
    
    private func tryPlainText(provider: NSItemProvider) {
        guard provider.canLoadObject(ofClass: NSString.self) else {
            Task { @MainActor in
                showToast(message: "Only links are supported", success: false)
            }
            return
        }

        _ = provider.loadObject(ofClass: NSString.self) { [weak self] (string, error) in
            guard let self else { return }
            if let s = string as? String {
                Task { @MainActor in
                    self.processURL(s)
                }
            } else {
                Task { @MainActor in
                    self.showToast(message: "Invalid link format", success: false)
                }
            }
        }
    }
    
    private func processURL(_ urlString: String) {
        Task { @MainActor in
            guard let viewModel = self.viewModel else {
                showToast(message: "Setup error", success: false)
                return
            }
            
            let success = await viewModel.processSharedURL(urlString)
            
            if success {
                showToast(message: "Link saved! ✓", success: true)
            } else {
                let message = viewModel.errorMessage ?? "Failed to save link"
                showToast(message: message, success: false)
            }
        }
    }
    
    // MARK: - Toast
    
    private func showToast(message: String, success: Bool) {
        toastLabel.text = message
        toastLabel.textColor = success ? .systemGreen : .systemRed
        
        UIView.animate(withDuration: 0.3) {
            self.toastView.alpha = 1
        } completion: { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + (success ? 1.0 : 3.0)) {
                UIView.animate(withDuration: 0.3) {
                    self.toastView.alpha = 0
                } completion: { _ in
                    self.closeExtension()
                }
            }
        }
    }
    
    private func closeExtension() {
        extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
    }
}

