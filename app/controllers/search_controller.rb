require "openai"
require "json"

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
      { "type": "text", "text": "Return only a string of 5 scientific names separated by commas that are possible matches to the bird in the image"},
      { "type": "image_url",
        "image_url": {
          "url": "https://www.daysoftheyear.com/wp-content/uploads/bird-day-1.jpg",
        },
      }
    ]
    response = client.chat(
      parameters: {
          model: "gpt-4o", # Required.
          # response_format: { type: "string" },
          messages: [{ role: "user", content: messages}], # Required.
          temperature: 0.7,
      })
    # Receive JSON object and parse this response
    @ai_results = response.dig("choices", 0, "message", "content").split(',')





    # Determine whether we have in database.
    # If we have in database, return the bird
    # Else create new bird records
  end
end
