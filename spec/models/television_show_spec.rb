require "spec_helper"
require 'pry'

describe TelevisionShow do
  let(:leverage) { TelevisionShow.new("Leverage", "ION", "2008", "A crew of high-tech crooks attempt to steal from wealthy criminals and corrupt businessmen.", "Action") }
  let(:bang) { TelevisionShow.new("The Big Bang Theory", "", "2007", "A woman who moves into an apartment across the hall from two brilliant but socially awkward physicists shows them how little they know about life outside of the laboratory.", "Comedy")}
  let(:borgia) { TelevisionShow.new("The Borgias", "Showtime", "", "The saga of a crime family in 15th century Italy.", "Drama")}
  let(:girl) { TelevisionShow.new("Lost Girl", "SyFy", "2010", "", "Fantasy")}
  let(:fisher) { TelevisionShow.new("Miss Fisher's Murder Mysteries", "Online", "2012","Our female sleuth sashays through the back lanes and jazz clubs of late 1920s Melbourne, fighting injustice with her pearl-handled pistol and her dagger-sharp wit.", "")}
  let(:downton) { TelevisionShow.new("Downton Abbey", "BBC", "2010", "A chronicle of the lives of the British aristocratic Crawley family and their servants in the early 20th Century.", "Drama")}

  # [X]I want the TelevisionShow objects to be initialized with a title, network, starting year, genre, and synopsis.
  describe ".new" do
    it "is a TelevisionShow object" do
      expect(leverage).to be_a(TelevisionShow)
    end

    # [X]These attributes should have reader methods associated with them.
    it "has a reader for title, network, starting_year, synopsis, genre" do
      expect(leverage.title).to eq("Leverage")
      expect(leverage.network).to eq("ION")
      expect(leverage.starting_year).to eq("2008")
      expect(leverage.synopsis).to include("crew of high-tech crooks")
      expect(leverage.genre).to eq("Action")
    end

    # [X]These attributes should not have a writter.
    it "does not have a writer for title, network, starting_year, synopsis, genre" do
      expect{ leverage.title = "Leverage Inc." }.to raise_error StandardError
    end
  end

  # [X]The TelevisionShow class should have a class method called all.
  describe "#all" do
    # [X]This method should return an array of TelevisionShow objects whose attributes correspond to each data row in the csv file.
    it "it returns an array of TelevisionShow objects from the CSV file" do
      CSV.open("television-shows.csv", 'a') do |doc|
        doc << ["Leverage", "ION", "2008", "A crew of high-tech crooks attempt to steal from wealthy criminals and corrupt businessmen.", "Action"]
      end
      TelevisionShow.all.each do |show|
        expect(show).to be_a TelevisionShow
      end
    end
  end

  # [X]The TelevisionShow class should have an instance method called errors.
  describe "#errors" do
    # [X]On a newly initialized object, this method should return an empty array.
    it "on newly created objects an empthy array should be returned" do
      expect(leverage.errors).to eq([])
    end
  end

  # [X]The TelevisionShow class should have an instance method called valid?.
  describe "#valid?" do
    # This method should return true if the two following validations are true:
    # [X]None of the attritubes of the instance object are empty strings.
    # valid? is the method that generates errors
    it "should return true if none of the instance objects are empty strings" do
      expect(leverage.valid?).to be(true)
    end
    it "should return false if even one of the instance objects are an empty string." do
      expect(bang.valid?).to be(false)
      expect(borgia.valid?).to be(false)
      expect(girl.valid?).to be(false)
      expect(fisher.valid?).to be(false)
    end
    # [X]The title attribute of the instance object is not present in the csv file.
    it "should return true if the title is not already present in the CSV file" do
      expect(leverage.valid?).to be(true)
    end
    it "should return false if the title is already present in the CSV file" do
      CSV.open("television-shows.csv", 'a') do |doc|
        doc << ["Downton Abbey", "BBC", "2010", "A chronicle of the lives of the British aristocratic Crawley family and their servants in the early 20th Century.", "Drama"]
      end
      expect(downton.valid?).to be(false)
    end
    # Furthermore, the method should satisfy the following:
    # [X]Having called valid? on a valid object, calling errors on the same object should return an empty array.
    it "if valid? returns true then errors should return an empty array" do
      expect(leverage.valid?).to be(true)
      expect(leverage.errors).to eq([])
    end
    # [X]Having called valid? on an object that fails the first validation, calling errors on the same object should return an array containing the string "Please fill in all required fields".
    it "if valid? complete? returns false then errors should return an array containing Please fill in all required fields" do
      expect(bang.valid?).to be(false)
      expect(bang.errors).to eq(["Please fill in all required fields"])
    end
    # [X]Having called valid? on an object that fails the second validation, calling errors on the same object should return an array containing the string "The show has already been added".
    it "if valid? original? returns false then errors should return an array containing The show has already been added" do
      CSV.open("television-shows.csv", 'a') do |doc|
        doc << ["Downton Abbey", "BBC", "2010", "A chronicle of the lives of the British aristocratic Crawley family and their servants in the early 20th Century.", "Drama"]
      end
      expect(downton.valid?).to be(false)
      expect(downton.errors).to eq(["The show has already been added"])
    end
    # [X]Having called valid? on an object that fails both validations, calling errors on the same object should return an array containing both error message strings.
    it "if valid? returns false for both validations then errors should return an array containing both error messages" do
      CSV.open("television-shows.csv", 'a') do |doc|
        doc << ["Miss Fisher's Murder Mysteries", "Online", "2012","Our female sleuth sashays through the back lanes and jazz clubs of late 1920s Melbourne, fighting injustice with her pearl-handled pistol and her dagger-sharp wit.", "Mystery"]
      end
      expect(fisher.valid?).to be(false)
      expect(fisher.errors).to include("Please fill in all required fields")
      expect(fisher.errors).to include("The show has already been added")
    end
  end

  # [X]The TelevisionShow class should have an instance method called save.
  describe "#save" do
    # [X]If the object is valid this method should return true and add the attributes of the object to the csv.
    it "if the object is valid?, it should be added to the csv file" do
      leverage.save
      expect(TelevisionShow.all[0].title).to include("Leverage")
    end
    # [X]If the object is not valid this method should only return false.
    it "if the object is not valid? it should return false" do
      expect(bang.save).to be(false)

      CSV.open("television-shows.csv", 'a') do |doc|
        doc << ["Downton Abbey", "BBC", "2010", "A chronicle of the lives of the British aristocratic Crawley family and their servants in the early 20th Century.", "Drama"]
      end
      expect(downton.save).to be(false)

      CSV.open("television-shows.csv", 'a') do |doc|
        doc << ["Miss Fisher's Murder Mysteries", "Online", "2012","Our female sleuth sashays through the back lanes and jazz clubs of late 1920s Melbourne, fighting injustice with her pearl-handled pistol and her dagger-sharp wit.", "Mystery"]
      end
      expect(fisher.save).to be(false)
    end
  end
  # Once you have this class set up, use it in your app. For your POST route, you should initialize an object with the data from the form, call save on the object, and decide how to proceed based on the return value of save.
end
