//
//  DetailGalleryPhotosViewController.swift
//  VKMVVM
//
//  Created by Антон Кочетков on 12.01.2022.
//

import UIKit

class DetailGalleryPhotosViewController: UIPageViewController {
    
    private var viewModel: DetailGalleryPhotosViewModelType!
    
    //MARK: - TopView - NavigationBar
    private let topView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "NavBarDetailGalleryPhoto")
        return view
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "chevron.backward")
        image?.withRenderingMode(.alwaysOriginal)
        button.setImage(image, for: .normal)
        button.contentMode = .scaleAspectFit
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let titleTopViewLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - bottomView
    private let bottomStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let likes: ElementBottomView = {
        let element = ElementBottomView(nameImage: .like, centerPositionSubviewsFlag: true)
        return element
    }()
    
    private let comments: ElementBottomView = {
        let element = ElementBottomView(nameImage: .comment, centerPositionSubviewsFlag: true)
        return element
    }()
    
    private let views: ElementBottomView = {
        let element = ElementBottomView(nameImage: .view, centerPositionSubviewsFlag: true)
        return element
    }()
    
    //MARK: - private property
    private var isHiddenNavBarAndBottomView = false
    private var beginIndex: Int
    
    //MARK: - Init
    init(viewModel: DetailGalleryPhotosViewModelType, beginIndex: Int) {
        self.viewModel = viewModel
        self.beginIndex = beginIndex
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        dataSource = self
        delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - viewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavBarAndBottomView()
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(hidesNavBarAndBottomView))
        view.addGestureRecognizer(gesture)
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(touchBackButton))
        swipeGesture.direction = .down
        view.addGestureRecognizer(swipeGesture)
        
        if let contentVC = showViewControoler(at: beginIndex) {
            setViewControllers([contentVC], direction: .forward, animated: true, completion: nil)
            set(at: beginIndex)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    //MARK: - setups and set content view
    private func setupNavBarAndBottomView() {
        view.addSubview(topView)
        topView.addSubview(backButton)
        topView.addSubview(titleTopViewLabel)
        
        backButton.addTarget(self, action: #selector(touchBackButton), for: .touchUpInside)
        let heightNavBar = navigationController?.navigationBar.frame.height ?? 0
        let heightTopView = heightNavBar + getStatusBarHeight()
        
        view.addSubview(bottomStackView)
        bottomStackView.addArrangedSubview(likes)
        bottomStackView.addArrangedSubview(comments)
        bottomStackView.addArrangedSubview(views)
        
        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: view.topAnchor),
            topView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topView.heightAnchor.constraint(equalToConstant: heightTopView),
            
            backButton.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 16),
            backButton.bottomAnchor.constraint(equalTo: topView.bottomAnchor, constant: -2),
            backButton.heightAnchor.constraint(equalToConstant: heightNavBar),
            
            titleTopViewLabel.centerXAnchor.constraint(equalTo: topView.centerXAnchor),
            titleTopViewLabel.bottomAnchor.constraint(equalTo: topView.bottomAnchor, constant: -2),
            titleTopViewLabel.heightAnchor.constraint(equalToConstant: heightNavBar),
            
            bottomStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomStackView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        
    }
    
    private func set(at index: Int) {
        titleTopViewLabel.text = viewModel.getCurrectTitle(at: index)
        likes.set(text: "")
        views.set(text: "")
        comments.set(text: "")
    }
    
    //MARK: - helper methods
    private func showViewControoler(at index: Int) -> DetailPhotoViewController? {
        guard let photoViewModel = viewModel.getPhoto(at: index) else { return nil }
        
        let photoVC = DetailPhotoViewController()
        photoVC.modelView = photoViewModel
        photoVC.pageNumber = index
        
        return photoVC
    }
    
    private func getStatusBarHeight() -> CGFloat {
        var statusBarHeight: CGFloat = 0
        if #available(iOS 15.0, *) {
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            statusBarHeight = windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            statusBarHeight = UIApplication.shared.statusBarFrame.height
        }
        return statusBarHeight
    }
    
    //MARK: - selectors methods
    @objc private func hidesNavBarAndBottomView() {
        isHiddenNavBarAndBottomView = !isHiddenNavBarAndBottomView
        if isHiddenNavBarAndBottomView {
            UIView.animate(withDuration: 0.8) {
                self.topView.alpha = 0.0
                self.bottomStackView.alpha = 0.0
            }
        } else {
            UIView.animate(withDuration: 0.2) {
                self.topView.alpha = 1
                self.bottomStackView.alpha = 1
            }
        }
    }
    
    @objc private func touchBackButton() {
        navigationController?.popViewController(animated: true)
    }
}

extension DetailGalleryPhotosViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var pageNumber = (viewController as! DetailPhotoViewController).pageNumber
        pageNumber -= 1
        
        return showViewControoler(at: pageNumber)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var pageNumber = (viewController as! DetailPhotoViewController).pageNumber
        pageNumber += 1
        
        return showViewControoler(at: pageNumber)
    }
}

extension DetailGalleryPhotosViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            let index = (pageViewController.viewControllers?.first as! DetailPhotoViewController).pageNumber
            set(at: index)
        }
    }
}
