require 'twitter_ebooks'
require_relative 'keys'

class MyBot < Ebooks::Bot
  attr_accessor :original, :model, :model_path

  def configure
    # Once you have consumer details, use "ebooks auth" for new access tokens
    self.consumer_key = Consumer_key
    self.consumer_secret = Consumer_key_secret

    # Users to block instead of interacting with
    # self.blacklist = ['user']

    # Range in seconds to randomize delay when bot.delay is called
    self.delay_range = 1..6
  end

  def on_startup
    load_model!

    # scheduler.every '24h' do
      # Tweet something every 24 hours
      # See https://github.com/jmettraux/rufus-scheduler
      # tweet("hi")
      # pictweet("hi", "cuteselfie.jpg")
    # end

    # scheduler.every '5h' do
    #   ryan_reply = model.make_statement(110)
    #   tweet("@ryanvailbrown " + ryan_reply)
    # end

    scheduler.every '10m' do
      statement = model.make_statement(140)
      tweet(statement)
    end

  end

  def on_message(dm)
    # Reply to a DM
    reply(dm, model.make_statement(140))
  end

  def on_follow(user)
    # Follow a user back
    follow(user.screen_name)
  end

  def on_mention(tweet)
    # Reply to a mention
    reply(tweet, model.make_statement(140))
  end

  def on_timeline(tweet)
    # Reply to a tweet in the bot's timeline
    reply(tweet, model.make_statement(140))
  end

  private
  def load_model!
    return if @model

    @model_path ||= "model/#{original}.model"

    log "Loading model #{model_path}"
    @model = Ebooks::Model.load(model_path)
  end
end

# Make a MyBot and attach it to an account
MyBot.new("test_bot_720") do |bot|
  bot.access_token = Access_token
  bot.access_token_secret = Access_token_secret

  bot.original = "Buzzfeed"
end
