require "spec_helper"
require "classes/block"
require "classes/track"
require "classes/trolley"


describe Block, "when travel goes from A to B" do

  before(:each) do
    setup_chingu
    @track = Track.create(:a_x => 0, :a_y => 0, :b_x => 10, :b_y => 10)
    @block = Block.new(:orientation => Block::A_TO_B, :track_t_a => @track.t_a, :track_t_b => @track.t_b)
  end

  context "and the block is unoccupied" do
    
    it "displays a GREEN signal at terminal A" do
      @block.s_a.should == Block::Signal::GREEN
    end

    it "displays a RED signal at terminal B" do
      @block.s_b.should == Block::Signal::RED
    end

  end

  context "and the block is occupied" do

    before(:each) do
      @track.t_a.carry(Fabricate(:trolley))
    end

    it "displays a RED signal at terminal A" do
      @block.s_a.should == Block::Signal::RED
    end

    it "displays a RED signal at terminal B" do
      @block.s_b.should == Block::Signal::RED
    end

  end

end


# describe Block, "when travel goes from B to A" do
# 
#   it "displays a RED signal at terminal A" do
#     @block.t_a.signal.should == RED
#   end
# 
# end



# Blocks need to be aware of their direction.
#   Do their directions need to change?