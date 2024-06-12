require "openai"
require 'wikipedia'
require 'json'
require 'open-uri'


class SearchController < ApplicationController

  def new
    # Nothing being passed in
    # Use new view for image upload or keyword search
  end

  def results
    # Use OpenAI API for identification of bird
    client = OpenAI::Client.new(
      access_token: ENV['OPENAI_API_KEY'],
      log_errors: true # Highly recommended in development, so you can see what errors OpenAI is returning. Not recommended in production because it could leak private data to your logs.
    )

    messages = [
      { "type": "text", "text": "Return the bird in the image as JSON with its species, scientific_name, habitat, distribution, description. Give me an array called 'birds' of 5 different JSON objects" },
      { "type": "image_url",
        "image_url": {
          "url": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRJ9SdSxAl3YkpSGgpoxipta6QlG7z63Ajs6w&s",
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
          audio_url: get_audio(suggestion["scientific_name"])
        )
        @bird.save!
        @birds_to_display << @bird
      end
    end

    # raise
    # Determine whether we have in database.
    # If we have in database, return the bird
    # Else create new bird records
  end

  private

  def get_audio(sci_name)

    url = "https://xeno-canto.org/api/2/recordings?query=#{sci_name}+q:A"
    query_result = URI.open(url).read
    xeno_response = JSON.parse(query_result)
    audio = xeno_response["recordings"][0]["id"]
    return audio
  end

end
