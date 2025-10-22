#Un fichier d'application contenant les configs d'un jeu

require 'bundler'

Bundler.require

require_relative 'lib/game'

require_relative 'lib/player'

# On a besoin de la classe Player définie dans player.rb

# Pour le débogage interactif (si on veut tester ligne par ligne)
require 'pry'

# frozen_string_literal: true

# Nécessaire pour inclure la classe Player et HumanPlayer

# require 'pry' # Décommenter si vous voulez déboguer

def perform
  # ------------------------------------
  # 1. Accueil du jeu
  # ------------------------------------
  puts '---------------------------------------------------'
  puts '|Bienvenue sur "ILS VEULENT TOUS MA POO" !        |'
  puts '|Le but du jeu est d\'être le dernier survivant !  |'
  puts '---------------------------------------------------'

  # 2. Initialisation du joueur humain
  puts 'Quel est ton prénom, cher(e) combattant(e) ?'
  print '> '
  user_name = gets.chomp
  user = HumanPlayer.new(user_name)

  # 3. Initialisation des ennemis (Bots)
  enemies = [Player.new('Josiane'), Player.new('José')]

  # 4. Le combat
  # La boucle continue tant que le joueur humain est en vie ET qu'au moins un ennemi est en vie.
  while user.life_points > 0 && enemies.any? { |enemy| enemy.life_points > 0 }
    puts "\n"
    puts "==================================================="
    # Affichage de l'état du HumanPlayer
    user.show_state
    puts '==================================================='
    
    # 5. Affichage du menu d'action
    puts "\nQuelle action veux-tu effectuer ?"
    puts 'a - chercher une meilleure arme'
    puts 's - chercher à se soigner (pack de vie)'
    puts "\nattaquer un joueur en vue :"
    
    # Affichage de l'état des ennemis et du menu d'attaque
    enemies.each_with_index do |enemy, index|
      if enemy.life_points > 0
        print "#{index} - "
        enemy.show_state
      else
        puts "#{index} - #{enemy.name} est déjà mort."
      end
    end

    # Saisie de l'utilisateur
    print "\nTon choix : "
    choice = gets.chomp.downcase

    puts "\n----------------- TON ACTION -----------------"
    case choice
    when 'a'
      user.search_weapon
    when 's'
      user.search_health_pack
    when '0', '1'
      target_index = choice.to_i
      target = enemies[target_index]
      
      # Vérifie si la cible existe et est vivante avant d'attaquer
      if target.nil? || target.life_points <= 0
        puts "Cible invalide ou déjà morte. Choisis un joueur en vie (0 ou 1)."
      else
        user.attacks(target)
      end
    else
      puts "Option invalide. Essaie 'a', 's', '0' ou '1'."
    end
    
    # Pause pour la lisibilité
    puts "\n--- Appuyez sur Entrée pour le tour des ennemis ---"
    gets.chomp


    # 6. Attaque des ennemis
    # Les ennemis attaquent seulement si le joueur humain est encore en vie
    if enemies.any? { |enemy| enemy.life_points > 0 } && user.life_points > 0
      puts "\n----------------- ATTAQUE DES ENNEMIS -----------------"
      enemies.each do |enemy|
        # Le Player attaque seulement s'il est encore en vie
        if enemy.life_points > 0
          enemy.attacks(user)
          # Si le joueur humain meurt pendant les attaques ennemies, on sort de la boucle each
          break if user.life_points <= 0 
        end
      end
    end
  end

  # 7. Fin du jeu
  puts "\n==================================================="
  puts "La partie est finie"
  
  if user.life_points > 0
    puts "BRAVO ! TU AS GAGNE !"
  else
    puts "Loser ! Tu as perdu !"
  end
  puts "==================================================="
end

perform


binding.pry