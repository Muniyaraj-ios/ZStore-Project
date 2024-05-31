//
//  SubHomeViewController.swift
//  ZStore
//
//  Created by Apple on 30/05/24.
//

import UIKit

enum sel_FilterState{
    case rating
    case price
}
class SubHomeViewController: BaseVC {
    
    lazy var coreManager = CoreManger()
    
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
    private var sel_card_id: CardOfferEntity?
    
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
        fetchAPIData()
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
        filterBtn.makeEdgeConstraints(top: nil, leading: nil, trailing: view.trailingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor,edge: .init(top: 0, left: 0, bottom: 35, right: 30))
        filterBtn.equalSizeConstrinats(40)
        
        filterBtn.menu = createMenu()
        filterBtn.showsMenuAsPrimaryAction = true
        
        setupDelegate()
        collectionView.addSubview(refershControl)
        refershControl.addTarget(self, action: #selector(refershNewData), for: .valueChanged)
        headerSearchBtn.addTarget(self, action: #selector(searchActionTriggered(_:)), for: .touchUpInside)
        cancelBtn.addTarget(self, action: #selector(searchActionTriggered(_:)), for: .touchUpInside)
    }
    func fetchAPIData(){
        let viewModel = HomeViewModel()
        viewModel.fetchfreshData { [weak self] message,error in
            if message != nil{
                self?.coreManager.setData(viewModel.homeData){ msg in
                    print("get message : \(msg)")
                    self?.fetchResult()
                }
            }else if error != nil{
                self?.fetchResult()
            }
        }
    }
    private func fetchResult(){
        coreManager.fetchData(sel_state){ [weak self] in
            self?.collectreloadData()
        }
    }
    func createMenu() -> UIMenu {
        let ratingImage = UIImage(systemName: "star")?.withTintColor(.orange, renderingMode: .alwaysOriginal)
        let priceImage = UIImage(systemName: "dollarsign.circle")?.withTintColor(.orange, renderingMode: .alwaysOriginal)
        
        let ratingAction = UIAction(title: "Rating", image: ratingImage, state: sel_state == .rating ? .on : .off) { [weak self] action in
            if self?.sel_state != .rating{
                self?.sel_state = .rating
                self?.fetchResult()
            }
            print("rating selected")
            if let button = self?.view.subviews.first(where: { $0 is UIButton }) as? UIButton {
                button.menu = self?.createMenu()
            }
        }
        let priceAction = UIAction(title: "Price", image: priceImage, state: sel_state == .price ? .on : .off) { [weak self] action in
            if self?.sel_state != .price{
                self?.sel_state = .price
                self?.fetchResult()
            }
            print("price selected")
            if let button = self?.view.subviews.first(where: { $0 is UIButton }) as? UIButton {
                button.menu = self?.createMenu()
            }
        }
        return UIMenu(title: "Filter Order: From Top to Bottom", options: .displayInline, children: [ratingAction,priceAction])
    }
    @objc func searchActionTriggered(_ sender: UIButton){
        defer{
            if sender == headerSearchBtn{
                searchTxt.becomeFirstResponder()
            }
        }
        if sender == cancelBtn{
            if !coreManager.main_homeData.contains(where: { $0.type == .offers }){
                let offer_data = ZstoreMainEntity(type: .offers, items: MainEntity(offer: coreManager.homeData.offer))
                coreManager.main_homeData.insert(offer_data, at: 1)
            }
            if !(searchTxt.text?.isEmpty ?? true){
                filterClearReload()
                filterData("")
            }
        }else if sender == headerSearchBtn{
            coreManager.main_homeData.removeAll{ $0.type == .offers }
        }
        collectreloadData()
        refershControl.isHidden = true
        searchSectionStack.isHidden = sender == cancelBtn
        HeaderStack.isHidden = sender == headerSearchBtn
        filterBtn.isHidden = sender == headerSearchBtn
    }
    @objc func cancelDidTap(){
        searchTxt.resignFirstResponder()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        horiSearchStack.cornerRadiusWithBorder(isRound: true,isBorder: true,borWidth: 1,borColor: .darkColor)
    }
    @objc func refershNewData(){
        let cate_empty = coreManager.main_homeData.first?.items.category?.isEmpty ?? true
        if cate_empty{
            fetchAPIData()
            self.refershControl.endRefreshing()
        }else{
            coreManager.fetchData(sel_state) { [weak self] in
                guard let self = self else{return}
                if !self.searchSectionStack.isHidden{
                    self.coreManager.main_homeData.removeAll{ $0.type == .offers }
                    if let text = self.searchTxt.text,!text.isEmpty{
                        self.filterData(text)
                    }
                }
                self.refershControl.endRefreshing()
                self.collectreloadData()
            }
        }
    }
    private func compLayout()->UICollectionViewCompositionalLayout{
        let complayout = UICollectionViewCompositionalLayout{ [self] section, _ in
            let sectionType = coreManager.main_homeData[section].type
            switch sectionType{
            case .categories: return compCategoryLayout()
            case .offers: return compOfferLayout()
            case .products: return compProductLayout(1)
            }
        }
        return complayout
    }
    private func compCategoryLayout()->NSCollectionLayoutSection{
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .estimated(50), heightDimension: .estimated(80)))
        let layoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(80))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: layoutSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: 5, bottom: 20, trailing: 5)
        return section
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
        let categoryCount = coreManager.main_homeData.first?.items.category?.isEmpty ?? true
        if !categoryCount{
            section.boundarySupplementaryItems = sel_card_id == nil ? [header] : [header,footer]
        }
        
        section.orthogonalScrollingBehavior = .groupPaging
        return section
    }
    private func compProductLayout(_ section: Int = 0)-> NSCollectionLayoutSection{
        let sectionbase = coreManager.main_homeData.first?.items.category?.isEmpty ?? true ? false : coreManager.main_homeData.contains(where: { $0.type == .categories && $0.items.category?[selIndex].layout == "waterfall" })
        
        if sectionbase{
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
    private func collectreloadData(){
        DispatchQueue.main.async { [weak self] in
            guard let self = self else{return}
            self.collectionView.setCollectionViewLayout(self.compLayout(), animated: false)
            self.collectionView.reloadData()
        }
        collectionView.reloadData()
    }
}
extension SubHomeViewController: UICollectionViewDataSource,UICollectionViewDelegate{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return coreManager.main_homeData.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let data = coreManager.main_homeData[section]
        switch coreManager.main_homeData[section].type{
        case .categories: 
            return data.items.category?.count ?? 0
        case .offers: 
            return data.items.offer?.count ?? 0
        case .products:
            let prod = data.items.product?.filter{ $0.category_id == coreManager.homeData.category?[selIndex].id }
            return prod?.count ?? 0
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = coreManager.main_homeData[indexPath.section]
        switch data.type{
        case .categories:
            let textEmpty = searchTxt.text?.isEmpty ?? true
            let cell = collectionView.dequeueReusableCell(cell: CategoryCollectionCell.self, indexPath: indexPath)
            cell.isChoosed = selIndex == indexPath.item
            let prodList = (coreManager.main_homeData.last?.items.product?.count ?? -1)
            let prodCount = (cell.isChoosed && prodList >= 0 && !textEmpty) ? " (\(prodList))" : ""
            let category = (data.items.category?[indexPath.row].name ?? "") + (prodCount)
            cell.categoryLbl.text = category
            return cell
        case .offers:
            let cell = collectionView.dequeueReusableCell(cell: OfferCollectionCell.self, indexPath: indexPath)
            let offer = data.items.offer?[indexPath.item]
            cell.bgContainerView.backgroundColor = indexPath.item == 0 ? .BlueSub : indexPath.item == 1 ? .Orange : .systemPink
            cell.setupConfigure(offer)
            return cell
        case .products:
            let sectionbase = coreManager.main_homeData.contains(where: { $0.type == .categories && $0.items.category?[selIndex].layout == "linear" })
            let prod = data.items.product?.filter{ $0.category_id == coreManager.homeData.category?[selIndex].id}[indexPath.row]
            if sectionbase{
                let cell = collectionView.dequeueReusableCell(cell: ProductCollectionCell.self, indexPath: indexPath)
                cell.configureUI(prod, sel_card_id: sel_card_id)
                return cell
            }else{
                let cell = collectionView.dequeueReusableCell(cell: ProductItemCollectionCell.self, indexPath: indexPath)
                cell.configureUI(prod,sel_card_id: sel_card_id)
                cell.addEditFav = { [weak self] status in
                    self?.coreManager.updateFavouriteStatus(prod?.id ?? "", status: status)
                    cell.isFavourite = status
                }
                return cell
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = coreManager.main_homeData[indexPath.section]
        switch data.type{
        case .categories:
            if selIndex != indexPath.item{
                selIndex = indexPath.item
                if let text = searchTxt.text,!text.isEmpty{
                    filterData(text)
                }else{
                    collectreloadData()
                }
            }
            break
        case .offers:
            if sel_card_id?.id ?? "" != data.items.offer?[indexPath.item].id ?? "-"{
                sel_card_id = data.items.offer?[indexPath.item]
                collectreloadData()
            }
            break
        case .products:
            break
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

extension SubHomeViewController: UITextFieldDelegate{
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
        filterData("")
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func filterData(_ key: String){
        let prodFilterResult = key.isEmpty ? coreManager.homeData.product : coreManager.homeData.product?.filter{ ($0.name?.lowercased().contains(key.lowercased()) ?? false) && (($0.category_id ?? "") == (coreManager.homeData.category?[selIndex].id ?? "-")) }
        
        coreManager.main_homeData = coreManager.main_homeData.map{ model in
            if model.type == .products{
                let updateItems = model.items.product.map{ items in
                    MainEntity(category: nil, offer: nil, product: prodFilterResult)
                }
                return ZstoreMainEntity(type: .products, items: updateItems ?? .emptyData)
            }
            return model
        }
        collectionView.reloadData()
    }
    func filterClearReload(){
        searchTxt.text = nil
    }
    func filterReloadData(){
        collectreloadData()
    }
}
