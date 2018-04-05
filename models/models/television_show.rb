class TelevisionShow
  GENRES = ["Action", "Mystery", "Drama", "Comedy", "Fantasy"]

  attr_reader :title, :network, :starting_year, :synopsis, :genre

  def initialize(title, network, starting_year, synopsis, genre)
    @title = title
    @network = network
    @starting_year = starting_year
    @synopsis = synopsis
    @genre = genre
  end

  def self.all
    tv_shows = []
    CSV.foreach('television-shows.csv', headers: true) do |line_item|
      tv_shows << TelevisionShow.new(line_item[0], line_item[1], line_item[2], line_item[3], line_item[4])
    end
    tv_shows
  end

  def save
    if valid?
      CSV.open("television-shows.csv", 'a') do |doc|
        doc << [@title, @network, @starting_year, @synopsis, @genre]
      end
      true
    else
      false
    end
  end

  def valid?
    complete? && original?
  end

  def complete?
    @title != "" && @network != "" && @starting_year != "" && @synopsis != "" && @genre != ""
  end

  def original?
    titles_list = []
    TelevisionShow.all.each do |show|
      titles_list << show.title
    end
    !titles_list.include?(@title)
  end

  def errors
    errors = []
    if complete? == false
      errors << "Please fill in all required fields"
    end
    if original? == false
      errors << "The show has already been added"
    end
    errors
  end
end
