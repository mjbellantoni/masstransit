require "spec_helper"
require "classes/block"
require "classes/terminal"
require "classes/track"
require "classes/trolley"


describe "A single block where travel goes from (0,0) to (10,10) on a single length of track" do

  before(:each) do
    setup_chingu
    @track = Track.create(:a_x => 0, :a_y => 0, :b_x => 10, :b_y => 10)
    @block = Block.new(:track_t_a => @track.t_a, :track_t_b => @track.t_b)
  end

  context "when expected travel is from (0,0) to (10,10)" do

    before(:each) do
      @block.orientation = Block::A_TO_B
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

  context "when expected travel is from (10,10) to (0,0)" do

    before(:each) do
      @block.orientation = Block::B_TO_A
    end

    context "and the block is unoccupied" do
    
      it "displays a RED signal at terminal A" do
        @block.s_a.should == Block::Signal::RED
      end

      it "displays a GREEN signal at terminal B" do
        @block.s_b.should == Block::Signal::GREEN
      end

    end

    context "and the block is occupied" do

      before(:each) do
        @track.t_b.carry(Fabricate(:trolley))
      end

      it "displays a RED signal at terminal A" do
        @block.s_a.should == Block::Signal::RED
      end

      it "displays a RED signal at terminal B" do
        @block.s_b.should == Block::Signal::RED
      end

    end

  end
end



describe "A single block where travel goes from (0,0) to (10,10) on a two lengths of track" do

  before(:each) do
    setup_chingu
    @track1 = Track.create(:a_x => 0, :a_y => 0, :b_x => 5, :b_y => 5)
    @track2 = @track1.t_b.extend_to(10, 10)
    @block = Block.new(:track_t_a => @track1.t_a, :track_t_b => @track2.t_b)
  end

  context "when expected travel is from (0,0) to (10,10)" do

    before(:each) do
      @block.orientation = Block::A_TO_B
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
        @track1.t_a.carry(Fabricate(:trolley))
      end

      it "displays a RED signal at terminal A" do
        @block.s_a.should == Block::Signal::RED
      end

      it "displays a RED signal at terminal B" do
        @block.s_b.should == Block::Signal::RED
      end

    end

  end

  context "when expected travel is from (10,10) to (0,0)" do

    before(:each) do
      @block.orientation = Block::B_TO_A
    end

    context "and the block is unoccupied" do
    
      it "displays a RED signal at terminal A" do
        @block.s_a.should == Block::Signal::RED
      end

      it "displays a GREEN signal at terminal B" do
        @block.s_b.should == Block::Signal::GREEN
      end

    end

    context "and the block is occupied" do

      before(:each) do
        @track2.t_b.carry(Fabricate(:trolley))
      end

      it "displays a RED signal at terminal A" do
        @block.s_a.should == Block::Signal::RED
      end

      it "displays a RED signal at terminal B" do
        @block.s_b.should == Block::Signal::RED
      end

    end

  end

end




