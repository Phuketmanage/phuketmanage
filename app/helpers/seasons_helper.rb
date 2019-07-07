module SeasonsHelper
  def have_seasons_gap? seasons
    result = false
    seasons.each_with_index do |s, index|
      sf = (s.sfm.to_i+s.sfd.to_f/30).round(2)
      if (index+1) < seasons.count
        next_ss = (seasons[index+1].ssm.to_i+seasons[index+1].ssd.to_f/30).round(2)
      else
        next_ss = (seasons[0].ssm.to_i+seasons[0].ssd.to_f/30).round(2)
      end
      if  next_ss != sf
        result = true
      end
    end
    return result
  end
end
