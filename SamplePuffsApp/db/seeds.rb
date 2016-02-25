class Seed
  def self.populate
    User.destroy_all!
    Post.destroy_all!
    Comment.destroy_all!

    zach = User.new(name: "Zach").save
    tina = User.new(name: "Tina").save
    breakfast = User.new(name: "Breakfast").save

    z1 = Post.new(body: "Pufffffffffffssss!!!", author_id: zach.id).save
    z2 = Post.new(body: "Puffs ain't crispy.", author_id: zach.id).save
    z3 = Post.new(body: "Cheesy Puffs!", author_id: zach.id).save

    t1 = Post.new(body: "I heart Puffs!", author_id: tina.id).save
    t2 = Post.new(body: "Puffs is tasty!", author_id: tina.id).save
    t3 = Post.new(body: "Puffs, wow!", author_id: tina.id).save

    b1 = Post.new(body: "I'm Breakfast!", author_id: breakfast.id).save
    b2 = Post.new(body: "I'm a cat!", author_id: breakfast.id).save
    b3 = Post.new(body: "Puffs?", author_id: breakfast.id).save

    Comment.new(body: "I'm a cat!", commenter_id: breakfast.id, post_id: t1.id).save
    Comment.new(body: "I'm a cat!", commenter_id: breakfast.id, post_id: t2.id).save
    Comment.new(body: "I'm a cat!", commenter_id: breakfast.id, post_id: t3.id).save

    Comment.new(body: "I'm hungry!", commenter_id: zach.id, post_id: b1.id).save
    Comment.new(body: "PUFFS IS AWESOME", commenter_id: zach.id, post_id: b2.id).save
    Comment.new(body: "Such puffs!", commenter_id: zach.id, post_id: b3.id).save

    Comment.new(body: "Amaze!", commenter_id: tina.id, post_id: z1.id).save
    Comment.new(body: "Love puffs!", commenter_id: tina.id, post_id: z2.id).save
    Comment.new(body: "Puffs is easy!", commenter_id: tina.id, post_id: z3.id).save

    #Create seeds in this method. Here's an example:

    # Cat.destroy_all!
    # Human.destroy_all!
    # House.destroy_all!
    #
    # h1 = House.new(address: '26th and Guerrero').save
    # h2 = House.new(address: 'Dolores and Market').save
    # h3 = House.new(address: '123 4th Street').save
    #
    # devon = Human.new(fname: 'Devon', lname: 'Watts', house_id: h1.id).save
    # matt = Human.new(fname: 'Matt', lname: 'Rubens', house_id: h1.id).save
    # ned = Human.new(fname: 'Ned', lname: 'Ruggeri', house_id: h2.id).save
    # catless = Human.new(fname: 'Catless', lname: 'Human', house_id: h3.id).save
    #
    # Cat.new(name: 'Breakfast', owner_id: devon.id).save
    # Cat.new(name:'Earl', owner_id: matt.id).save
    # Cat.new(name: 'Haskell', owner_id: ned.id).save
    # Cat.new(name: 'Markov', owner_id: ned.id).save
    # Cat.new(name: 'Stray Cat')
  end
end
