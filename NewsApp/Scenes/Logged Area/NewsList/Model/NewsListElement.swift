//
//  NewsListElement.swift
//  NewsApp
//
//  Created by Renê Xavier on 25/01/21.
//

import Foundation

// MARK: - NewsListElement
struct NewsListElement: Codable {
    var idDocumento, area, title, subtitle: String?
    var date, time: String?
    var url: URL?
    var image: URL?
    var source, author, authorImage: String?
    var mock:Bool = false
    

    enum CodingKeys: String, CodingKey {
        case idDocumento = "id_documento"
        case area = "chapeu"
        case title = "titulo"
        case subtitle = "linha_fina"
        case date = "data_hora_publicacao"
        case time, url, source
        case author = "credito"
        case image = "imagem"
        case authorImage = "imagem_credito"
    }
    
    init(mock: Bool) {
        self.mock = mock
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        idDocumento = try values.decodeIfPresent(String.self, forKey: .idDocumento)
        area = try values.decodeIfPresent(String.self, forKey: .area)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        subtitle = try values.decodeIfPresent(String.self, forKey: .subtitle)
        if let dateTime = try values.decodeIfPresent(String.self, forKey: .date) {
            date = Date.dateFormatter(date: dateTime)
            time = Date.timeFormatter(date: dateTime)
        } else {
            date = nil
            time = nil
        }
        source = try values.decodeIfPresent(String.self, forKey: .source)
        author = try values.decodeIfPresent(String.self, forKey: .author)
        authorImage = try values.decodeIfPresent(String.self, forKey: .authorImage)
        
        if let urlNews = try values.decodeIfPresent(String.self, forKey: .url) {
            url = URL(string: urlNews)
        } else {
            url = nil
        }
        
        if let urlImage = try values.decodeIfPresent(String.self, forKey: .image) {
            image = URL(string: urlImage)
        } else {
            image = nil
        }
        
    }
}
