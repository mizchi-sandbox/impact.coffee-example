ig.module(
  'game.entities.spike'
)
.requires(
  'impact.entity'
)
.defines ->

  window.EntitySpike = ig.Entity.extend
    size:     {x: 16,  y: 9}
    maxVel:   {x: 100, y: 100}
    friction: {x: 150, y: 0}

    type:         ig.Entity.TYPE.B
    checkAgainst: ig.Entity.TYPE.A
    collides:     ig.Entity.COLLIDES.PASSIVE

    health: 10
    speed: 14
    flip: false

    animSheet: new ig.AnimationSheet( 'media/spike.png', 16, 9 )

    init: ( x, y, settings ) ->
      @parent( x, y, settings )
      @addAnim( 'crawl', 0.08, [0,1,2] )

    update: () ->
      if( not ig.game.collisionMap.getTile(
          this.pos.x + (this.flip ? +4 : this.size.x -4),
          this.pos.y + this.size.y+1
        )
      )
        this.flip = !this.flip

      xdir = this.flip ? -1 : 1
      @vel.x = @speed * xdir

      @parent()


    handleMovementTrace: ( res ) ->
      @parent( res )

      if res.collision.x
        @flip = !@flip

    check: (other) ->
      other.receiveDamage( 10, @ )
