# frozen_string_literal: true

# La classe Player modélise un combattant (Bot).
class Player
  # Attributs accessibles en lecture et écriture: nom et points de vie
  attr_accessor :name, :life_points

  # Initialisation d'un nouveau joueur (Bot)
  def initialize(name)
    @name = name
    # Les bots commencent avec 10 points de vie
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
    nil
  end

  # Calcule les dommages infligés (lancer de dé aléatoire entre 1 et 6)
  # Pour un Player simple (Bot), les dégâts sont entre 1 et 6.
  def compute_damage
    rand(1..6)
  end

  # Attaque un autre joueur (objet Player ou HumanPlayer)
  def attacks(player_to_attack)
    return if @life_points <= 0 # Un joueur mort ne peut pas attaquer

    # 1. Annonce l'attaque
    puts "\n#{@name} attaque #{player_to_attack.name}"

    # 2. Calcule les dommages
    damage = compute_damage

    # 3. Fait subir les dégâts à la cible
    player_to_attack.gets_damage(damage)

    # 4. Annonce les dommages infligés
    puts "il lui inflige #{damage} points de dommages"
    nil
  end
end

# La classe HumanPlayer modélise un combattant joué par l'utilisateur.
# Elle hérite de Player.
class HumanPlayer < Player
  # Attribut supplémentaire : niveau de l'arme (corrigé: la syntaxe est :weapon_level)
  attr_accessor :weapon_level

  # Surcharge de la méthode initialize (corrigé: le nom est initialize)
  def initialize(name)
    @name = name
    # Points de vie différents pour l'Humain : 100
    @life_points = 100
    # Niveau de l'arme initial
    @weapon_level = 1
  end

  # Surcharge de la méthode show_state pour inclure le niveau de l'arme
  def show_state
    puts "#{@name} a #{@life_points} points de vie et une arme de niveau #{@weapon_level}"
  end

  # Surcharge de compute_damage pour utiliser le niveau de l'arme comme multiplicateur
  def compute_damage
    # Corrigé: On utilise rand(1..6) et on multiplie par @weapon_level
    rand(1..6) * @weapon_level
  end

  # Permet au joueur de chercher une nouvelle arme
  def search_weapon
    # Corrigé: On utilise rand(1..6) directement, pas HumanPlayer.compute_damage
    new_weapon_level = rand(1..6)
    puts "Tu as trouvé une arme de niveau #{new_weapon_level}"

    # Comparaison avec l'arme actuelle
    if new_weapon_level > @weapon_level
      @weapon_level = new_weapon_level
      puts 'Youhou ! elle est meilleure que ton arme actuelle : tu la prends.'
    else
      puts 'M@*#$... elle n\'est pas mieux que ton arme actuelle...'
    end
    nil
  end

  # Permet au joueur de chercher un pack de soins
  def search_health_pack
    # Lancer de dé pour déterminer le pack trouvé
    dice_roll = rand(1..6)

    case dice_roll
    when 1
      # Rien trouvé
      puts 'Tu n\'as rien trouvé... '
    when 2..5
      # Pack de +50 points de vie
      @life_points += 50
      # Assure que la vie ne dépasse pas 100
      @life_points = [@life_points, 100].min
      puts 'Bravo, tu as trouvé un pack de +50 points de vie !'
    when 6
      # Pack de +80 points de vie
      @life_points += 80
      # Assure que la vie ne dépasse pas 100
      @life_points = [@life_points, 100].min
      puts 'Waow, tu as trouvé un pack de +80 points de vie !'
    end
    nil
  end
end