module StatisticsUtils
  def self.normal_PDF(mu, sigma, x)
      # this could be replaced by a lookup table if the inputs were discrete
      y = (1 / (sigma * ((2 * Math::PI) ** 0.5))) *
            (Math::E ** (-((x - mu) ** 2)) / (2 * (sigma ** 2)))
  end

  def self.sum_of_normal_PDFs(mu_list, sigma, x)

    sum = 0.0;
    for mu in mu_list
      sum += normal_PDF(mu, sigma, x)
    end

    sum
  end
end
