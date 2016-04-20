module Convertable
  def find_player_raw_value(player_hand)
    values = player_hand.map { |value| value[0] }
    sum = 0
    values.each do |value|
      if value == "A"
        sum += 11
      elsif value.to_i == 0
        sum += 10
      else
        sum += value.to_i
      end
    end
    values.select { |value| value == "A" }.count.times do
      sum -= 10 if sum > 21
    end
    sum
  end

  def busted?(player_hand)
    find_player_raw_value(player_hand) > 21
  end
end

class Hand
  attr_accessor :cards
  def initialize
    @cards = nil
  end

  def show_cards(hand)
    cards = hand
    extract_values(hand)
  end

  def extract_values(card)
    string = ""
    card.each do |character|
      string += "[#{character[0]} of #{character[1]}]"
    end
    string
  end
end

class Participant
  include Convertable
  attr_accessor :cards, :round_finished, :hand
  def initialize
    @cards = []
    @round_finished = false
    @hand = Hand.new
  end

  def prompt(msg)
    puts "=> #{msg}"
  end

  def deal_cards(deck)
    2.times do
      cards << deck.shift
    end
  end

  def draw_card(participant_hand, deck_of_cards)
    participant_hand << deck_of_cards.shuffle.first
  end
end

class Player < Participant
end

class Dealer < Participant
  def show_dealer_hidden_hand
    display_initial_hand
    reveal_hidden_card
    display_entire_hand
  end

  def display_initial_hand
    prompt "Dealer holds #{cards.first} and a hidden card"
  end

  def reveal_hidden_card
    prompt "Dealer shows hidden card.."
    Game.pause_for_effect(2)
  end

  def display_entire_hand
    prompt "Dealer holds #{cards} with a value of [#{find_player_raw_value(cards)}]"
  end
end

class Deck
  attr_accessor :cards
  SUITS = ['Hearts', 'Diamonds', 'Spades', 'Clubs']
  VALUES = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']

  def initialize
    @cards = []
    SUITS.each do |suit|
      VALUES.each do |face|
        arr = []
        arr.push(face, suit)
        cards << arr
      end
    end
  end

  def shuffle_cards!
    puts "Shuffling Cards"
    Game.pause_for_effect(0.5)
    cards.shuffle!
  end
end

class Game
  attr_accessor :deck, :player, :dealer, :player_sticks
  DEALER_DRAW_LIMIT = 17
  def initialize
    @deck = Deck.new
    @player = Player.new
    @dealer = Dealer.new
    @player_sticks = false
  end

  def self.pause_for_effect(interval)
    sleep(interval)
  end

  def prompt(msg)
    puts "=> #{msg}"
  end

  def deal_initial_cards
    player.deal_cards(deck.cards)
    dealer.deal_cards(deck.cards)
  end

  def display_welcome_message
    prompt "Welcome!"
  end

  def display_player_cards
    player.hand.show_cards(player.cards)
  end

  def display_player_value
    player.find_player_raw_value(player.cards)
  end

  def display_dealer_cards
    dealer.display_entire_hand
  end

  def display_dealer_value
    dealer.find_player_raw_value(dealer.cards)
  end

  def display_initial_hands
    prompt "You hold: #{display_player_cards} with a value of [#{display_player_value}]"
    prompt "Dealer shows [#{dealer.cards[0][0]} of #{dealer.cards[0][1]}] and a face down card"
  end

  def display_dealer_draws_message
    prompt "Dealer draws a card.."
    Game.pause_for_effect(1)
  end

  def display_player_bust_message
    prompt "You now hold #{display_player_cards}, with a total of [#{display_player_value}]"
  end

  def display_hand_results
    if dealer.busted?(dealer.cards)
      prompt "Dealer is bust!"
    elsif player.busted?(player.cards)
      prompt "You're bust!"
    else
      prompt "Your total is #{display_player_value}"
      prompt "Dealer's total is #{display_dealer_value}"
    end
  end

  def display_game_result
    if player.busted?(player.cards)
      prompt "Dealer Wins"
    elsif dealer.busted?(dealer.cards)
      prompt "Player Wins!"
    elsif player.find_player_raw_value(player.cards) == dealer.find_player_raw_value(dealer.cards)
      prompt "Its a draw"
    elsif player.find_player_raw_value(player.cards) > dealer.find_player_raw_value(dealer.cards)
      prompt "Player Wins!"
    else prompt "Dealer Wins!"
    end
  end

  def ask_player_for_response
    prompt "Will you (S)tick, or (T)wist?"
    answer = ""
    loop do
      answer = gets.chomp.upcase
      if answer.start_with?('S', 'T')
        break
      else prompt "Please select (S)tick or (T)wist"
      end
    end
    if answer == 'S'
      self.player_sticks = true
    end
    answer
  end

  def player_draws
    player.draw_card(player.cards, deck.cards)
  end

  def player_sticks?
    player_sticks == true
  end

  def dealer_draws?
    dealer.find_player_raw_value(dealer.cards) < DEALER_DRAW_LIMIT
  end

  def set_player_finished
    player.round_finished = true
  end

  def player_action_loop
    loop do
      display_initial_hands
      ask_player_for_response
      break if player_sticks?
      player_draws
      if player.busted?(player.cards)
        display_player_bust_message
        set_player_finished
        break
      end
    end
  end

  def dealer_action_loop
    loop do
      break if player.round_finished
      break unless dealer_draws?
      display_dealer_draws_message
      dealer.draw_card(dealer.cards, deck.cards)
      display_dealer_cards
    end
  end

  def continue_or_show_dealer_hand
    loop do
      break if player.round_finished
      dealer.show_dealer_hidden_hand
      break
    end
  end

  def start
    display_welcome_message
    deck.shuffle_cards!
    deal_initial_cards
    player_action_loop
    dealer_action_loop
    display_hand_results
    display_game_result
  end
end

loop do
  game = Game.new
  game.start
  answer = ""
  loop do
    puts "Would you like to play again? (Y/N)"
    answer = gets.chomp
    break if answer.upcase.start_with?('Y', 'N')
    puts "Please select Y or N"
  end
  break if answer.upcase.start_with?('N')
end
