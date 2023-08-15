module Admin::SeasonsHelper
  def have_seasons_gap?(seasons)
    result = false
    seasons.each_with_index do |s, index|
      sf = (s.sfm.to_i + (s.sfd.to_f / 30)).round(2)
      next_ss = if (index + 1) < seasons.count
        (seasons[index + 1].ssm.to_i + (seasons[index + 1].ssd.to_f / 30)).round(2)
      else
        (seasons[0].ssm.to_i + (seasons[0].ssd.to_f / 30)).round(2)
      end
      result = true if next_ss != sf
    end
    result
  end
end
