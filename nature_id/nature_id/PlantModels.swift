import Foundation

struct PlantIdentificationResponse: Decodable {
    var accessToken: String
    var modelVersion: String
    var input: InputData
    var result: PlantResult

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case modelVersion = "model_version"
        case input, result
    }
}

struct InputData: Decodable {
    var images: [String]
}

struct PlantResult: Decodable {
    var classification: Classification
}


struct Classification: Decodable {
    var suggestions: [Suggestion]
}

struct Suggestion: Decodable {
    var id: String
    var name: String
    var probability: Double
    var similarImages: [SimilarImage]?
    var details: PlantDetails
}

struct SimilarImage: Decodable {
    var id: String
    var url: String
    var licenseName: String?
    var licenseUrl: String?
    var citation: String?
    var similarity: Double
    var urlSmall: String

    enum CodingKeys: String, CodingKey {
        case id, url, licenseName = "license_name", licenseUrl = "license_url", citation, similarity, urlSmall = "url_small"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        url = try container.decode(String.self, forKey: .url)
        licenseName = try container.decodeIfPresent(String.self, forKey: .licenseName)
        licenseUrl = try container.decodeIfPresent(String.self, forKey: .licenseUrl)
        citation = try container.decodeIfPresent(String.self, forKey: .citation)
        similarity = try container.decode(Double.self, forKey: .similarity)
        urlSmall = try container.decode(String.self, forKey: .urlSmall)
    }
}

struct PlantDetails: Decodable {
    var commonNames: [String]?
    var taxonomy: Taxonomy?
    var url: String?
    var gbifId: Int?
    var inaturalistId: Int?
    var rank: String?
    var description: Description?
    var synonyms: [String]?
    var image: Image?
    var edibleParts: [String]?
    var propagationMethods: [String]?

    enum CodingKeys: String, CodingKey {
        case commonNames = "common_names", taxonomy, url, gbifId = "gbif_id", inaturalistId = "inaturalist_id", rank, description, synonyms, image, edibleParts = "edible_parts", propagationMethods = "propagation_methods"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        commonNames = try container.decodeIfPresent([String].self, forKey: .commonNames)
        taxonomy = try container.decodeIfPresent(Taxonomy.self, forKey: .taxonomy)
        url = try container.decodeIfPresent(String.self, forKey: .url)
        gbifId = try container.decodeIfPresent(Int.self, forKey: .gbifId)
        inaturalistId = try container.decodeIfPresent(Int.self, forKey: .inaturalistId)
        rank = try container.decodeIfPresent(String.self, forKey: .rank)
        description = try container.decodeIfPresent(Description.self, forKey: .description)
        synonyms = try container.decodeIfPresent([String].self, forKey: .synonyms)
        image = try container.decodeIfPresent(Image.self, forKey: .image)
        edibleParts = try container.decodeIfPresent([String].self, forKey: .edibleParts)
        propagationMethods = try container.decodeIfPresent([String].self, forKey: .propagationMethods)
    }
}

struct Taxonomy: Decodable {
    var genus: String?
    var order: String?
    var family: String?
    var phylum: String?
    var kingdom: String?
}

struct Description: Decodable {
    var value: String?
    var citation: String?
    var licenseName: String?
    var licenseUrl: String?
}

struct Image: Decodable {
    var value: String?
    var citation: String?
    var licenseName: String?
    var licenseUrl: String?

    enum CodingKeys: String, CodingKey {
        case value, citation, licenseName = "license_name", licenseUrl = "license_url"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        value = try container.decodeIfPresent(String.self, forKey: .value)
        citation = try container.decodeIfPresent(String.self, forKey: .citation)
        licenseName = try container.decodeIfPresent(String.self, forKey: .licenseName)
        licenseUrl = try container.decodeIfPresent(String.self, forKey: .licenseUrl)
    }
}
