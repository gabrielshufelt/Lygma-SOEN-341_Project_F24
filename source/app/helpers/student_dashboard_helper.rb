module StudentDashboardHelper
  def background_color_for_score(score)
    max_score = 7.0
    start_color = { r: 189, g: 38, b: 17 }
    end_color = { r: 2, g: 143, b: 0 }
    factor = compute_factor(score, max_score)

    rgb_color = interpolate_colors(start_color, end_color, factor)
    rgb_to_hex(rgb_color)
  end

  private

  def compute_factor(score, max_score)
    clamped_score = score.clamp(0, max_score)
    clamped_score.to_f / max_score
  end

  def interpolate_colors(start_color, end_color, factor)
    {
      r: interpolate_channel(start_color[:r], end_color[:r], factor),
      g: interpolate_channel(start_color[:g], end_color[:g], factor),
      b: interpolate_channel(start_color[:b], end_color[:b], factor)
    }
  end

  def interpolate_channel(start_value, end_value, factor)
    (start_value + factor * (end_value - start_value)).to_i
  end

  def rgb_to_hex(color)
    "##{color[:r].to_s(16).rjust(2, '0')}" \
    "#{color[:g].to_s(16).rjust(2, '0')}" \
    "#{color[:b].to_s(16).rjust(2, '0')}"
  end
end
