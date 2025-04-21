class PokeapiClient < NetSystem::HttpClient

  def self.get_pokemon(name)
    url = "https://pokeapi.co/api/v2/pokemon/#{name}"
    get_json(url)
  end

  def self.get_pokemon_list(limit = 10, offset = 0)
    url = "https://pokeapi.co/api/v2/pokemon?limit=#{limit}&offset=#{offset}"
    get_json(url)
  end

end
