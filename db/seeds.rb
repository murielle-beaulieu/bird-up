# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require "openai"
require 'wikipedia'
require 'json'
require 'open-uri'
require 'faker'

# Defined methods for seed:
seed_start = Time.new
puts seed_start

def get_audio(sci_name, species)
  sci_response = get_audio_object(sci_name)
  spec_response = get_audio_object(species)
  if sci_response["numRecordings"] != "0"
    audio = "https://xeno-canto.org/#{sci_response['recordings'][0]['id']}/embed?simple=1"
  elsif spec_response["numRecordings"] != "0"
    audio = "https://xeno-canto.org/#{spec_response['recordings'][0]['id']}/embed?simple=1"
  else
    audio = "Audio file not available"
  end
  return audio
end

def get_audio_object(name)
  query = name.downcase.delete('^a-z ').split
  xeno_url = "https://xeno-canto.org/api/2/recordings?query="
  xeno_url += "#{query[0]}+#{query[1]}+q:A"
  # query.each do |item|
  #   xeno_url += "#{item}+"
  # end
  # xeno_url += "q:A"
  query_result = URI.open(xeno_url).read
  xeno_response = JSON.parse(query_result)
  return xeno_response
end

def get_image(sci_name)
  wiki_url = "https://en.wikipedia.org/w/api.php?action=query&prop=pageimages%7Cpageprops&format=json&piprop=thumbnail&titles=#{sci_name}&pithumbsize=300&redirects"
  wiki_serialized = URI.open(wiki_url).read
  wiki_data = JSON.parse(wiki_serialized)
  page_id = wiki_data["query"]["pages"].keys[0]

  if page_id == -1
    image_url = "/app/assets/images/fletchlingPokemon.png"
  else
    image_url = wiki_data["query"]["pages"][page_id]["thumbnail"]["source"]
  end

  return image_url
end

# User database seed
puts "Adding fake users..."

3.times do
  user = User.new(
    username: "#{Faker::Artist.name}_wing",
    email: Faker::Internet.email(domain: 'gmail.com'),
    password: "88888888"
  )
  user.save!
end

3.times do
  user = User.new(
    username: "#{Faker::Ancient.hero}_bird",
    email: Faker::Internet.email(domain: 'gmail.com'),
    password: "88888888"
  )
  user.save!
end

3.times do
  user = User.new(
    username: "#{Faker::Beer.hop}_nest",
    email: Faker::Internet.email(domain: 'gmail.com'),
    password: "88888888"
  )
  user.save!
end

3.times do
  user = User.new(
    username: "#{Faker::Computer.platform}_hawk",
    email: Faker::Internet.email(domain: 'gmail.com'),
    password: "88888888"
  )
  user.save!
end

puts "Adding real users..."

user = User.new(
  username: "BigBirdBob",
  email: "bob@gmail.com",
  password: "bob123"
)
user.save!

user = User.new(
  username: "SpotMaster",
  email: "john@gmail.com",
  password: "john123"
)
user.save!

user = User.new(
  username: "Utes&Birds",
  email: "utes@gmail.com",
  password: "utes123"
)
user.save!

# 3.times do
#   user = User.new(
#     username: "#{Faker::DcComics.hero}_talon",
#     email: Faker::Internet.email(domain: 'gmail.com'),
#     password: "88888888"
#   )
#   user.save!
# end

puts "15 users created!"


# Bird database seed
puts "Building Bird database..."

