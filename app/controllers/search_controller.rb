require "openai"
require 'wikipedia'
require 'json'
require 'open-uri'

class SearchController < ApplicationController

  def new
    # Nothing being passed in
    # Use new view for image upload
  end


  def results
    @photo = Photo.last
    url = @photo.img.url

    # Use OpenAI API for identification of bird
    client = OpenAI::Client.new(
      access_token: ENV['OPENAI_API_KEY'],
      log_errors: true
    )

    messages = [
      { "type": "text", "text": "Return the bird in the image as JSON with its species, scientific_name, habitat, distribution, description" },
      { "type": "image_url",
        "image_url": {
          "url": url,
        },
      }
    ]

    @response = client.chat(
      parameters: {
          model: "gpt-4o", # Required.
          response_format: { type: "json_object" },
          messages: [{ role: "user", content: messages}], # Required.
          temperature: 0.7
      }
    )

    @ai_results = @response.dig("choices", 0, "message", "content")
    hash = JSON.load(@ai_results)

    if Bird.find_by(scientific_name: hash["scientific_name"])
      @bird = Bird.find_by(scientific_name: hash["scientific_name"])
    else
      @bird = Bird.new(
        species: hash["species"],
        scientific_name: hash["scientific_name"],
        habitat: hash["habitat"],
        description: hash["description"],
        distribution: hash["distribution"],
        audio_url: get_audio(hash["scientific_name"], hash["species"]),
        img_url: get_image(hash["scientific_name"])
      )
      @bird.save!
    end
  end

  private

  def get_audio(sci_name, species)
    sci_response = get_audio_object(sci_name)
    spec_response = get_audio_object(species)
    if sci_response["numRecordings"] != "0"
      audio = sci_response["recordings"][0]["id"]
    elsif spec_response["numRecordings"] != "0"
      audio = spec_response["recordings"][0]["id"]
    else
      audio = ""
    end
    return audio
  end

  def get_audio_object(name)
    query = name.split
    url = "https://xeno-canto.org/api/2/recordings?query="
    query.each do |item|
      url += "#{item}+"
    end
    url += "q:A"
    query_result = URI.open(url).read
    xeno_response = JSON.parse(query_result)
    return xeno_response
  end

  def get_image(sci_name)
    wiki_url = "https://en.wikipedia.org/w/api.php?action=query&prop=pageimages%7Cpageprops&format=json&piprop=thumbnail&titles=#{sci_name}&pithumbsize=300&redirects"
    wiki_serialized = URI.open(wiki_url).read
    wiki_data = JSON.parse(wiki_serialized)
    page_id = wiki_data["query"]["pages"].keys[0]

    if page_id == -1
      image_url = "/app/assets/images/fletchlingPokemon.webp"
    else
      image_url = wiki_data["query"]["pages"][page_id]["thumbnail"]["source"]
    end

    return image_url
  end

  def new_params
    params.require(:new).permit(:photo)
  end
end
