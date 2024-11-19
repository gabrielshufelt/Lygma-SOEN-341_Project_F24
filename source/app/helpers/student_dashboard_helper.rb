module StudentDashboardHelper
  def background_color_for_score(score)
    max_score = 7.0
    start_color = { r: 189, g: 38, b: 17 }
    end_color = { r: 2, g: 143, b: 0 }
    score = score.clamp(0, max_score)
    factor = score.to_f / max_score
    r = (start_color[:r] + factor * (end_color[:r] - start_color[:r])).to_i
    g = (start_color[:g] + factor * (end_color[:g] - start_color[:g])).to_i
    b = (start_color[:b] + factor * (end_color[:b] - start_color[:b])).to_i

    "##{r.to_s(16).rjust(2, '0')}#{g.to_s(16).rjust(2, '0')}#{b.to_s(16).rjust(2, '0')}"
  end
end
