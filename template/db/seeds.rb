project_root = File.dirname(File.absolute_path(__FILE__))
Dir.glob(project_root + '/../app/models/*.rb') {|file| require file}

class Seed
  def self.populate
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
