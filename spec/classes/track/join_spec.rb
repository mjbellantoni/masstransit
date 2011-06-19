require "spec_helper"
require "classes/track"
require "classes/trolley"


describe Track do

  context "from a = (0, 0) to b = (0, 5) to c = (0, 10)" do

    before(:each) do
      setup_chingu
      @track1 = Track.new(:a_x => 0, :a_y => 0, :b_x => 0, :b_y => 5)
      @track2 = @track1.t_b.extend_to(0, 10)
      @trolley = Fabricate(:trolley)
    end

    context "when a trolley is added to terminal a of the first track" do

      before(:each) do
        @track1.t_a.carry(@trolley)
      end

      it "tells the trolley it is at (0, 0)" do
        @trolley.x.should be_within(0.001).of(0)
        @trolley.y.should be_within(0.001).of(0)
      end

      context "when it moves forward" do

        before(:each) do
          @trolley.forward
        end

        context "after one step (one second)" do
          before(:each) do
            @trolley.update
          end

          it "tells the trolley it is at (0, 4.470)" do
            @trolley.x.should be_within(0.001).of(0)
            @trolley.y.should be_within(0.001).of(4.470)
          end
        end

        context "after two steps (two seconds)" do
          before(:each) do
            2.times { @trolley.update }
          end

          it "tells the trolley it is at (0, 8.940)" do
            @trolley.x.should be_within(0.001).of(0)
            @trolley.y.should be_within(0.001).of(8.940)
          end
        end

        context "after three steps (three seconds)" do
          before(:each) do
            2.times { @trolley.update }
          end

          it "the trolley is off the end of the track!" do
            lambda { @trolley.update }.should raise_error(OffTheRailsException, "The trolley ran off the end of the track!")
          end
        end

      end

    end

    context "when a trolley is added to terminal b of the second track" do

      before(:each) do
        @track2.t_b.carry(@trolley)
      end

      it "tells the trolley it is at (0, 10)" do
        @trolley.x.should be_within(0.001).of(0)
        @trolley.y.should be_within(0.001).of(10)
      end

      context "when it moves forward" do

        before(:each) do
          @trolley.forward
        end

        context "after one step (one second)" do
          before(:each) do
            @trolley.update
          end

          it "tells the trolley it is at (0, 5.530)" do
            @trolley.x.should be_within(0.001).of(0)
            @trolley.y.should be_within(0.001).of(5.530)
          end
        end

        context "after two steps (two seconds)" do
          before(:each) do
            2.times { @trolley.update }
          end

          it "tells the trolley it is at (0, 1.06)" do
            @trolley.x.should be_within(0.001).of(0)
            @trolley.y.should be_within(0.001).of(1.06)
          end
        end

        context "after three steps (three seconds)" do
          before(:each) do
            2.times { @trolley.update }
          end

          it "the trolley is off the end of the track!" do
            lambda { @trolley.update }.should raise_error(OffTheRailsException, "The trolley ran off the end of the track!")
          end
        end

      end

    end

  end  

end



describe Track do

  context "from a = (0, 0) to b = (0, 4.470) to c = (0, 8.940)" do

    before(:each) do
      setup_chingu
      @track1 = Track.new(:a_x => 0, :a_y => 0, :b_x => 0, :b_y => 4.470)
      @track2 = @track1.t_b.extend_to(0, 8.940)
      @trolley = Fabricate(:trolley)
    end

    context "when a trolley is added to terminal a of the first track" do

      before(:each) do
        @track1.t_a.carry(@trolley)
      end

      it "tells the trolley it is at (0, 0)" do
        @trolley.x.should be_within(0.001).of(0)
        @trolley.y.should be_within(0.001).of(0)
      end

      context "when it moves forward" do

        before(:each) do
          @trolley.forward
        end

        context "after one step (one second)" do
          before(:each) do
            @trolley.update
          end

          it "tells the trolley it is at (0, 4.470)" do
            @trolley.x.should be_within(0.001).of(0)
            @trolley.y.should be_within(0.001).of(4.470)
          end
        end

        context "after two steps (two seconds)" do
          before(:each) do
            2.times { @trolley.update }
          end

          it "tells the trolley it is at (0, 8.940)" do
            @trolley.x.should be_within(0.001).of(0)
            @trolley.y.should be_within(0.001).of(8.940)
          end
        end

        context "after three steps (three seconds)" do
          before(:each) do
            2.times { @trolley.update }
          end

          it "the trolley is off the end of the track!" do
            lambda { @trolley.update }.should raise_error(OffTheRailsException, "The trolley ran off the end of the track!")
          end
        end

      end

    end

    context "when a trolley is added to terminal b of the second track" do

      before(:each) do
        @track2.t_b.carry(@trolley)
      end

      it "tells the trolley it is at (0, 8.940)" do
        @trolley.x.should be_within(0.001).of(0)
        @trolley.y.should be_within(0.001).of(8.940)
      end

      context "when it moves forward" do

        before(:each) do
          @trolley.forward
        end

        context "after one step (one second)" do
          before(:each) do
            @trolley.update
          end

          it "tells the trolley it is at (0, 4.470)" do
            @trolley.x.should be_within(0.001).of(0)
            @trolley.y.should be_within(0.001).of(4.470)
          end
        end

        context "after two steps (two seconds)" do
          before(:each) do
            2.times { @trolley.update }
          end

          it "tells the trolley it is at (0, 0)" do
            @trolley.x.should be_within(0.001).of(0)
            @trolley.y.should be_within(0.001).of(0)
          end
        end

        context "after three steps (three seconds)" do
          before(:each) do
            2.times { @trolley.update }
          end

          it "the trolley is off the end of the track!" do
            lambda { @trolley.update }.should raise_error(OffTheRailsException, "The trolley ran off the end of the track!")
          end
        end

      end

    end

  end  

end

