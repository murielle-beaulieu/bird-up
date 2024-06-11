require "openai"
require 'wikipedia'
require 'json'

class SearchController < ApplicationController

  def new
    # Nothing being passed in
    # Use new view for image upload or keyword search
  end

  def results
    # Use OpenAI API for identification of bird
    client = OpenAI::Client.new(
      access_token: "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",
      log_errors: true # Highly recommended in development, so you can see what errors OpenAI is returning. Not recommended in production because it could leak private data to your logs.
    )

    messages = [
      { "type": "text", "text": "Return only an array of 5 JSON objects that are possible matches to the bird in the image. Each object has the following keys: species, scientific_name, habitat, distribution, description."},
      { "type": "image_url",
        "image_url": {
          "url": "https://www.daysoftheyear.com/wp-content/uploads/bird-day-1.jpg",
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

    if Bird.find_by(scientific_name: @hash["scientific_name"])
      @bird = Bird.find_by(scientific_name: @hash["scientific_name"])
    else
      @bird = Bird.new(
        species: @hash["species"],
        scientific_name: @hash["scientific_name"],
        habitat: @hash["habitat"],
        description: @hash["description"],
        distribution: @hash["distribution"]
      )
      @bird.save!
    end
    raise
    # Determine whether we have in database.
    # If we have in database, return the bird
    # Else create new bird records
  end
end
