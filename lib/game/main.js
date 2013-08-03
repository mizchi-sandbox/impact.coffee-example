(function() {
  ig.module('game.main').requires('impact.game', 'impact.font', 'game.entities.player', 'game.entities.spike', 'game.levels.test').defines(function() {
    var MyGame;
    MyGame = ig.Game.extend({
      gravity: 300,
      font: new ig.Font('media/04b03.font.png'),
      init: function() {
        ig.input.bind(ig.KEY.LEFT_ARROW, 'left');
        ig.input.bind(ig.KEY.RIGHT_ARROW, 'right');
        ig.input.bind(ig.KEY.X, 'jump');
        ig.input.bind(ig.KEY.C, 'shoot');
        return this.loadLevel(LevelTest);
      },
      update: function() {
        var player;
        this.parent();
        player = this.getEntitiesByType(EntityPlayer)[0];
        if (player) {
          this.screen.x = player.pos.x - ig.system.width / 2;
          return this.screen.y = player.pos.y - ig.system.height / 2;
        }
      },
      draw: function() {
        var x, y;
        this.parent();
        x = ig.system.width / 2;
        y = ig.system.height / 2;
        return this.font.draw('Arrow Keys, X, C', 2, 2);
      }
    });
    return ig.main('#canvas', MyGame, 60, 320, 240, 2);
  });

}).call(this);
