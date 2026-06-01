//
//  NetworkService.swift
//  Navigation
//
//  Created by Sasha Soldatov on 01.06.2026.
//
import Foundation

struct NetworkService {
    static func request(for configuration: AppConfiguration) {
        let url: URL
        switch configuration {
            
        case .people(let peopleURL):
            url = peopleURL
        case .planets(let planetsURL):
            url = planetsURL
        case .starships(let starshipsURL):
            url = starshipsURL
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error {
                print("Ошибка: \(error.localizedDescription)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Заголовки: \(httpResponse.allHeaderFields)")
                print("Код ответа: \(httpResponse.statusCode)")
            }
            
            if let data, let stringData = String(data: data, encoding: .utf8) {
                print("Данные: \(stringData)")
                
            }
        }
        task.resume()
        
    }
}
