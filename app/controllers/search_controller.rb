require "openai"
<<<<<<< HEAD
require "json"
require 'wikipedia'
=======
require 'wikipedia'
require 'json'
>>>>>>> d5ccd449f96c525bcc80b919ed469f944a5e5f80

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
      { "type": "text", "text": "Return the bird in the image as JSON with its species, scientific_name, habitat, distribution, description. Give me 5 suggestions."},
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

    @hash["suggestions"].each do |suggestion|
      if Bird.find_by(scientific_name: suggestion["scientific_name"])
        @bird = Bird.find_by(scientific_name: suggestion["scientific_name"])
      else
        @bird = Bird.new(
          species: suggestion["species"],
          scientific_name: suggestion["scientific_name"],
          habitat: suggestion["habitat"],
          description: suggestion["description"],
          distribution: suggestion["distribution"]
        )
        @bird.save!
      end
    end

    raise
    # Determine whether we have in database.
    # If we have in database, return the bird
    # Else create new bird records
  end
end
