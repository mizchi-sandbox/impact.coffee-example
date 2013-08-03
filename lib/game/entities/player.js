(function() {
  ig.module('game.entities.player').requires('impact.entity').defines(function() {
    window.EntityPlayer = ig.Entity.extend({
      size: {
        x: 8,
        y: 14
      },
      offset: {
        x: 4,
        y: 2
      },
      maxVel: {
        x: 100,
        y: 200
      },
      friction: {
        x: 600,
        y: 0
      },
      type: ig.Entity.TYPE.A,
      checkAgainst: ig.Entity.TYPE.NONE,
      collides: ig.Entity.COLLIDES.PASSIVE,
      animSheet: new ig.AnimationSheet('media/player.png', 16, 16),
      flip: false,
      accelGround: 400,
      accelAir: 200,
      jump: 200,
      health: 10,
      flip: false,
      init: function(x, y, settings) {
        this.parent(x, y, settings);
        this.addAnim('idle', 1, [0]);
        this.addAnim('run', 0.07, [0, 1, 2, 3, 4, 5]);
        this.addAnim('jump', 1, [9]);
        return this.addAnim('fall', 0.4, [6, 7]);
      },
      update: function() {
        var accel;
        accel = this.standing ? this.accelGround : this.accelAir;
        if (ig.input.state('left')) {
          this.accel.x = -accel;
          this.flip = true;
        } else if (ig.input.state('right')) {
          this.accel.x = accel;
          this.flip = false;
        } else {
          this.accel.x = 0;
        }
        if (this.standing && ig.input.pressed('jump')) {
          this.vel.y = -this.jump;
        }
        if (ig.input.pressed('shoot')) {
          ig.game.spawnEntity(EntitySlimeGrenade, this.pos.x, this.pos.y, {
            flip: this.flip
          });
        }
        if (this.vel.y < 0) {
          this.currentAnim = this.anims.jump;
        } else if (this.vel.y > 0) {
          this.currentAnim = this.anims.fall;
        } else if (this.vel.x !== 0) {
          this.currentAnim = this.anims.run;
        } else {
          this.currentAnim = this.anims.idle;
        }
        this.currentAnim.flip.x = this.flip;
        return this.parent();
      }
    });
    return window.EntitySlimeGrenade = ig.Entity.extend({
      size: {
        x: 4,
        y: 4
      },
      offset: {
        x: 2,
        y: 2
      },
      maxVel: {
        x: 200,
        y: 200
      },
      bounciness: 0.6,
      type: ig.Entity.TYPE.NONE,
      checkAgainst: ig.Entity.TYPE.B,
      collides: ig.Entity.COLLIDES.PASSIVE,
      animSheet: new ig.AnimationSheet('media/slime-grenade.png', 8, 8),
      bounceCounter: 0,
      init: function(x, y, settings) {
        this.parent(x, y, settings);
        this.vel.x = settings.flip ? -this.maxVel.x : this.maxVel.x;
        this.vel.y = -50;
        return this.addAnim('idle', 0.2, [0, 1]);
      },
      handleMovementTrace: function(res) {
        this.parent(res);
        if (res.collision.x || res.collision.y) {
          this.bounceCounter++;
          if (this.bounceCounter > 3) {
            return this.kill();
          }
        }
      },
      check: function(other) {
        other.receiveDamage(10, this);
        return this.kill();
      }
    });
  });

}).call(this);
