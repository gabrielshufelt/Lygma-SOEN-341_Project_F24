class EvaluationsController < ApplicationController
  require 'net/http'
  require 'uri'
  require 'json'

  def generate_feedback
    slider_values = feedback_params
    feedback = generate_ai_feedback(slider_values)

    render json: { feedback: feedback }
  end

  private

  def feedback_params
    params.require(:slider_values).permit(:cooperation_rating, :conceptual_rating, :practical_rating,
                                          :work_ethic_rating)
  end

  def generate_ai_feedback(slider_values)
    # Convert ActionController::Parameters to hash
    ratings = slider_values.to_h

    prompt = <<~PROMPT
      You are an academic evaluator. Generate concise, general feedback for each criterion based on the numerical ratings (0-7 scale).
      - 0-1: Needs significant improvement
      - 2-3: Below expectations
      - 4-5: Meets expectations
      - 6-7: Exceeds expectations

      Always use this exact structure and keep each line under 15 words:
      Cooperation: [feedback about teamwork and communication]
      Conceptual Understanding: [feedback about theoretical knowledge]
      Practical Skills: [feedback about hands-on capabilities]
      Work Ethic: [feedback about dedication and reliability]

      Current ratings:
      #{ratings.map { |criterion, value| "#{criterion.humanize}: #{value}/7" }.join("\n")}

      Generate feedback following the exact structure above:
    PROMPT

    # Call the Hugging Face API (Text Generation Endpoint)
    uri = URI('https://api-inference.huggingface.co/models/mistralai/Mixtral-8x7B-Instruct-v0.1')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri)
    request['Authorization'] = "Bearer #{ENV['HUGGING_FACE_API_TOKEN']}"
    request['Content-Type'] = 'application/json'
    request.body = { inputs: prompt }.to_json

    response = http.request(request)

    return 'Could not generate feedback at this time.' unless response.code == '200'

    result = JSON.parse(response.body)
    unless result.is_a?(Array) && result[0].is_a?(Hash) && result[0]['generated_text']
      return 'Could not generate feedback at this time.'
    end

    generated_text = result[0]['generated_text'].sub(prompt, '').strip
    generated_text.presence || 'Could not generate feedback at this time.'
  rescue StandardError
    'Could not generate feedback at this time.'
  end
end