describe "Two blocks where travel goes from (0,0) to (5,5) to (10,10)" do

  before(:each) do
    setup_chingu

    @track1 = Track.create(:a_x => 0, :a_y => 0, :b_x => 5, :b_y => 5)
    @track2 = @track1.t_b.extend_to(10, 10)

    @block1 = Block.new(:track_t_a => @track1.t_a, :track_t_b => @track1.t_b)
    @block2 = Block.new(:track_t_a => @track2.t_a, :track_t_b => @track2.t_b)

    Terminal.link(@block1.t_b, @block2.t_a)
  end

  context "when expected travel is from (0,0) to (10,10)" do

    before(:each) do
      @block1.orientation = Block::A_TO_B
      @block2.orientation = Block::A_TO_B
    end

    context "and block 1 and block 2 are unoccupied" do
  
      it "displays a GREEN signal at block 1 terminal A" do
        @block1.s_a.should == Block::Signal::GREEN
      end

      it "displays a RED signal at block 1 terminal B" do
        @block1.s_b.should == Block::Signal::RED
      end
  
      it "displays a GREEN signal at block 2 terminal A" do
        @block2.s_a.should == Block::Signal::GREEN
      end

      it "displays a RED signal at block 2 terminal B" do
        @block2.s_b.should == Block::Signal::RED
      end

    end

    context "and block 1 is occupied and block 2 is unoccupied" do

      before(:each) do
        @track1.t_a.carry(Fabricate(:trolley))
      end

      it "displays a RED signal at block 1 terminal A" do
        @block1.s_a.should == Block::Signal::RED
      end

      it "displays a RED signal at block 1 terminal B" do
        @block1.s_b.should == Block::Signal::RED
      end

      it "displays a GREEN signal at block 2 terminal A" do
        @block2.s_a.should == Block::Signal::GREEN
      end

      it "displays a RED signal at block 2 terminal B" do
        @block2.s_b.should == Block::Signal::RED
      end

    end

    context "and block 1 is unoccupied and block 2 is occupied" do

      before(:each) do
        @track2.t_a.carry(Fabricate(:trolley))
      end

      it "displays a YELLOW signal at block 1 terminal A" do
        @block1.s_a.should == Block::Signal::YELLOW
      end

      it "displays a RED signal at block 1 terminal B" do
        @block1.s_b.should == Block::Signal::RED
      end

      it "displays a RED signal at block 2 terminal A" do
        @block2.s_a.should == Block::Signal::RED
      end

      it "displays a RED signal at block 2 terminal B" do
        @block2.s_b.should == Block::Signal::RED
      end

    end

    context "and block 1 is occupied and block 2 is occupied" do

      before(:each) do
        @track1.t_a.carry(Fabricate(:trolley))
        @track2.t_a.carry(Fabricate(:trolley))
      end

      it "displays a RED signal at block 1 terminal A" do
        @block1.s_a.should == Block::Signal::RED
      end

      it "displays a RED signal at block 1 terminal B" do
        @block1.s_b.should == Block::Signal::RED
      end

      it "displays a RED signal at block 2 terminal A" do
        @block2.s_a.should == Block::Signal::RED
      end

      it "displays a RED signal at block 2 terminal B" do
        @block2.s_b.should == Block::Signal::RED
      end

    end

  end

  context "when expected travel is from (10,10) to (0,0)" do

    before(:each) do
      @block1.orientation = Block::B_TO_A
      @block2.orientation = Block::B_TO_A
    end

    context "and block 1 and block 2 are unoccupied" do
  
      it "displays a RED signal at block 1 terminal A" do
        @block1.s_a.should == Block::Signal::RED
      end

      it "displays a GREEN signal at block 1 terminal B" do
        @block1.s_b.should == Block::Signal::GREEN
      end
  
      it "displays a RED signal at block 2 terminal A" do
        @block2.s_a.should == Block::Signal::RED
      end

      it "displays a GREEN signal at block 2 terminal B" do
        @block2.s_b.should == Block::Signal::GREEN
      end

    end

    context "and block 1 is occupied and block 2 is unoccupied" do

      before(:each) do
        @track1.t_a.carry(Fabricate(:trolley))
      end

      it "displays a RED signal at block 1 terminal A" do
        @block1.s_a.should == Block::Signal::RED
      end

      it "displays a RED signal at block 1 terminal B" do
        @block1.s_b.should == Block::Signal::RED
      end

      it "displays a RED signal at block 2 terminal A" do
        @block2.s_a.should == Block::Signal::RED
      end

      it "displays a YELLOW signal at block 2 terminal B" do
        @block2.s_b.should == Block::Signal::YELLOW
      end

    end

    context "and block 1 is unoccupied and block 2 is occupied" do

      before(:each) do
        @track2.t_a.carry(Fabricate(:trolley))
      end

      it "displays a RED signal at block 1 terminal A" do
        @block1.s_a.should == Block::Signal::RED
      end

      it "displays a GREEN signal at block 1 terminal B" do
        @block1.s_b.should == Block::Signal::GREEN
      end

      it "displays a RED signal at block 2 terminal A" do
        @block2.s_a.should == Block::Signal::RED
      end

      it "displays a RED signal at block 2 terminal B" do
        @block2.s_b.should == Block::Signal::RED
      end

    end

    context "and block 1 is occupied and block 2 is occupied" do

      before(:each) do
        @track1.t_a.carry(Fabricate(:trolley))
        @track2.t_a.carry(Fabricate(:trolley))
      end

      it "displays a RED signal at block 1 terminal A" do
        @block1.s_a.should == Block::Signal::RED
      end

      it "displays a RED signal at block 1 terminal B" do
        @block1.s_b.should == Block::Signal::RED
      end

      it "displays a RED signal at block 2 terminal A" do
        @block2.s_a.should == Block::Signal::RED
      end

      it "displays a RED signal at block 2 terminal B" do
        @block2.s_b.should == Block::Signal::RED
      end

    end

  end
end


describe "Three blocks where travel goes from (0,0) to (5,5) to (10,10) to (15, 15)" do

  before(:each) do
    setup_chingu

    @track1 = Track.create(:a_x => 0, :a_y => 0, :b_x => 5, :b_y => 5)
    @track2 = @track1.t_b.extend_to(10, 10)
    @track3 = @track1.t_b.extend_to(15, 15)

    @blocks = [@track1, @track2, @track3].map do |track|
      Block.new(:track_t_a => track.t_a, :track_t_b => track.t_b)
    end

    @block1, @block2, @block3 = @blocks

    Terminal.link(@block1.t_b, @block2.t_a)
    Terminal.link(@block2.t_b, @block3.t_a)
  end

  context "when expected travel is from (10,10) to (0,0)" do

    before(:each) do
      @blocks.each do |block|
        block.orientation = Block::B_TO_A
      end
    end

    context "and all blocks are unoccupied" do

      it "displays a RED signal at block 1 terminal A" do
        @block1.s_a.should == Block::Signal::RED
      end

      it "displays a GREEN signal at block 1 terminal B" do
        @block1.s_b.should == Block::Signal::GREEN
      end

      it "displays a RED signal at block 2 terminal A" do
        @block2.s_a.should == Block::Signal::RED
      end

      it "displays a GREEN signal at block 2 terminal B" do
        @block2.s_b.should == Block::Signal::GREEN
      end

      it "displays a RED signal at block 3 terminal A" do
        @block3.s_a.should == Block::Signal::RED
      end

      it "displays a GREEN signal at block 3 terminal B" do
        @block3.s_b.should == Block::Signal::GREEN
      end

    end

    context "and blocks 2 and 3 are unoccupied and block 1 is occupied" do

      before(:each) do
        @track1.t_b.carry(Fabricate(:trolley))
      end

      it "displays a RED signal at block 1 terminal A" do
        @block1.s_a.should == Block::Signal::RED
      end

      it "displays a RED signal at block 1 terminal B" do
        @block1.s_b.should == Block::Signal::RED
      end

      it "displays a RED signal at block 2 terminal A" do
        @block2.s_a.should == Block::Signal::RED
      end

      it "displays a YELLOW signal at block 2 terminal B" do
        @block2.s_b.should == Block::Signal::YELLOW
      end

      it "displays a RED signal at block 3 terminal A" do
        @block3.s_a.should == Block::Signal::RED
      end

      it "displays a GREEN signal at block 3 terminal B" do
        @block3.s_b.should == Block::Signal::GREEN
      end

    end

  end

end