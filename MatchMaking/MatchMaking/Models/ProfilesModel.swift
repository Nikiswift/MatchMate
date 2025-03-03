//
//  ProfilesModel.swift
//  MatchMaking
//
//  Created by Nikhil1 Desai on 28/02/25.
//

import Foundation

//MARK: Base Model
struct Base : Codable {
    var results : [Results]?
    let info : Info?

    enum CodingKeys: String, CodingKey {

        case results = "results"
        case info = "info"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        results = try values.decodeIfPresent([Results].self, forKey: .results)
        info = try values.decodeIfPresent(Info.self, forKey: .info)
    }

}

//MARK: Results Model
struct Results : Codable {
    let gender : String?
    let name : Name?
    let location : PersonLocation?
    let email : String?
    let login : Login?
    let dob : Dob?
    let phone : String?
    let cell : String?
    let id : Id?
    let picture : Picture?
    let nat : String?
    var selectionType: Int?
    
    enum CodingKeys: String, CodingKey {

        case gender = "gender"
        case name = "name"
        case location = "location"
        case email = "email"
        case login = "login"
        case dob = "dob"
        case phone = "phone"
        case cell = "cell"
        case id = "id"
        case picture = "picture"
        case nat = "nat"
        case selectionType = ""
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        gender = try values.decodeIfPresent(String.self, forKey: .gender)
        name = try values.decodeIfPresent(Name.self, forKey: .name)
        location = try values.decodeIfPresent(PersonLocation.self, forKey: .location)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        login = try values.decodeIfPresent(Login.self, forKey: .login)
        dob = try values.decodeIfPresent(Dob.self, forKey: .dob)
        phone = try values.decodeIfPresent(String.self, forKey: .phone)
        cell = try values.decodeIfPresent(String.self, forKey: .cell)
        id = try values.decodeIfPresent(Id.self, forKey: .id)
        picture = try values.decodeIfPresent(Picture.self, forKey: .picture)
        nat = try values.decodeIfPresent(String.self, forKey: .nat)
        selectionType = try values.decodeIfPresent(Int.self, forKey: .selectionType)
    }

}

//MARK: Login Model
struct Login : Codable {
    let uuid : String?
    let username : String?
    let password : String?
    let salt : String?
    let md5 : String?
    let sha1 : String?
    let sha256 : String?

    enum CodingKeys: String, CodingKey {

        case uuid = "uuid"
        case username = "username"
        case password = "password"
        case salt = "salt"
        case md5 = "md5"
        case sha1 = "sha1"
        case sha256 = "sha256"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        uuid = try values.decodeIfPresent(String.self, forKey: .uuid)
        username = try values.decodeIfPresent(String.self, forKey: .username)
        password = try values.decodeIfPresent(String.self, forKey: .password)
        salt = try values.decodeIfPresent(String.self, forKey: .salt)
        md5 = try values.decodeIfPresent(String.self, forKey: .md5)
        sha1 = try values.decodeIfPresent(String.self, forKey: .sha1)
        sha256 = try values.decodeIfPresent(String.self, forKey: .sha256)
    }

}

//MARK: Name Model
struct Name : Codable {
    let title : String?
    let first : String?
    let last : String?

    enum CodingKeys: String, CodingKey {

        case title = "title"
        case first = "first"
        case last = "last"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        first = try values.decodeIfPresent(String.self, forKey: .first)
        last = try values.decodeIfPresent(String.self, forKey: .last)
    }

}


//MARK: PersonLocation Model
struct PersonLocation : Codable {
    let city : String?
    let state : String?
    let country : String?

    enum CodingKeys: String, CodingKey {
        case city = "city"
        case state = "state"
        case country = "country"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        city = try values.decodeIfPresent(String.self, forKey: .city)
        state = try values.decodeIfPresent(String.self, forKey: .state)
        country = try values.decodeIfPresent(String.self, forKey: .country)
    }

}

//MARK: Picture Model
struct Picture : Codable {
    let large : String?
    let medium : String?
    let thumbnail : String?

    enum CodingKeys: String, CodingKey {

        case large = "large"
        case medium = "medium"
        case thumbnail = "thumbnail"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        large = try values.decodeIfPresent(String.self, forKey: .large)
        medium = try values.decodeIfPresent(String.self, forKey: .medium)
        thumbnail = try values.decodeIfPresent(String.self, forKey: .thumbnail)
    }

}

//MARK: Dob Model
struct Dob : Codable {
    let date : String?
    let age : Int?

    enum CodingKeys: String, CodingKey {

        case date = "date"
        case age = "age"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        date = try values.decodeIfPresent(String.self, forKey: .date)
        age = try values.decodeIfPresent(Int.self, forKey: .age)
    }

}

//MARK: Id Model
struct Id : Codable {
    let name : String?
    let value : String?

    enum CodingKeys: String, CodingKey {

        case name = "name"
        case value = "value"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        value = try values.decodeIfPresent(String.self, forKey: .value)
    }

}

//MARK: Info Model
struct Info : Codable {
    let seed : String?
    let results : Int?
    let page : Int?
    let version : String?

    enum CodingKeys: String, CodingKey {

        case seed = "seed"
        case results = "results"
        case page = "page"
        case version = "version"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        seed = try values.decodeIfPresent(String.self, forKey: .seed)
        results = try values.decodeIfPresent(Int.self, forKey: .results)
        page = try values.decodeIfPresent(Int.self, forKey: .page)
        version = try values.decodeIfPresent(String.self, forKey: .version)
    }

}