@array = [
  {
    "species": "Emu",
    "scientific_name": "Dromaius novaehollandiae",
    "habitat": "Woodlands, open forests, grasslands",
    "distribution": "Australia",
    "description": "The Emu is a flightless bird, the second-largest living bird by height, native to Australia.",
    "score": 75
  },
  {
    "species": "Sulphur-crested Cockatoo",
    "scientific_name": "Cacatua galerita",
    "habitat": "Forests, woodlands, and urban areas",
    "distribution": "Australia, New Guinea, Indonesia",
    "description": "A large, white parrot with a distinctive sulphur-yellow crest.",
    "score": 60
  },
  {
    "species": "Night Parrot",
    "scientific_name": "Pezoporus occidentalis",
    "habitat": "Arid and semi-arid grasslands",
    "distribution": "Australia",
    "description": "A rare and elusive bird, known for its nocturnal habits and unique, camouflaged plumage.",
    "score": 95
  },
  {
    "species": "Satin Bowerbird",
    "scientific_name": "Ptilonorhynchus violaceus",
    "habitat": "Rainforests and eucalyptus forests",
    "distribution": "Eastern Australia",
    "description": "Known for the male's striking blue-black plumage and elaborate bower-building behavior.",
    "score": 65
  },
  {
    "species": "Red Wattlebird",
    "scientific_name": "Anthochaera carunculata",
    "habitat": "Woodlands, forests, and urban areas",
    "distribution": "Southern Australia",
    "description": "A large, noisy honeyeater with distinctive red wattles on the sides of its neck.",
    "score": 50
  },
  {
    "species": "Silvereye",
    "scientific_name": "Zosterops lateralis",
    "habitat": "Woodlands, gardens, and forests",
    "distribution": "Australia, New Zealand",
    "description": "A small bird with a conspicuous white eye-ring, often seen in flocks.",
    "score": 40
  },
  {
    "species": "Azure Kingfisher",
    "scientific_name": "Alcedo azurea",
    "habitat": "Freshwater rivers, streams, and lakes",
    "distribution": "Australia, New Guinea",
    "description": "A small kingfisher with striking blue and orange plumage, often seen near water.",
    "score": 70
  },
  {
    "species": "Budgerigar",
    "scientific_name": "Melopsittacus undulatus",
    "habitat": "Open woodlands, grasslands, and arid zones",
    "distribution": "Australia",
    "description": "A small, colorful parrot known for its popularity as a pet worldwide.",
    "score": 55
  },
  {
    "species": "Australian Raven",
    "scientific_name": "Corvus coronoides",
    "habitat": "Woodlands, forests, and urban areas",
    "distribution": "Eastern and southern Australia",
    "description": "A large, intelligent bird with glossy black plumage and a distinctive call.",
    "score": 45
  },
  {
    "species": "Green Peafowl",
    "scientific_name": "Pavo muticus",
    "habitat": "Forests, grasslands, and riverbanks",
    "distribution": "Southeast Asia",
    "description": "A large, colorful bird known for the male's impressive tail display.",
    "score": 85
  },
  {
    "species": "Oriental Cuckoo",
    "scientific_name": "Cuculus optatus",
    "habitat": "Forests, woodlands, and scrublands",
    "distribution": "Asia, Australia (non-breeding)",
    "description": "A slender, secretive bird known for its distinctive call and brood parasitism.",
    "score": 60
  },
  {
    "species": "Magpie-lark",
    "scientific_name": "Grallina cyanoleuca",
    "habitat": "Open forests, grasslands, and urban areas",
    "distribution": "Australia, New Guinea",
    "description": "A medium-sized bird with striking black-and-white plumage and a loud, melodious song.",
    "score": 50
  },
  {
    "species": "New Zealand Bellbird",
    "scientific_name": "Anthornis melanura",
    "habitat": "Forests, scrublands, and gardens",
    "distribution": "New Zealand",
    "description": "A small, greenish bird known for its beautiful, bell-like song.",
    "score": 55
  },
  {
    "species": "Kakapo",
    "scientific_name": "Strigops habroptilus",
    "habitat": "Forests",
    "distribution": "New Zealand (restricted islands)",
    "description": "A large, nocturnal parrot that is flightless and critically endangered.",
    "score": 97
  },
  {
    "species": "Australian Brush-turkey",
    "scientific_name": "Alectura lathami",
    "habitat": "Rainforests and woodlands",
    "distribution": "Eastern Australia",
    "description": "A large bird known for its mound-building nesting behavior and bald, red head.",
    "score": 50
  },
  {
    "species": "Hoary-headed Grebe",
    "scientific_name": "Poliocephalus poliocephalus",
    "habitat": "Lakes, ponds, and wetlands",
    "distribution": "Australia, New Zealand",
    "description": "A small waterbird with distinctive silvery-white streaked head.",
    "score": 65
  },
  {
    "species": "Laughing Kookaburra",
    "scientific_name": "Dacelo novaeguineae",
    "habitat": "Woodlands, forests, and urban areas",
    "distribution": "Australia, New Guinea",
    "description": "A large kingfisher known for its distinctive laughing call.",
    "score": 55
  },
  {
    "species": "Common Bronzewing",
    "scientific_name": "Phaps chalcoptera",
    "habitat": "Open woodlands, forests, and scrublands",
    "distribution": "Australia",
    "description": "A medium-sized pigeon with striking bronze-green wing patches.",
    "score": 50
  },
  {
    "species": "Yellow-faced Honeyeater",
    "scientific_name": "Lichenostomus melanops",
    "habitat": "Forests, woodlands, and gardens",
    "distribution": "Eastern Australia",
    "description": "A medium-sized honeyeater with a distinctive yellow stripe on its face.",
    "score": 45
  },
  {
    "species": "Hooded Pitta",
    "scientific_name": "Pitta sordida",
    "habitat": "Forests, mangroves, and plantations",
    "distribution": "Southeast Asia, New Guinea, Northern Australia",
    "description": "A striking bird with a vivid green body, black head, and red underparts.",
    "score": 70
  },
  {
    "species": "Australian Magpie",
    "scientific_name": "Gymnorhina tibicen",
    "habitat": "Open forests, grasslands, urban areas",
    "distribution": "Australia, New Guinea",
    "description": "A highly intelligent bird known for its warbling song and striking black-and-white plumage.",
    "score": 35
  },
  {
    "species": "Kea",
    "scientific_name": "Nestor notabilis",
    "habitat": "Alpine regions, forests",
    "distribution": "New Zealand",
    "description": "A large, intelligent parrot known for its curiosity and playful behavior.",
    "score": 80
  },
  {
    "species": "Common Myna",
    "scientific_name": "Acridotheres tristis",
    "habitat": "Urban areas, farmlands, forests",
    "distribution": "Asia, Australia, and Pacific islands",
    "description": "An adaptive bird known for its loud calls and mimicry.",
    "score": 40
  },
  {
    "species": "Australian Shelduck",
    "scientific_name": "Tadorna tadornoides",
    "habitat": "Lakes, rivers, wetlands",
    "distribution": "Australia",
    "description": "A large, colorful duck known for its striking plumage and loud, honking call.",
    "score": 50
  },
  {
    "species": "Akiapolaau",
    "scientific_name": "Hemignathus wilsoni",
    "habitat": "Forests",
    "distribution": "Hawaii",
    "description": "A rare Hawaiian honeycreeper with a distinctive curved bill used to extract insects from tree bark.",
    "score": 90
  },
  {
    "species": "Red-flanked Lorikeet",
    "scientific_name": "Charmosyna placentis",
    "habitat": "Lowland forests",
    "distribution": "New Guinea, islands in the Pacific",
    "description": "A small, colorful parrot known for its vibrant plumage and acrobatic feeding behavior.",
    "score": 65
  },
  {
    "species": "Masked Owl",
    "scientific_name": "Tyto novaehollandiae",
    "habitat": "Woodlands, forests, farmlands",
    "distribution": "Australia, New Guinea",
    "description": "A medium-sized owl known for its heart-shaped face and predatory skills.",
    "score": 70
  },
  {
    "species": "Southern Brown Kiwi",
    "scientific_name": "Apteryx australis",
    "habitat": "Forests, scrublands",
    "distribution": "New Zealand",
    "description": "A flightless, nocturnal bird with a long beak, known as the national symbol of New Zealand.",
    "score": 85
  },
  {
    "species": "Satin Flycatcher",
    "scientific_name": "Myiagra cyanoleuca",
    "habitat": "Woodlands, forests",
    "distribution": "Australia, New Guinea",
    "description": "A small, insectivorous bird with striking blue-black plumage in males.",
    "score": 55
  },
  {
    "species": "Little Penguin",
    "scientific_name": "Eudyptula minor",
    "habitat": "Coastal waters and islands",
    "distribution": "Australia, New Zealand",
    "description": "The smallest species of penguin, known for its blue and white plumage and nocturnal habits.",
    "score": 75
  },
  {
    "species": "Pied Cormorant",
    "scientific_name": "Phalacrocorax varius",
    "habitat": "Coastal waters, lakes, rivers",
    "distribution": "Australia, New Zealand",
    "description": "A large waterbird known for its black-and-white plumage and diving ability.",
    "score": 45
  },
  {
    "species": "Noisy Miner",
    "scientific_name": "Manorina melanocephala",
    "habitat": "Woodlands, urban areas",
    "distribution": "Eastern Australia",
    "description": "A highly social bird known for its noisy calls and aggressive behavior towards other birds.",
    "score": 30
  },
  {
    "species": "Eastern Yellow Robin",
    "scientific_name": "Eopsaltria australis",
    "habitat": "Forests, woodlands, gardens",
    "distribution": "Eastern Australia",
    "description": "A small bird with bright yellow underparts and an inquisitive nature.",
    "score": 55
  },
  {
    "species": "Sacred Kingfisher",
    "scientific_name": "Todiramphus sanctus",
    "habitat": "Forests, mangroves, coastal areas",
    "distribution": "Australia, New Zealand, Pacific islands",
    "description": "A medium-sized kingfisher with striking blue and white plumage.",
    "score": 50
  }
]

