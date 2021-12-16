class Hero
  def initialize(hero)
    @hero = hero
    @power_stats = @hero[:power_stats]
    @actual_stamina = Random.rand(11)
  end

  def set_filliation_coeficient(filliation_coeficient)
    @filliation_coeficient = filliation_coeficient
    @hero[:filliation_coeficient] = filliation_coeficient
  end

  def set_new_stats
    @hero[:stats] = new_stats
  end

  def set_powers
    @hero[:mental] = mental.to_i
    @hero[:strong] = strong.to_i
    @hero[:fast] = fast.to_i
  end

  def set_health_points
    @hero[:health_points] = health_points
  end

  def to_hash
    @hero
  end

  private

  def mental
    (@power_stats[:intelligence].to_i * 0.7 + @power_stats[:speed].to_i * 0.2 + @power_stats[:combat].to_i * 0.1) * @filliation_coeficient
  end

  def strong
    (@hero[:stats][:strength].to_i * 0.6 + @hero[:stats][:power].to_i * 0.2 + @hero[:stats][:combat].to_i * 0.2) * @filliation_coeficient
  end

  def fast
    (@hero[:stats][:speed].to_i * 0.55 + @hero[:stats][:durability].to_i * 0.25 + @hero[:stats][:strength].to_i * 0.2) * @filliation_coeficient
  end

  def health_points
    strength = @hero[:stats][:strength].to_i * 0.8
    durability = @hero[:stats][:durability].to_i * 0.7
    power = @hero[:stats][:power].to_i
    hp = ((strength + durability + power)/2 * 1 + @actual_stamina/10.0).to_i * 100

    hp
  end

  def new_stats
    _stats = {}

    @power_stats.each do |stat, power|
      _power = 0
      if (power != "null")
        _power = power.to_i
      end

      stat = stat.to_sym
      _stats[stat] = ((2 * _power + @actual_stamina)/1.1 * @filliation_coeficient).to_i
    end

    @hero[:stats] = _stats
  end
end
