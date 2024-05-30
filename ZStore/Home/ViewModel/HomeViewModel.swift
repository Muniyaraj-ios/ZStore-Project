//
//  HomeViewMode.swift
//  ZStore
//
//  Created by Apple on 27/05/24.
//

import Foundation

class HomeViewModel{
    
    private(set) var homeData: HomeDataModel = .emptyData
    var filterproducts: [ProductsDataModel] = []
    
    func fetchData(closure: (()->())?){
        guard let data  = CommonUtility.readJSON(forName: .data) else{return}
        do{
            self.homeData = try JSONDecoder().decode(HomeDataModel.self, from: data)
//            print("Home data : \(self.homeData)")
            closure?()
        }catch{
            print("Something is wrong while decoding the data : ",error.localizedDescription)
        }
    }
    
    func fetchfreshData(closure: (()->())?){
        let networkManager = APIManger()
        networkManager.getAllData(networkManager.getURLRequest()!) { (result: Results<HomeDataModel,Error>) in
            DispatchQueue.main.async {
                switch result{
                case .success(let mainData):
                    self.homeData =  mainData
                    print("MainData : \(mainData)")
                    closure?()
                case .failure(let error):
                    print("Error : \(error.localizedDescription)")
                }
            }
        }
    }
}