puts "Populating database with unique bird data..."

@array.each do |bird|
  # if Bird.find_by(scientific_name: bird["scientific_name"])
  #   @bird = Bird.find_by(scientific_name: bird["scientific_name"])
  #   @birds_to_display << @bird
  # else
    @bird = Bird.new(
      species: bird[:species],
      scientific_name: bird[:scientific_name],
      habitat: bird[:habitat],
      description: bird[:description],
      distribution: bird[:distribution],
      audio_url: get_audio(bird[:scientific_name], bird[:species]),
      img_url: get_image(bird[:scientific_name]),
      score: bird[:score]
    )
    @bird.save!
    puts "Added #{bird[:species]}"
  # end
end

puts "Bird database build complete!"

# Spotting database seed
puts "Creating bird spottings..."
@parks = [
  "Blue Mountains National Park",
  "Royal National Park",
  "Kosciuszko National Park",
  "Dorrigo National Park",
  "Barrington Tops National Park",
  "Wollemi National Park",
  "Mungo National Park",
  "Mutawintji National Park",
  "Myall Lakes National Park",
  "Ku-ring-gai Chase National Park",
  "Bouddi National Park",
  "Morton National Park",
  "Yuraygir National Park",
  "Wyrrabalong National Park",
  "Tapin Tops National Park",
  "Willandra National Park",
  "Washpool National Park",
  "Warrumbungle National Park",
  "Hat Head National Park",
  "Crowdy Bay National Park",
  "Mount Warning National Park",
  "Glass House Mountains National Park",
  "Lamington National Park",
  "Springbrook National Park",
  "Daintree National Park",
  "Great Sandy National Park",
  "Eungella National Park",
  "Girraween National Park",
  "Carnarvon National Park",
  "Fraser Island (K'gari) National Park",
  "Conondale National Park",
  "Noosa National Park",
  "Coochin Creek National Park",
  "Tamborine National Park",
  "Hinchinbrook Island National Park",
  "Cape Hillsborough National Park",
  "Whitsunday Islands National Park",
  "Magnetic Island National Park",
  "Tully Gorge National Park",
  "Kuranda National Park",
  "Barron Gorge National Park",
  "Millstream Falls National Park",
  "Undara Volcanic National Park",
  "Bowling Green Bay National Park",
  "D'Aguilar National Park",
  "Bunya Mountains National Park",
  "St Helena Island National Park",
  "Girramay National Park",
  "Kutini-Payamu (Iron Range) National Park",
  "Lizard Island National Park",
  "Keppel Bay Islands National Park",
  "Capricorn Coast National Park",
  "Mount Archer National Park",
  "Eurimbula National Park",
  "Deepwater National Park",
  "Curtis Island National Park",
  "Byfield National Park",
  "Blackdown Tableland National Park",
  "Carnarvon Gorge National Park",
  "Daydream Island National Park",
  "Whitsunday Islands National Park",
  "Noah Beach National Park",
  "Russell River National Park",
  "Davies Creek National Park",
  "Chillagoe-Mungana Caves National Park",
  "Mount Lewis National Park",
  "Lamb Range National Park",
  "Rinyirru (Lakefield) National Park",
  "Eastern Cape York Peninsula National Park",
  "Albinia National Park",
  "White Mountains National Park",
  "Cape Upstart National Park",
  "Girringun National Park",
  "Hinchinbrook National Park",
  "Magnetic Island National Park",
  "Cairns Highlands National Park",
  "Atherton Tablelands National Park",
  "Paluma Range National Park",
  "Townsville Town Common Conservation Park",
  "Eungella National Park",
  "Cape Tribulation National Park",
  "Mossman Gorge National Park",
  "Mitchell River National Park",
  "Lawn Hill (Boodjamulla) National Park",
  "Ravensbourne National Park",
  "Mount Barney National Park",
  "Gondwana Rainforests of Australia (multi-location UNESCO site)",
  "Border Ranges National Park",
  "Nightcap National Park",
  "Wollumbin National Park",
  "Coombabah Lakelands Conservation Area",
  "Tamborine Mountain National Park",
  "Brisbane Forest Park",
  "Girraween National Park"
]
@dates = [
  "2024-05-15", "2024-05-16", "2024-05-17", "2024-05-18", "2024-05-19",
  "2024-05-20", "2024-05-21", "2024-05-22", "2024-05-23", "2024-05-24",
  "2024-05-25", "2024-05-26", "2024-05-27", "2024-05-28", "2024-05-29",
  "2024-05-30", "2024-05-31", "2024-06-01", "2024-06-02", "2024-06-03",
  "2024-06-04", "2024-06-05", "2024-06-06", "2024-06-07", "2024-06-08",
  "2024-06-09", "2024-06-10", "2024-06-11", "2024-06-12", "2024-06-13",
  "2024-06-14", "2024-06-15"
]
@bird_spots = [1, 2, 3, 4, 5, 6, 7, 8, 10, 11, 12, 13, 14, 16, 18].shuffle
@user_array = (1...15).to_a

@user_array.each do |user_num|
  spots = @bird_spots[(user_num - 1)]
  spots.times do |i|
    spotting = Spotting.new(
      date: @dates.sample,
      location: @parks.sample,
      bird_id: (i + 1),
      user_id: user_num
    )
    spotting.save!
  end
end

puts "Spottings initialized!"

# Chatroom seed
puts "Creating a chatroom..."
Chatroom.create!(name: "The Nest")
puts "Chatroom ready! :)"

puts "SEED COMPLETE --- BIRDUP!"
seed_end = Time.new
puts "Total time to seed: #{seed_end - seed_start} seconds"
