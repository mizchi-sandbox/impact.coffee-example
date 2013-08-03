ig.module(
  'game.main'
)
.requires(
  'impact.game'
  'impact.font'
  'game.entities.player'
  'game.entities.spike'
  'game.levels.test'
)
.defines ->
  MyGame = ig.Game.extend
    gravity: 300
    font: new ig.Font 'media/04b03.font.png'

    init: ->
      ig.input.bind ig.KEY.LEFT_ARROW, 'left'
      ig.input.bind ig.KEY.RIGHT_ARROW, 'right'
      ig.input.bind ig.KEY.X, 'jump'
      ig.input.bind ig.KEY.C, 'shoot'
      @loadLevel LevelTest

    update: ->
      @parent()
      player = this.getEntitiesByType( EntityPlayer )[0]
      if player
        @screen.x = player.pos.x - ig.system.width/2
        @screen.y = player.pos.y - ig.system.height/2

    draw: ->
      @parent()
      x = ig.system.width/2
      y = ig.system.height/2
      @font.draw( 'Arrow Keys, X, C', 2, 2 );
      # for i in [1..100]
      #   @font.draw '.', Math.random() * ig.system.width, Math.random() * ig.system.height, ig.Font.ALIGN.CENTER

  ig.main '#canvas', MyGame, 60, 320, 240, 2

