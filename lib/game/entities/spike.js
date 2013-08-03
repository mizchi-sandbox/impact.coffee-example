(function() {
  ig.module('game.entities.spike').requires('impact.entity').defines(function() {
    return window.EntitySpike = ig.Entity.extend({
      size: {
        x: 16,
        y: 9
      },
      maxVel: {
        x: 100,
        y: 100
      },
      friction: {
        x: 150,
        y: 0
      },
      type: ig.Entity.TYPE.B,
      checkAgainst: ig.Entity.TYPE.A,
      collides: ig.Entity.COLLIDES.PASSIVE,
      health: 10,
      speed: 14,
      flip: false,
      animSheet: new ig.AnimationSheet('media/spike.png', 16, 9),
      init: function(x, y, settings) {
        this.parent(x, y, settings);
        return this.addAnim('crawl', 0.08, [0, 1, 2]);
      },
      update: function() {
        var xdir, _ref, _ref1;
        if (!ig.game.collisionMap.getTile(this.pos.x + ((_ref = this.flip) != null ? _ref : +{
          4: this.size.x(-4)
        }), this.pos.y + this.size.y + 1)) {
          this.flip = !this.flip;
        }
        xdir = (_ref1 = this.flip) != null ? _ref1 : -{
          1: 1
        };
        this.vel.x = this.speed * xdir;
        return this.parent();
      },
      handleMovementTrace: function(res) {
        this.parent(res);
        if (res.collision.x) {
          return this.flip = !this.flip;
        }
      },
      check: function(other) {
        return other.receiveDamage(10, this);
      }
    });
  });

}).call(this);
