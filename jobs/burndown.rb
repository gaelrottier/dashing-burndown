# ################################################
# ############## Burndown Job ######################
# ################################################
class BurndownJob
  require 'singleton'
  include Singleton

  def initialize
    @burndown = Burndown.new

    SCHEDULER.every '10s', first_in: 0, allow_overlapping: false do
      @burndown.update_burndown
    end
  end

end

# ##################################################
# ############## Burndown Class ######################
# ##################################################
class Burndown
  require 'pivotal-tracker'

  # The API key of your account
  TOKEN = ''
  # The number of the project to track
  PROJECT = nil
  # If you haven't been using Pivotal Tracker since the start of your project,
  # set ITERATION_NUMBER_OFFSET to the number of iterations you want to add to the
  # total of iterations of the project
  ITERATION_NUMBER_OFFSET = 0

  # @iteration represents the current iteration
  # @iteration_number represents the number of the iteration
  # @iteration_points represents the number of points defined in the iteration
  # @points is an [Array] representing the points left to do for each day of the sprint
  # @stories represents the stories which are estimaded and aren't releases
  attr_accessor :iteration, :iteration_number, :iteration_points, :points, :stories

  def initialize

    PivotalTracker::Client.token = TOKEN
    PivotalTracker::Client.use_ssl = true

  end

  # Gets and sends the information about the current iteration burndown
  # (iteration number, iteration points, points) to the widget
  def update_burndown

    begin
      @iteration = PivotalTracker::Project.find(PROJECT).iteration(:current)
      @points = Array.new
    rescue Exception
      @iteration_number = @iteration_points = '0'
    end

    if @iteration
      update_iteration_number
      update_iteration_points
      update_points
    else
      @points = { x: 0, y: 0}
    end

    send_data

  end

  # Gets the iteration number and sets @iteration_number to it
  def update_iteration_number

    @iteration_number = @iteration.id

  end

  # Gets the number of points defined in the iteration and sets @iteration_points to it
  def update_iteration_points

    @stories = @iteration.stories.select { |s| ! s.estimate.nil? && s.estimate != -1 && s.story_type != 'release' }

    @iteration_points = 0

    @stories.each do |s|
        @iteration_points += s.estimate
    end

  end

  # Returns the number of days between the [date] given and the start of the iteration
  # @param [String] date from which calculate the diff
  # @return [Fixnum] the difference
  def retreive_nb_days_from_iteration(date)

    # We create new dates with the given ones to avoid shift between the hours
    given_date = DateTime.new(date.year, date.month, date.day)
    iteration_date = DateTime.new(@iteration.start.year, @iteration.start.month, @iteration.start.day)

    nb = ((iteration_date)..(given_date)).reject {|day| day.sunday? || day.saturday? }.size

    nb - 1

  end

  # Sets @points to the points left for each day of the sprint
  def update_points

    nb_days = retreive_nb_days_from_iteration(DateTime.now)
    iteration_length = retreive_nb_days_from_iteration(@iteration.finish)

    @points << { x: 0, y: @iteration_points }

    (0..iteration_length - 1).each do |i|
      iteration_points = @iteration_points

      @stories.select { |story| story.current_state == 'accepted' }.each do |s|
          if i >= retreive_nb_days_from_iteration(s.accepted_at)
            iteration_points -= s.estimate
          end
      end

      if i > nb_days
          iteration_points = nil
      end

      @points << { x: i + 1, y: iteration_points }
    end
    @points << { x: iteration_length + 1, y: nil }
  end

  # Sends the data to the widget 'burndown'
  def send_data

    iteration_count = @iteration_number + ITERATION_NUMBER_OFFSET
    send_event('burndown', {title: "Iteration #{iteration_count}", points: @points})

  end

end

# ##################################################
# ############## Job's execution ######################
# ##################################################
BurndownJob.instance
