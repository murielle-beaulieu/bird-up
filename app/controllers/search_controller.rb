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
    # @photo = Photo.last
    # url = @photo.img.url

    # Use OpenAI API for identification of bird
    client = OpenAI::Client.new(
      access_token: ENV['OPENAI_API_KEY'],
      log_errors: true
    )

    messages = [
      { "type": "text", "text": "Return the bird in the image as JSON with its species, scientific_name, habitat, distribution, description. Give me an array called 'birds' of 5 different JSON objects related to the bird in the image" },
      { "type": "image_url",
        "image_url": {
          "url": "https://upload.wikimedia.org/wikipedia/commons/9/9b/Laughing_kookaburra_dec08_02.jpg",
        },
      }
    ]

    @response = client.chat(
      parameters: {
          model: "gpt-4o", # Required.
          response_format: { type: "json_object" },
          messages: [{ role: "user", content: messages}], # Required.
          temperature: 0.7
      })
    # Receive JSON object and parse this response
    # response.content = response.content.replace(/```json\n?|```/g, '');
    @ai_results = @response.dig("choices", 0, "message", "content")
    @hash = JSON.load(@ai_results)

    @birds_to_display = []

    @hash["birds"].each do |suggestion|
      if Bird.find_by(scientific_name: suggestion["scientific_name"])
        @bird = Bird.find_by(scientific_name: suggestion["scientific_name"])
        @birds_to_display << @bird
      else
        @bird = Bird.new(
          species: suggestion["species"],
          scientific_name: suggestion["scientific_name"],
          habitat: suggestion["habitat"],
          description: suggestion["description"],
          distribution: suggestion["distribution"],
          audio_url: "audio.mp3",# get_audio(suggestion["scientific_name"]),
          img_url: get_image(suggestion["scientific_name"])
        )
        @bird.save!
        @birds_to_display << @bird
      end

      @main_bird = @birds_to_display[0]
      @other_birds = @birds_to_display[1..-1]
    end

    # Determine whether we have in database.
    # If zwe have in database, return the bird
    # Else create new bird records
  end

  private

  def new_params
    params.require(:new).permit(:photo)
  end

  def get_audio(sci_name)
    query = sci_name.split
    url = "https://xeno-canto.org/api/2/recordings?query=#{query[0]}+#{query[1]}+q:A"
    query_result = URI.open(url).read
    xeno_response = JSON.parse(query_result)
    audio = xeno_response["recordings"][0]["id"]
    return audio
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

end
