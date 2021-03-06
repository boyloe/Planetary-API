require 'pp'

Planet.destroy_all

def get_data
    response = RestClient.get("https://api.le-systeme-solaire.net/rest/bodies/")
    data = JSON.parse(response)
    planets =  data['bodies'].select do |body|
        body['isPlanet'] == true && !body['name'].match(/\d/) 
    end
    planets = planets.min_by(planets.length) {|planet| planet["perihelion"]}
    planets
end

def create_planets
    get_data.each do |planet|
        Planet.create(
            name: planet["englishName"], 
            moons: planet["moons"] ? planet["moons"].length : 0, 
            diameter: (planet["meanRadius"]*2), 
            gravity: (planet["gravity"]/9.8).round(2),
            perihelion: planet["perihelion"])
    end
end

create_planets