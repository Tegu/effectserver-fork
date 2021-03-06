
should = require "should"

{packetParse} = require "../lib/packetparser"


describe "packet parser", ->

  it "can parse single packet", ->

    lightPacket = new Buffer [
      1 # spec version
      , 1 # Type. 1 means light
      , 1 # light id
      , 0 # Light type. 0 means rgb
      , 0   # R
      , 255 # G
      , 0   # B
    ]

    should.deepEqual packetParse(lightPacket), [
      tag: "anonymous"
    ,
      deviceType: "light"
      id: 1
      cmd:
        lightType: "rgb"
        r: 0
        g: 255
        b: 0
    ]




  it "can parse two light packets from single udp-packet", ->

    lightPacket = new Buffer [
      1 # spec version
      , 1 # Type. 1 means light
      , 1 # light id
      , 0 # Light type. 0 means rgb
      , 0 # R
      , 255 # G
      , 0 #B

      , 1 # Type. 1 means light
      , 2 # light id
      , 0 # Light type. 0 means rgb
      , 0 # R
      , 0 # G
      , 255 #B
    ]

    should.deepEqual packetParse(lightPacket), [
      tag: "anonymous"
    ,
      deviceType: "light"
      id: 1
      cmd:
        lightType: "rgb"
        r: 0
        g: 255
        b: 0
    ,
      deviceType: "light"
      id: 2
      cmd:
        lightType: "rgb"
        r: 0
        g: 0
        b: 255
    ]



  it "can parse three light packets from single udp-packet", ->

    lightPacket = new Buffer [
      1 # spec version

      , 1 # Type. 1 means light
      , 1 # light id
      , 0 # Light type. 0 means rgb
      , 0 # R
      , 255 # G
      , 0 #B

      , 1 # Type. 1 means light
      , 2 # light id
      , 0 # Light type. 0 means rgb
      , 0 # R
      , 0 # G
      , 255 #B

      , 1 # Type. 1 means light
      , 3 # light id
      , 0 # Light type. 0 means rgb
      , 255 # R
      , 0 # G
      , 255 #B
    ]

    should.deepEqual packetParse(lightPacket), [
      tag: "anonymous"
    ,
      deviceType: "light"
      id: 1
      cmd:
        lightType: "rgb"
        r: 0
        g: 255
        b: 0
    ,
      deviceType: "light"
      id: 2
      cmd:
        lightType: "rgb"
        r: 0
        g: 0
        b: 255
    ,
      deviceType: "light"
      id: 3
      cmd:
        lightType: "rgb"
        r: 255
        g: 0
        b: 255
    ]






  it "can have tag", ->

    lightPacket = new Buffer [
      1 # spec version

      , 0 # Tag. 0 is "device type tag"
      , 101 # e
      , 112 # p
      , 101 # e
      , 108 # l
      , 105 # i
      , 0 # end char

      , 1 # Type. 1 means light
      , 1 # light id
      , 0 # Light type. 0 means rgb
      , 0 # R
      , 255 # G
      , 0 #B

      , 1 # Type. 1 means light
      , 2 # light id
      , 0 # Light type. 0 means rgb
      , 0 # R
      , 0 # G
      , 255 #B
    ]

    should.deepEqual packetParse(lightPacket), [
      tag: "epeli"
    ,
      deviceType: "light"
      id: 1
      cmd:
        lightType: "rgb"
        r: 0
        g: 255
        b: 0
    ,
      deviceType: "light"
      id: 2
      cmd:
        lightType: "rgb"
        r: 0
        g: 0
        b: 255
    ]

