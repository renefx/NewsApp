//
//  NewsDetailWrapper.swift
//  NewsApp
//
//  Created by Renê Xavier on 27/01/21.
//

import Foundation

// MARK: - NewsDetailWrapperElement
struct NewsDetailWrapperElement: Codable {
    var documento: Documento?
}

// MARK: - Documento
struct Documento: Codable {
    var url: String?
    var source, produto, editoria, subeditoria: String?
    var titulo, credito, datapub, horapub: String?
    var linhafina: String?
    var imagem, thumbnail: String?
    var creditoImagem, legendaImagem, origem, id: String?
    var corpoformatado: String?
    
    var urlFormatted: URL? {
        return URL(string: imagem ?? "")
    }
    
    var creditoImagemFormatted: String {
        return "(Imagem: \(creditoImagem ?? ""))"
    }
    
    var creditoFormatted: String {
        return "Por: \(credito ?? "")"
    }
    
    var dataFormatted: String {
        return "\(datapub ?? "") \(horapub ?? "")"
    }
}
