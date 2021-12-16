require_relative 'super_heroes_client'
require_relative 'hero_team'

class Fight
  def initialize(access_token)
    @access_token = access_token
  end

  def build_teams
    puts "Building teams..."
    first_hero_team, second_hero_team = initialize_teams
    @first_team = first_hero_team.team
    @second_team = second_hero_team.team

    puts '-----------'
    puts "TEAM 1 - #{first_hero_team.get_alignment}"
    puts_team(@first_team)
    puts '-----------'
    puts "TEAM 2 - #{second_hero_team.get_alignment}"
    puts_team(@second_team)
    puts '-----------'
  end

  def begin_fight(slow=false)
    sleep(10) if slow
    fight_over = false
    puts "The fight will start..."
    sleep(1) if slow
    puts "NOW!!\n\n"
    while !fight_over
      [*0..4].each do |turn|
        hero_first_team = @first_team[turn]
        hero_second_team = @second_team[turn]
        random_hero_first_team = random_hero(@second_team)
        random_hero_second_team = random_hero(@first_team)

        fight_over = fight_turn(hero_first_team, random_hero_second_team, 1)
        sleep(0.5) if slow
        if fight_over
          break
        end

        fight_over = fight_turn(hero_second_team, random_hero_first_team, 2)
        sleep(0.5) if slow
        if fight_over
          break
        end
      end
    end
  end

  private

  def fight_turn(hero, opponent, team)
    fight_over = false

    if hero[:health_points] > 0
      puts "\n\nTurn of #{hero[:name]} from TEAM #{team} against #{opponent[:name]}"
      damage, hero_injured = combat(hero, opponent)
      puts_wounded_hero(hero_injured, damage)
      fight_over = game_over
    end

    return fight_over
  end

  def game_over
    first_team_alive = are_heroes_alive(@first_team)
    second_team_alive = are_heroes_alive(@second_team)

    if (!first_team_alive)
      puts "  TEAM 2 WON!!"
      return true
    elsif (!second_team_alive)
      puts "  TEAM 1 WON!!"
      return true
    end
    return false
  end

  def are_heroes_alive(team)
    count = 0
    team.each do |hero|
      if hero[:health_points] <= 0
        count += 1
      end
    end

    if count == team.length
      return false
    end
    return true
  end

  def puts_team(team)
    team.each do |hero|
      puts "- #{hero[:name]}"
      puts "    health points: #{hero[:health_points]} points"
      puts "    alignment: #{hero[:alignment]}"
    end
  end

  def puts_wounded_hero(hero, damage)
    puts "  #{hero[:name]} was injured with #{damage} of damage"
    puts "  ...now hero has #{hero[:health_points]} of hp."
  end

  def random_hero(team)
    filter_team = []
    
    team.each do |hero|
      if hero[:health_points] > 0
        filter_team.push(hero)
      end
    end
    random = Random.rand(filter_team.length)

    return filter_team[random]
  end

  def combat(hero, opponent)
    amount = [hero[:strong], hero[:fast], hero[:mental]].sample
    failure_probability = Random.rand()
    damage_to = nil
    if failure_probability < 0.1
      hero[:health_points] -= amount
      damage_to = hero
      puts "  ...shot failed."
    else
      opponent[:health_points] -= amount
      damage_to = opponent
      puts "  ... good shot!"
    end

    [amount, damage_to]
  end

  def client
    SuperHeroesClient.new(@access_token)
  end

  def get_heroes
    client.get_random_heroes
  end

  def initialize_teams
    puts 'Getting heroes...'
    heroes = get_heroes

    puts 'Preparing teams...'
    first_team = HeroTeam.new(heroes[..4])
    second_team = HeroTeam.new(heroes[5..])

    [first_team, second_team]
  end
end
