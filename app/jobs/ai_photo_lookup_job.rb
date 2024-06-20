class AiPhotoLookupJob < ApplicationJob
  queue_as :default

  def perform(search_result)
    # Use OpenAI API for identification of bird
    client = OpenAI::Client.new(
      access_token: ENV['OPENAI_API_KEY'],
      log_errors: true
    )

    messages = [
      { "type": "text", "text": "Return the bird in the image as JSON with its species, scientific_name, habitat, distribution, description, score (based on rarity out of 100). Create an array 'birds' of 3 related JSON objects." },
      { "type": "image_url",
        "image_url": {
          "url": search_result.photo.img.url,
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
    @hash = JSON.load(@ai_results)

    suggestions = @hash["birds"]

    suggestions.each do |suggestion|
      if Bird.find_by(scientific_name: suggestion["scientific_name"])
        bird = Bird.find_by(scientific_name: suggestion["scientific_name"])
      else
        bird = create_bird(suggestion)
      end
      # Create link between bird suggestions and search result
      SearchResultBird.create!(bird: bird, search_result: search_result)
    end
    search_result.update!(status: :success)
  rescue => e
    puts "=============== ERROR ==============="
    puts e
    search_result.update(status: :failed)
  end

  private

  def create_bird(suggestion)
    Bird.create!(
      species: suggestion["species"],
      scientific_name: suggestion["scientific_name"],
      habitat: suggestion["habitat"],
      description: suggestion["description"],
      distribution: suggestion["distribution"],
      audio_url: get_audio(suggestion["scientific_name"], suggestion["species"]),
      img_url: get_image(suggestion["scientific_name"]),
      score: suggestion["score"]
    )
  end

  def get_audio(sci_name, species)
    sci_response = get_audio_object(sci_name)
    spec_response = get_audio_object(species)
    if sci_response["numRecordings"] != "0"
      audio = "https://xeno-canto.org/#{sci_response['recordings'][0]['id']}/embed?simple=1"
    elsif spec_response["numRecordings"] != "0"
      audio = "https://xeno-canto.org/#{spec_response['recordings'][0]['id']}/embed?simple=1"
    else
      audio = nil
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
end
