class LearningInsightsService
  require 'net/http'
  require 'uri'
  require 'json'

  def initialize(evaluation_data)
    @evaluation_data = evaluation_data
  end

  def generate_insights
    prompt = build_prompt
    call_ai_model(prompt)
  end

  private

  def build_prompt
    prompt = <<~PROMPT
      As an experienced academic advisor, your task is to analyze a student's performance based on peer evaluations. You will be provided with evaluation data for the student across different projects. Your analysis should:

      **Please structure your response with the following headings:**

      1. **Overview**
      2. **Strengths**
      3. **Areas for Improvement**
      4. **Actionable Suggestions**

      **Evaluation Data:**
    PROMPT

    @evaluation_data.each do |data|
      prompt += <<~DATA
        Project: #{data[:project_title]}
        Date: #{data[:date_completed]&.strftime('%B %d, %Y')}
        Average Ratings (out of 7):
          - Cooperation: #{data[:avg_cooperation]}/7
          - Conceptual Understanding: #{data[:avg_conceptual]}/7
          - Practical Skills: #{data[:avg_practical]}/7
          - Work Ethic: #{data[:avg_work_ethic]}/7
      DATA
    end

    prompt += <<~INSTRUCTION

      Please provide your analysis now, following the structure outlined above. Be concise (maximum 100 words), focus on providing valuable insights, and do not include any introductory or concluding remarks.

    INSTRUCTION

    prompt
  end

  def call_ai_model(prompt)
    uri = URI('https://api-inference.huggingface.co/models/mistralai/Mixtral-8x7B-Instruct-v0.1')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri)
    request['Authorization'] = "Bearer #{ENV['HUGGING_FACE_API_TOKEN']}"
    request['Content-Type'] = 'application/json'
    request.body = { inputs: prompt, parameters: { max_new_tokens: 500 } }.to_json

    response = http.request(request)

    if response.code == '200'
      result = JSON.parse(response.body)
      if result.is_a?(Array) && result[0].is_a?(Hash) && result[0]['generated_text']
        generated_text = result[0]['generated_text'].sub(prompt, '').strip
        return format_insights(generated_text) if generated_text.present?
      end
    end

    'Could not generate insights at this time.'
  rescue StandardError
    'Could not generate insights at this time.'
  end

  def format_insights(raw_text)
    sections = raw_text.split(/\*\*(\d+\.\s+[^*]+)\*\*/)
    formatted_html = ''

    sections.each_with_index do |content, index|
      if index.odd? # Section headers
        formatted_html += "<p><strong>#{content}</strong></p>"
      elsif index.positive? # Section content
        # Split content into paragraphs and format them
        paragraphs = content.strip.split("\n\n")
        paragraphs.each do |para|
          if para.include?('- ')
            # Convert bullet points to list
            items = para.split('- ').reject(&:empty?)
            formatted_html += '<ul>'
            items.each do |item|
              formatted_html += "<li>#{item.strip}</li>"
            end
            formatted_html += '</ul>'
          else
            formatted_html += "<p>#{para.strip}</p>"
          end
        end
      end
    end

    formatted_html
  end
end
