class Character < ActiveRecord::Base
  has_paper_trail
  RACES = ["Human", "Elf", "Dwarf", "Gnome", "Ent", "Custom"]
  CULTURES = ["Cryogen", "Venthos", "Sengra", "Illumen/Lumiend", "Shaiden/Om'Oihanna", "Illugar/Unan Gens", "Shaigar/Alkon'Gol", "Minor", "Custom"]
  # (1..50).each { |i| EXP_CHART << EXP_CHART[i-1] + 15 + i-1 }
  EXP_CHART = [0, 15, 31, 48, 66, 85, 105, 126, 148, 171, 195, 220,
  246, 273, 301, 330, 360, 391, 423, 456, 490, 525, 561, 598, 636, 675, 715,
  756, 798, 841, 885, 930, 976, 1023, 1071, 1120, 1170, 1221, 1273, 1326,
  1380,1435, 1491, 1548, 1606, 1665, 1725, 1786, 1848, 1911, 1975]
  # (1..50).each { |i| SKILL_CHART << SKILL_CHART[i-1] + i/5 }
  SKILL_CHART = [0, 1, 2, 3, 4, 6, 7, 8, 9, 10, 12, 13, 14, 15, 16, 18, 19,
  20, 21, 22, 24, 25, 26, 27, 28, 30, 31, 32, 33, 34, 36, 37, 38, 39, 40,
  42, 43, 44, 45, 46, 48, 49, 50, 51, 52, 54, 55, 56, 57, 58, 60]
  DEATH_PERCENTAGES = [0, 10, 30, 60, 90]
  DEATH_COUNTER = [0, 3, 2, 1, 0]

  belongs_to :user, inverse_of: :characters

  has_many :backgrounds, -> { distinct }, through: :character_backgrounds, inverse_of: :characters
  has_many :origins, -> { distinct }, through: :character_origins, inverse_of: :characters
  has_many :skills, -> { distinct }, through: :character_skills, inverse_of: :characters
  has_many :perks, -> { distinct }, through: :character_perks, inverse_of: :characters
  has_many :events, -> { distinct }, through: :character_events, inverse_of: :characters
  has_many :projects, -> { distinct }, through: :project_contributions, inverse_of: :characters

  has_many :character_backgrounds, inverse_of: :character
  has_many :character_origins, inverse_of: :character
  has_many :character_skills, inverse_of: :character
  has_many :character_perks, inverse_of: :character
  has_many :character_events, inverse_of: :character
  has_many :project_contributions, inverse_of: :character
  has_many :talents, inverse_of: :character
  has_many :deaths, inverse_of: :character

  accepts_nested_attributes_for :character_backgrounds, :character_origins, :character_skills, :character_perks, :character_events, :project_contributions, :talents, :deaths, allow_destroy: true

  validates :name, presence: true
  validates :race, inclusion: { in: RACES }
  validates :culture, inclusion: { in: CULTURES }
  validates :costume, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 3 }
  validates :unused_talents, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :perm_chance, numericality: { only_integer: true }, inclusion: { in: DEATH_PERCENTAGES }
  validates :perm_counter, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 3 }

  def level
    @level = EXP_CHART.find_index { |i| self.experience <= i } - 1
  end

  def exp_to_next
    @exp_to_next = EXP_CHART[self.level + 1] - self.experience
  end

  def experience
    @experience = self.events.reduce(31) do |sum, event|
      character_event = self.character_events.find_by :event_id => event.id
      if character_event.paid then sum += event.play_exp end
      if character_event.cleaned then sum += event.clean_exp end
      sum
    end
  end

  def skill_points_used
    @skill_points_used = self.skills.reduce(0) { |sum, el| sum + el.cost }
  end

  def skill_points_total
    @skill_points_total = SKILL_CHART[self.level]
  end

  def perk_points_used
    @perk_points_used = self.perks.reduce(0) { |sum, el| sum + el.cost }
  end

  def perk_points_total
    base = self.costume + 1
    added_perks = self.skills.find { |s| s.name.downcase == "added perks" }

    @perk_points_total = added_perks ? (added_perks.cost * base) : 0
    @perk_points_total += self.backgrounds.find { |b| b.name.start_with?("Paragon") } ? 4 : 0
  end

  def invest_in_project(amt, talent=nil)
    self.unused_talents -= amt
    self.talents.find(talent).invest(amt, false) if talent.present?
  end

  def talent_points_total
    @talent_points_total = self.talents.reduce(0) { |sum, el| sum + el.value }
  end

  def history_approval=(bool)
    @history_approval = bool == "official" ? true : false
  end

  def history_approval
    @history_approval ? "official" : "unofficial"
  end

  def increment_death
    index = [DEATH_PERCENTAGES.index(self.perm_chance) + 1, DEATH_PERCENTAGES.size - 1].min
    self.perm_chance = DEATH_PERCENTAGES[index]
    self.perm_counter = DEATH_COUNTER[index]
  end

  def decrement_death
    if self.perm_counter == 0
      index = [DEATH_PERCENTAGES.index(self.perm_chance) - 1, 0].max
      self.perm_chance = DEATH_PERCENTAGES[index]
      self.perm_counter = DEATH_COUNTER[index]
    else
      self.perm_counter -= 1
    end
  end

  def attend_event(event_id, paid=true, cleaned=true)
    attendance = self.character_events.find_or_initialize_by(event_id: event_id)
    attendance.paid = paid
    attendance.cleaned = cleaned
    attendance.save
  end
end
