//
//  HomeViewController.swift
//  ZStore
//
//  Created by Apple on 26/05/24.
//

import UIKit

class HomeViewController: BaseVC {

    lazy var homeVM = HomeViewModel()
    
    lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: compLayout())
        collection.register(cell: CategoryCollectionCell.self)
        collection.register(cell: OfferCollectionCell.self)
        collection.register(cell: ProductCollectionCell.self)
        collection.register(cell: ProductItemCollectionCell.self)
        
        collection.register(ofKind: UICollectionView.elementKindSectionHeader, cell: OfferHeaderView.self)
        collection.register(ofKind: UICollectionView.elementKindSectionFooter, cell: OfferFooterView.self)
        collection.showsVerticalScrollIndicator = false
        collection.keyboardDismissMode = .onDrag
        return collection
    }()
    
    private var selIndex: Int = 0
    private var sel_card_id: CardOfferModel?
    
    var refershControl = UIRefreshControl()
    
    lazy var searchTxt: UITextField = {
        let tf = UITextField()
        tf.returnKeyType = .search
        tf.placeholder = "Search Here..."
        tf.textColor = .BlackColor
        tf.font = .systemFont(ofSize: 15, weight: .regular)
        tf.tintColor = .Orange
        tf.layoutMargins = .init(top: 8, left: 8, bottom: 8, right: 8)
        tf.clearButtonMode = .always
        tf.autocorrectionType = .no
        tf.spellCheckingType = .no
        tf.keyboardType = .asciiCapable
        tf.delegate = self
        return tf
    }()
    lazy var cancelBtn: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        button.setTitleColor(.Orange, for: .normal)
        button.tintColor = .cyan
        button.addTarget(self, action: #selector(cancelDidTap), for: .touchUpInside)
        return button
    }()
    lazy var SearchBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "text.magnifyingglass"), for: .normal)
        button.tintColor = .BlackColor
        button.contentMode = .scaleToFill
        button.imageView?.contentMode = .scaleToFill
        return button
    }()
    lazy var horiSearchStack = HorizontalStack(arrangedSubViews: [SearchBtn,searchTxt], spacing: 8, alignment: .center, distribution: .fill)
    lazy var searchSectionStack = HorizontalStack(arrangedSubViews: [horiSearchStack,cancelBtn], spacing: 16, alignment: .center, distribution: .fill)
    
    lazy var headerLbl = UILabel(text: "Zstore", textColor: .label, font: .setFont(size: 24, weight: .semibold))
    lazy var headerSearchBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "text.magnifyingglass"), for: .normal)
        button.tintColor = .BlackColor
        button.contentMode = .scaleToFill
        button.imageView?.contentMode = .scaleToFill
        return button
    }()
    lazy var HeaderStack = HorizontalStack(arrangedSubViews: [headerLbl,headerSearchBtn], spacing: 16, alignment: .center, distribution: .fill)
    
    lazy var headerWholeStack = HorizontalStack(arrangedSubViews: [HeaderStack,searchSectionStack], spacing: 16, alignment: .center, distribution: .fill)
    
    lazy var filterBtn: CircleButton = {
        let button = CircleButton()
        button.bgColor = .clear
        return button
    }()
    
    var sel_state: sel_FilterState = .rating
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        setupViews()
        fetchResult()
    }
    fileprivate func setupViews(){
        view.backgroundColor = .systemBackground
        
        horiSearchStack.layoutMargins = .init(top: 6, left: 6, bottom: 6, right: 4)
        horiSearchStack.isLayoutMarginsRelativeArrangement = true
        horiSearchStack.clipsToBounds = true
        
        searchSectionStack.isHidden = true
        HeaderStack.isHidden = false
        
        headerWholeStack.layoutMargins = .init(top: 5, left: 15, bottom: 5, right: 5)
        headerWholeStack.isLayoutMarginsRelativeArrangement = true
        headerWholeStack.clipsToBounds = true
        
        view.addSubview(headerWholeStack)
        headerWholeStack.makeEdgeConstraints(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil,edge: .init(top: 2, left: 3, bottom: 5, right: 3),height: 55)
        
        cancelBtn.widthConstraints(60)
        headerSearchBtn.equalSizeConstrinats(45)
        SearchBtn.equalSizeConstrinats(30)
        
        view.addSubview(collectionView)
        collectionView.makeEdgeConstraints(top: horiSearchStack.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor,edge: .init(top: 20, left: 0, bottom: 0, right: 0))
        
        view.addSubview(filterBtn)
        filterBtn.makeEdgeConstraints(top: nil, leading: nil, trailing: view.trailingAnchor, bottom: view.bottomAnchor,edge: .init(top: 0, left: 0, bottom: 50, right: 30))
        filterBtn.equalSizeConstrinats(40)
        
        filterBtn.menu = createMenu()
        filterBtn.showsMenuAsPrimaryAction = true
        
        setupDelegate()
        collectionView.addSubview(refershControl)
        refershControl.addTarget(self, action: #selector(refershNewData), for: .valueChanged)
        headerSearchBtn.addTarget(self, action: #selector(searchActionTriggered(_:)), for: .touchUpInside)
        cancelBtn.addTarget(self, action: #selector(searchActionTriggered(_:)), for: .touchUpInside)
    }
    
    func addMenuItems()->UIMenu{
        let ratingHandle = { (action : UIAction) in
            print("Menu Action : \(action.title)")
            self.sel_state = .rating
        }
        let priceHandle = { (action : UIAction) in
            print("Menu Action : \(action.title)")
            self.sel_state = .price
        }
        
        let ratingImage = UIImage(systemName: "star")?.withTintColor(.orange, renderingMode: .alwaysOriginal)
        let priceImage = UIImage(systemName: "dollarsign.circle")?.withTintColor(.orange, renderingMode: .alwaysOriginal)
        
        let menuItems = UIMenu(title: "",options: .displayInline,children: [
            UIAction(title: "Rating",image: ratingImage, state: sel_state == .rating ? .on : .off, handler: ratingHandle),
            UIAction(title: "Price", image: priceImage, state: sel_state == .price ? .on : .off, handler: priceHandle)
        ])
        return menuItems
    }
    func createMenu() -> UIMenu {
        let ratingImage = UIImage(systemName: "star")?.withTintColor(.orange, renderingMode: .alwaysOriginal)
        let priceImage = UIImage(systemName: "dollarsign.circle")?.withTintColor(.orange, renderingMode: .alwaysOriginal)
        
        let ratingAction = UIAction(title: "Rating", image: ratingImage, state: sel_state == .rating ? .on : .off) { action in
            self.sel_state = .rating
            if let button = self.view.subviews.first(where: { $0 is UIButton }) as? UIButton {
                button.menu = self.createMenu()
            }
        }
        let priceAction = UIAction(title: "Price", image: priceImage, state: sel_state == .price ? .on : .off) { action in
            self.sel_state = .price
            if let button = self.view.subviews.first(where: { $0 is UIButton }) as? UIButton {
                button.menu = self.createMenu()
            }
        }
        return UIMenu(title: "Filter Order: From Top to Bottom", options: .displayInline, children: [ratingAction,priceAction])
    }
    enum sel_FilterState{
        case rating
        case price
    }
    @objc func searchActionTriggered(_ sender: UIButton){
        defer{
            if sender == headerSearchBtn{
                searchTxt.becomeFirstResponder()
            }
        }
        if sender == cancelBtn{
            if !(searchTxt.text?.isEmpty ?? true){
                filterClearReload()
            }
        }
        searchSectionStack.isHidden = sender == cancelBtn
        HeaderStack.isHidden = sender == headerSearchBtn
        collectreloadData()

    }
    @objc func cancelDidTap(){
        searchTxt.resignFirstResponder()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        horiSearchStack.cornerRadiusWithBorder(isRound: true,isBorder: true,borWidth: 1,borColor: .darkColor)
    }
    @objc func refershNewData(){
        DispatchQueue.main.asyncAfter(deadline: .now()+2){ [self] in
            refershControl.endRefreshing()
            collectreloadData()
//            collectionView.reloadData()
        }
    }
    private func compLayout()->UICollectionViewCompositionalLayout{
//        let textEmpty = searchSectionStack.isHidden//searchTxt.text?.isEmpty ?? true
        let textEmpty = searchTxt.text?.isEmpty ?? true
        let searchSection = searchSectionStack.isHidden
        let layout = UICollectionViewCompositionalLayout{ [self] sectionNo,_ in
            if sectionNo == 0{
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .estimated(50), heightDimension: .estimated(80)))
                let layoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(80))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: layoutSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = .init(top: 0, leading: 5, bottom: 20, trailing: 5)
                return section
            }else if sectionNo == 1{
                return textEmpty && searchSection ? compOfferLayout() : compProductLayout()
            }else{
                return compProductLayout()
            }
        }
        return layout
    }
    private func compOfferLayout()-> NSCollectionLayoutSection{
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        item.contentInsets = .init(top: 8, leading: 8, bottom: 0, trailing: 0)
        let layoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .estimated(130))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: layoutSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 8, leading: 4, bottom: 8, trailing: 0)
        
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(30)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
        let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(55)), elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottomLeading
        )
        
        section.boundarySupplementaryItems = sel_card_id == nil ? [header] : [header,footer]
        
        section.orthogonalScrollingBehavior = .groupPaging
        return section
    }
    private func compProductLayout()-> NSCollectionLayoutSection{
        if homeVM.homeData.category.count > 0,homeVM.homeData.category[selIndex].layout == "waterfall"{
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1/2), heightDimension: .fractionalHeight(1)))
            item.contentInsets = .init(top: 6, leading: 6, bottom: 8, trailing: 6)
            let layoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(500))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: layoutSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = .init(top: 0, leading: 3, bottom: 0, trailing: 3)
            return section
        }else{
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
            item.contentInsets = .init(top: 5, leading: 0, bottom: 5, trailing: 0)
            let layoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(230))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: layoutSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = .init(top: 8, leading: 0, bottom: 0, trailing: 0)
            return section
        }
    }
    private func setupDelegate(){
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    private func fetchResult(){
        homeVM.fetchfreshData{ [self] in
            print("Data fetched success")
            collectreloadData()
        }
//        homeVM.fetchData { [self] in
//            print("Data fetched success")
//            collectreloadData()
//        }
    }
    private func collectreloadData(){
        DispatchQueue.main.async { [self] in
            collectionView.setCollectionViewLayout(compLayout(), animated: false)
        }
        collectionView.reloadData()
    }
}
extension HomeViewController: UICollectionViewDataSource,UICollectionViewDelegate{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let textEmpty = searchTxt.text?.isEmpty ?? true
        let searchSection = searchSectionStack.isHidden
        return homeVM.homeData.category.isEmpty ? 0 : (textEmpty && searchSection) ? 3 : 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let data = homeVM.homeData
        let textEmpty = searchTxt.text?.isEmpty ?? true
        let searchSection = searchSectionStack.isHidden
        let prodData = (textEmpty ? data.products : homeVM.filterproducts).filter{ $0.category_id == data.category[selIndex].id }
        return section == 0 ? data.category.count : section == 1 ? (textEmpty && searchSection) ? data.card_offers.count : prodData.count : prodData.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = homeVM.homeData
        let textEmpty = searchTxt.text?.isEmpty ?? true
        let searchSection = searchSectionStack.isHidden
        if indexPath.section == 0{
            let cell = collectionView.dequeueReusableCell(cell: CategoryCollectionCell.self, indexPath: indexPath)
            cell.isChoosed = selIndex == indexPath.item
            let category = data.category[indexPath.item].name + ((!textEmpty && cell.isChoosed) ? " (\(homeVM.filterproducts.count)) " : "")
            cell.categoryLbl.text = category
            return cell
        }else if indexPath.section == 1{
            if textEmpty && searchSection{
                let cell = collectionView.dequeueReusableCell(cell: OfferCollectionCell.self, indexPath: indexPath)
                let offer = data.card_offers[indexPath.item]
                cell.setupConfigure(offer)
                return cell
            }else{
                let productCollectionCell = collectionViewProductItem(collectionView, cellForProductItemAt: indexPath)
                return productCollectionCell
            }
        }else{
            let productCollectionCell = collectionViewProductItem(collectionView, cellForProductItemAt: indexPath)
            return productCollectionCell
        }
    }
    private func collectionViewProductItem(_ collectionView: UICollectionView, cellForProductItemAt indexPath: IndexPath)->UICollectionViewCell{
        let data = homeVM.homeData
        let textEmpty = searchTxt.text?.isEmpty ?? true
        let prod = (textEmpty ? data.products : homeVM.filterproducts).filter{ $0.category_id == data.category[selIndex].id }[indexPath.row]
        if data.category[selIndex].layout == "linear"{
            let cell = collectionView.dequeueReusableCell(cell: ProductCollectionCell.self, indexPath: indexPath)
            cell.configureUI(prod,sel_card_id: sel_card_id)
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(cell: ProductItemCollectionCell.self, indexPath: indexPath)
            cell.configureUI(prod)
            cell.titleLbl.textColor = prod.card_offer_ids.contains(sel_card_id?.id ?? "") ? .green : .BlackColor
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 && selIndex != indexPath.item{
            selIndex = indexPath.item
            if let text = searchTxt.text,!text.isEmpty{
                filterData(text)
            }else{
                collectreloadData()
            }
        }else if indexPath.section == 1{
            let textEmpty = searchTxt.text?.isEmpty ?? true
            let searchSection = searchSectionStack.isHidden
            if textEmpty && searchSection{
                let data = homeVM.homeData
                sel_card_id = data.card_offers[indexPath.item]
                collectreloadData()
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if UICollectionView.elementKindSectionFooter == kind{
            let footerView = collectionView.dequeueReusableCell(ofKind: kind, cell: OfferFooterView.self, indexPath: indexPath)
            footerView.selectedOfferLbl.text = sel_card_id?.card_name ?? ""
            footerView.cancelBtn.addTarget(self, action: #selector(cancelOfferAct(_:)), for: .touchUpInside)
            return footerView
        }else{
            let headView = collectionView.dequeueReusableCell(ofKind: kind, cell: OfferHeaderView.self, indexPath: indexPath)
            return headView
        }
    }
    @objc private func cancelOfferAct(_ sender: UIButton){
        sel_card_id = nil
        collectreloadData()
    }
}


extension HomeViewController: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = textField.text
        if let newString = text as? NSString{
            DispatchQueue.main.async { [weak self] in
                let currentString = newString.replacingCharacters(in: range, with: string) as NSString
                self?.filterData(currentString as String)
            }
        }
        return true
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        filterClearReload()
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    func filterData(_ key: String){
        let data = homeVM.homeData
        let filterData = data.products.filter{ $0.category_id == data.category[selIndex].id }
        let productData = filterData.filter{ $0.name.lowercased().contains(key.lowercased())  }
        homeVM.filterproducts = productData
        print("filterproducts : \(homeVM.filterproducts.count)")
        filterReloadData()
    }
    func filterClearReload(){
        searchTxt.text = nil
        homeVM.filterproducts.removeAll()
        filterReloadData()
    }
    func filterReloadData(){
        collectreloadData()
//        collectionView.reloadData()
        /*DispatchQueue.main.asyncAfter(deadline: .now()+1) { [self] in
            collectionView.setCollectionViewLayout(compLayout(), animated: false){ [self] _ in
                collectionView.reloadData()
            }
        }*/
    }
}
