require_relative 'hero'

class HeroTeam
  def initialize(heroes)
    @heroes = heroes
    @alignment = team_aligment
    @team = initialize_team
  end

  def team
    @team
  end

  def get_alignment
    @alignment
  end

  private

  def initialize_team
    new_team = []
    @heroes.each do |_hero|
      hero = Hero.new(_hero)
      hero.set_filliation_coeficient(fillitation_coeficient(_hero[:alignment]))
      hero.set_new_stats
      hero.set_powers
      hero.set_health_points
      new_team.push(hero.to_hash)
    end
    new_team
  end

  def team_aligment
    good_count = 0
    @heroes.each do |hero|
      if hero[:alignment] == "good"
        good_count += 1
      end
    end

    if good_count > 2
      return "good"
    end

    return "bad"
  end

  def fillitation_coeficient(hero_alignment)
    if hero_alignment == @alignment
      return 1 + Random.rand(0.9)
    end
    return 1/(1 + Random.rand(0.9))
  end
end