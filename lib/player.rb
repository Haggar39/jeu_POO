# frozen_string_literal: true

# La classe Player modélise un combattant.
class Player
  # Attributs accessibles en lecture et écriture: nom et points de vie

  attr_accessor :name, :life_points

  # Initialisation d'un nouveau joueur
  def initialize(name)
    @name = name
    # Tous les joueurs commencent avec 10 points de vie (valeur fixe)
    @life_points = 10
  end

  # Affiche l'état actuel du joueur : "XXXX a YYY points de vie"
  def show_state
    puts "#{@name} a #{@life_points} points de vie"
  end

  # Fait subir des dommages au joueur
  def gets_damage(damage)
    @life_points -= damage # Soustrait les dégâts des points de vie

    # Vérifie si le joueur est mort
    if @life_points <= 0
      @life_points = 0 # S'assure que les points de vie ne sont pas négatifs pour l'affichage
      puts "le joueur #{@name} a été tué !"
    end
    # Retourne nil pour correspondre au comportement de l'exemple PRY
    nil
  end

  # Calcule les dommages infligés (lancer de dé aléatoire entre 1 et 6)
  def compute_damage
    # Utilise rand(1..6) pour simuler le lancé de dé
    rand(1..6)
  end

  # Attaque un autre joueur (objet Player)
  def attacks(player_to_attack)
    # 1. Annonce l'attaque
    puts "\n#{@name} attaque #{player_to_attack.name}"

    # 2. Calcule les dommages
    damage = compute_damage

    # 3. Fait subir les dégâts à la cible
    player_to_attack.gets_damage(damage)

    # 4. Annonce les dommages infligés
    puts "il lui inflige #{damage} points de dommages"

    # Retourne nil pour correspondre au comportement de l'exemple PRY
    nil
  end
end

# frozen_string_literal: true

# On a besoin de la classe Player définie dans player.rb
require_relative 'player'
# Pour le débogage interactif (si on veut tester ligne par ligne)
require 'pry'

def perform
  puts '---------------------------------------------------'
  puts 'Bienvenue sur FIGHT FOR THP !'
  puts '---------------------------------------------------'

  # 1. Création des joueurs (avec leurs noms)
  player1 = Player.new('Josiane')
  player2 = Player.new('José')

  # Boucle du combat : continue tant que les deux joueurs sont en vie
  while player1.life_points > 0 && player2.life_points > 0
    puts "\n==================================================="
    # 2. Présentation de l'état des combattants (au début de chaque tour)
    puts "Voici l'état de nos joueurs :"
    player1.show_state
    player2.show_state
    puts "==================================================="

    # Annonce la phase d'attaque
    puts "\nPassons à la phase d'attaque :"

    # 3. Josiane attaque José
    player1.attacks(player2)

    # 4. Correction du bug : vérifie si le joueur 2 est mort après l'attaque
    # Si la cible est tuée, on sort immédiatement de la boucle pour l'empêcher de riposter.
    if player2.life_points <= 0
      break
    end

    # 5. José réplique (s'il est encore en vie)
    player2.attacks(player1)
  end

  # Fin du combat
  puts "\n---------------------------------------------------"
  puts "Le combat est terminé !"
  puts "---------------------------------------------------"
  
  # binding.pry est le mot-clé correct pour lancer le débogueur
  binding.pry 
end

perform
