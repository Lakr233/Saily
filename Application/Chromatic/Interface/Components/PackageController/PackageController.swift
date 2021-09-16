//
//  PackageViewController.swift
//  Chromatic
//
//  Created by Lakr Aream on 2020/5/3.
//  Copyright © 2020 Lakr Aream. All rights reserved.
//

import AptRepository
import Down
import JsonDepiction
import UIKit
import WebKit

class PackageController: UIViewController {
    var packageObject = Package(identity: "")

    convenience init(package: Package) {
        self.init(nibName: nil, bundle: nil)
        packageObject = package
    }

    // MARK: PROPERTY

    let container = UIScrollView()
    let bannerImageView = UIImageView()
    var bannerPackageView = PackageBannerView(package: Package(identity: ""))
    var preferredBannerHeight: CGFloat = 120

    let navigationBlurEffectView = UIView()
    var blurViewActivated: Bool = false

    var depictionView = UIView() {
        didSet {
            oldValue.removeFromSuperview()
            container.addSubview(depictionView)
            if let depictionView = depictionView as? DepictionBaseView {
                depictionViewHeight = depictionView.depictionHeight(width: view.width)
            } else {
                /* else if let view = view as? ExpandedWebView */
                // no need to do here, we do the math in it's block
                depictionViewHeight = 1000
            }
            depictionView.snp.makeConstraints { x in
                x.top.equalTo(self.bannerPackageView.snp.bottom)
                x.left.equalTo(self.view)
                x.right.equalTo(self.view)
                x.height.equalTo(depictionViewHeight)
            }
        }
    }

    var depictionViewHeight: CGFloat = 1000 {
        didSet {
            updateContentSize()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        preferredContentSize = preferredPopOverSize

        bannerPackageView = PackageBannerView(package: packageObject)
        navigationItem.largeTitleDisplayMode = .never

        view.addSubview(container)
        if navigationController != nil {
            container.delegate = self
            view.addSubview(navigationBlurEffectView)
            let effect = UIBlurEffect(style: .systemMaterial)
            let effectView = UIVisualEffectView(effect: effect)
            navigationBlurEffectView.addSubview(effectView)
            navigationBlurEffectView.alpha = 0
            effectView.snp.makeConstraints { x in
                x.edges.equalToSuperview()
            }
            navigationBlurEffectView.snp.makeConstraints { x in
                x.leading.equalToSuperview()
                x.trailing.equalToSuperview()
                x.top.equalToSuperview()
                x.height.equalTo(topbarHeight)
            }
            DispatchQueue.main.async { [self] in
                view.bringSubviewToFront(navigationBlurEffectView)
            }
        }

        container.addSubview(bannerImageView)
        let bannerPackageViewShadow = UIView()
        container.addSubview(bannerPackageViewShadow)
        container.addSubview(bannerPackageView)

        container.alwaysBounceVertical = true
        container.snp.makeConstraints { x in
            x.edges.equalToSuperview()
        }

        bannerPackageView.backgroundColor = .systemBackground
        bannerPackageView.snp.makeConstraints { x in
            x.top.equalTo(container).offset(preferredBannerHeight)
            x.leading.equalTo(self.view)
            x.trailing.equalTo(self.view)
            x.height.equalTo(80)
        }

        bannerPackageViewShadow.backgroundColor = .white
        bannerPackageViewShadow.addShadow(ofColor: .black, radius: 10, opacity: 0.25)
        bannerPackageViewShadow.snp.makeConstraints { x in
            x.leading.equalTo(self.view)
            x.trailing.equalTo(self.view)
            x.top.equalTo(bannerPackageView)
            x.height.equalTo(10)
        }

        bannerImageView.image = UIImage(named: "BannerImagePlaceholder")
        bannerImageView.contentMode = .scaleAspectFill
        bannerImageView.clipsToBounds = true
        bannerImageView.snp.makeConstraints { x in
            x.top.lessThanOrEqualTo(self.container.snp.top)
            x.top.lessThanOrEqualTo(self.view.snp.top)
            x.left.equalTo(self.view)
            x.right.equalTo(self.view)
            x.height.lessThanOrEqualTo(preferredBannerHeight)
            x.height.equalTo(preferredBannerHeight)
            x.bottom.equalTo(bannerPackageView.snp.top)
        }

        depictionView = defaultDepiction()
        container.addSubview(depictionView)
        depictionView.snp.makeConstraints { x in
            x.top.equalTo(bannerPackageView.snp.bottom)
            x.left.equalTo(self.view)
            x.right.equalTo(self.view)
            x.height.equalTo(depictionViewHeight)
        }

        downloadDepictionIfAvailable { [weak self] view in
            guard let self = self, let view = view else {
                return
            }
            self.depictionView = view
            self.updateContentSize()
        }

        updateContentSize()
    }

    deinit {
        debugPrint("\(self) deinit")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
    }

    func updateContentSize() {
        DispatchQueue.main.async { [self] in
            if depictionView is ExpandedWebView {
                depictionView.snp.updateConstraints { x in
                    // for web document background color
                    x.height.equalTo(depictionViewHeight + 1000)
                }
            } else {
                depictionView.snp.updateConstraints { x in
                    x.height.equalTo(depictionViewHeight)
                }
            }
            let size = CGSize(width: 10, height: depictionViewHeight
                + preferredBannerHeight
                + 150)
            container.contentSize = size
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updatePreferredImageHeight()
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.8, options: .curveEaseInOut, animations: { [self] in
            bannerPackageView.snp.updateConstraints { x in
                x.top.equalTo(container).offset(preferredBannerHeight)
            }
            bannerImageView.snp.updateConstraints { x in
                x.height.lessThanOrEqualTo(preferredBannerHeight)
                x.height.equalTo(preferredBannerHeight)
            }
        }, completion: { [self] _ in
            updateContentSize()
        })
        updateContentSize()
    }

    func updatePreferredImageHeight() {
        guard let height = bannerImageView.image?.size.height,
              let width = bannerImageView.image?.size.width
        else {
            return
        }
        let ratio = width / height
        var preferredHeight = view.width / ratio

        // still need to delete top bar hight
        preferredHeight -= topbarHeight

        let decision = view.frame.height
        let minHeight = decision * 0.2
        let maxHeight = decision * 0.4

        if preferredHeight < minHeight {
            preferredHeight = minHeight
        }
        if preferredHeight > maxHeight {
            preferredHeight = maxHeight
        }
        preferredBannerHeight = preferredHeight
    }
}

extension PackageController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if preferredBannerHeight - topbarHeight < scrollView.contentOffset.y {
            if !blurViewActivated {
                navigationBlurEffectView.snp.updateConstraints { x in
                    x.height.equalTo(topbarHeight)
                }
                activateBlurEffectView()
                blurViewActivated = true
            }
        } else {
            if blurViewActivated {
                deactivateBlurEffectView()
                blurViewActivated = false
            }
        }
    }

    func activateBlurEffectView() {
        UIView.animate(withDuration: 0.25) {
            self.navigationBlurEffectView.alpha = 1
        }
    }

    func deactivateBlurEffectView() {
        UIView.animate(withDuration: 0.25) {
            self.navigationBlurEffectView.alpha = 0
        }
    }
}
