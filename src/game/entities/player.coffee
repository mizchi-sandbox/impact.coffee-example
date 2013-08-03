ig.module(
    'game.entities.player'
)
.requires(
    'impact.entity'
)
.defines ->
  window.EntityPlayer = ig.Entity.extend
    size:   {x: 8, y:14},
    offset: {x: 4, y: 2},
    maxVel: {x: 100, y: 200},
    friction: {x: 600, y: 0},
    type: ig.Entity.TYPE.A
    checkAgainst: ig.Entity.TYPE.NONE
    collides: ig.Entity.COLLIDES.PASSIVE
    animSheet: new ig.AnimationSheet( 'media/player.png', 16, 16 )
    flip: false
    accelGround: 400
    accelAir: 200
    jump: 200
    health: 10
    flip: false

    init: ( x, y, settings ) ->
      @parent x, y, settings
      @addAnim 'idle', 1, [0]
      @addAnim 'run', 0.07, [0,1,2,3,4,5]
      @addAnim 'jump', 1, [9]
      @addAnim 'fall', 0.4, [6,7]

    update: ->
      accel = if @standing then @accelGround else @accelAir
      if ig.input.state('left')
        @accel.x = -accel;
        @flip = true;
      else if ig.input.state('right')
        @accel.x = accel
        @flip = false
      else
        @accel.x = 0


      if @standing and ig.input.pressed('jump')
        @vel.y = -@jump

      if ig.input.pressed('shoot')
        ig.game.spawnEntity EntitySlimeGrenade, @pos.x, @pos.y, {flip:@flip}

      if @vel.y < 0
        @currentAnim = @anims.jump
      else if @vel.y > 0
        @currentAnim = @anims.fall
      else if @vel.x != 0
        @currentAnim = @anims.run
      else
        @currentAnim = @anims.idle

      @currentAnim.flip.x = @flip
      @parent()

  window.EntitySlimeGrenade = ig.Entity.extend
    size: {x: 4, y: 4}
    offset: {x: 2, y: 2}
    maxVel: {x: 200, y: 200}
    bounciness: 0.6,
    type: ig.Entity.TYPE.NONE,
    checkAgainst: ig.Entity.TYPE.B
    collides: ig.Entity.COLLIDES.PASSIVE
    animSheet: new ig.AnimationSheet( 'media/slime-grenade.png', 8, 8 )
    bounceCounter: 0
    init: ( x, y, settings ) ->
      @parent( x, y, settings )
      @vel.x = if settings.flip then -@maxVel.x else @maxVel.x
      @vel.y = -50
      @addAnim( 'idle', 0.2, [0,1] )

    handleMovementTrace: ( res ) ->
      @parent( res )
      if res.collision.x or res.collision.y
        @bounceCounter++
        if @bounceCounter > 3
          @kill()

    check: ( other ) ->
      other.receiveDamage 10, @
      @kill()
