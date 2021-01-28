//
//  Constants.swift
//  NewsApp
//
//  Created by Renê Xavier on 26/01/21.
//

import Foundation
import UIKit

struct Constants {
    static let ok = "OK"
    static let erro = "Erro"
    static let atencao = "Atenção"
    static let unknownError = "Erro inesperado"
    static let serviceUnavailableError = "Serviço não disponível. 😅 Tente novamente mais tarde."
    static let notConnectedToInternet = "Você não está conectado a internet. Conecte-se e tente novamente."
    static let notFound = "Essa notícia não foi encontrada 🧐"
    
    static let loadingColor = UIColor(named: "Primary") ?? .black
    static let loadingBackgroundColor = UIColor(named: "Accent")?.withAlphaComponent(0.5) ?? .white
}
