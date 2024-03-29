//
//  Interactor.swift
//  ViperDemo
//
//  Created by Tung on 06/12/2023.
//

import Foundation

// Object
// Protocol
// Ref to presenter

// https://jsonplaceholder.typicode.com/users

protocol AnyInteractor {
    var presenter: AnyPresenter? { get set}
    
    func getUsers()
}

class UserInteractor: AnyInteractor {
    var presenter: AnyPresenter?
    
    func getUsers() {
        print("Start fetching")
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else { return }
        // get data from API
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                self?.presenter?.interactorDidFetchUsers(with: .failure(FetchError.failed))
                return
            }
            
            do {
                let entities = try JSONDecoder().decode([User].self, from: data)
                
                self?.presenter?.interactorDidFetchUsers(with: .success(entities))
            } catch {
                self?.presenter?.interactorDidFetchUsers(with: .failure(error))
            }
        }
        task.resume()
    }
}
