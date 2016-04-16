module Hand

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

class Participant
  include Hand
  attr_accessor :cards, :round_finished

  def initialize
    @cards = []
    @round_finished = false
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
  DECK = [['2', 'H'], ['3', 'H'], ['4', 'H'], ['5', 'H'], ['6', 'H'], ['7', 'H'], ['8', 'H'],
          ['9', 'H'], ['10', 'H'], ['J', 'H'], ['Q', 'H'], ['K', 'H'], ['A', 'H'],
          ['2', 'C'], ['3', 'C'], ['4', 'C'], ['5', 'C'], ['6', 'C'], ['7', 'C'], ['8', 'C'],
          ['9', 'C'], ['10', 'C'], ['J', 'C'], ['Q', 'C'], ['K', 'C'], ['A', 'C'],
          ['2', 'S'], ['3', 'S'], ['4', 'S'], ['5', 'S'], ['6', 'S'], ['7', 'S'], ['8', 'S'],
          ['9', 'S'], ['10', 'S'], ['J', 'S'], ['Q', 'S'], ['K', 'S'], ['A', 'S'],
          ['2', 'D'], ['3', 'D'], ['4', 'D'], ['5', 'D'], ['6', 'D'], ['7', 'D'], ['8', 'D'],
          ['9', 'D'], ['10', 'D'], ['J', 'D'], ['Q', 'D'], ['K', 'D'], ['A', 'D']]

  def initialize
    @cards = []
    @cards = DECK
  end

  def shuffle_cards!
    puts "Shuffling Cards"
    Game.pause_for_effect(0.5)
    cards.shuffle!
  end
end

class Game
  attr_accessor :deck, :player, :dealer, :player_sticks
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

  def display_hands
    prompt "You hold #{player.cards}, with a value of [#{player.find_player_raw_value(player.cards)}] dealer shows #{dealer.cards.first} and a face down card"
  end

  def display_dealer_draws_message
    prompt "Dealer draws a card.."
    Game.pause_for_effect(1)
  end

  def display_player_bust_message
    prompt "You now hold #{player.cards}, with a total of [#{player.find_player_raw_value(player.cards)}]"
  end

  def display_hand_results
    if dealer.busted?(dealer.cards)
      prompt "Dealer is bust!"
    elsif player.busted?(player.cards)
      prompt "You're bust!"
    else
      prompt "Your total is #{player.find_player_raw_value(player.cards)}"
      prompt "Dealer's total is #{dealer.find_player_raw_value(dealer.cards)}"
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
    dealer.find_player_raw_value(dealer.cards) < 15
  end

  def set_player_finished
    player.round_finished = true
  end

  def start
    display_welcome_message
    deck.shuffle_cards!
    deal_initial_cards
    loop do
      display_hands
      ask_player_for_response
      break if player_sticks?
      player_draws
      if player.busted?(player.cards)
        display_player_bust_message
        set_player_finished
        break
      end
    end
    loop do
      break if player.round_finished
      dealer.show_dealer_hidden_hand
      break
    end
    loop do
      break if player.round_finished
      break unless dealer_draws?
      display_dealer_draws_message
      dealer.draw_card(dealer.cards, deck.cards)
      dealer.display_entire_hand
    end
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
