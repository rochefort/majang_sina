require File.expand_path(File.dirname(__FILE__) + '/../../lib/majang.rb')

describe Majang do
  before do
    @m = Majang.new
  end

  describe "待ち無し1112224788899" do
    before { @m.mati("1112224788899") }
    subject { @m.tenpai}
    it { should have(:no).item }
  end
  describe "1112224588899" do
    before { @m.mati("1112224588899") }
    subject { @m.tenpai}
    it { should have(1).item }
    it { should == ["(111)(222)(888)(99)[45]"] }
  end
  describe "1112223335559" do
    before { @m.mati("1112223335559") }
    subject { @m.tenpai}
    it { should have(2).items }
    it { should include("(111)(222)(333)(555)[9]") }
    it { should include("(123)(123)(123)(555)[9]") }
  end
  describe "1223344888999" do
    before { @m.mati("1223344888999") }
    subject { @m.tenpai}
    it { should have(3).items }
    it { should include("(123)(234)(888)(999)[4]") }
    it { should include("(123)(44)(888)(999)[23]") }
    it { should include("(234)(234)(888)(999)[1]") }
  end
  describe "1112345678999" do
    before { @m.mati("1112345678999") }
    subject { @m.tenpai}
    it { should have(11).items }
    it { should include("(111)(234)(567)(99)[89]") }
    it { should include("(111)(234)(678)(999)[5]") }
    it { should include("(111)(234)(789)(99)[56]") }
    it { should include("(111)(234)(567)(999)[8]") }
    it { should include("(111)(345)(678)(999)[2]") }
    it { should include("(111)(456)(789)(99)[23]") }
    it { should include("(11)(123)(456)(789)[99]") }
    it { should include("(123)(456)(789)(99)[11]") }
    it { should include("(123)(456)(789)(99)[11]") }
    it { should include("(11)(123)(678)(999)[45]") }
    it { should include("(11)(345)(678)(999)[12]") }
  end


  # private methods
  describe ":format_tenpai" do
    context '["123", "456"],["78"]' do
      it { @m.send(:format_tenapi, ["123","456"], ["78"]).should == "(123)(456)[78]" }
    end
  end

  describe ":all_same?" do
    context "要素が0個の場合" do
      it { be_all_same?([]) }
    end
    context "素が１個の場合" do
      it { be_all_same?(["1"]) }
    end
    context "全ての要素が同じ場合" do
      it { be_all_same?(["1", "1", "1"]) }
    end
    context "異なる要素が存在する場合" do
      it { not be_all_same?(["1", "2", "1"]) }
    end
  end

  describe ":tenpai?" do
    before do
      #tenpai?の中で呼んでいるappend_tenpaiで<<がエラーとなるため、stubを作成
      @m.stub!(:append_tenpai)
    end
    #単騎待ちは考慮しない
    context '両面待ちの場合["1", "1", "2", "3"]' do
      it { be_tenpai?(["1", "1", "2", "3"]) }
    end
    context 'カンチャン待ちの場合["1", "1", "4", "6"]' do
      it { be_tenpai?(["1", "1", "4", "6"]) }
    end
    context 'ペンチャン待ちの場合["1", "1", "8", "9"]' do
      it { be_tenpai?(["1", "1", "8", "9"]) }
    end
    context 'シャンポン待ちの場合["1", "1", "2", "2"]' do
      it { be_tenpai?(["1", "1", "2", "2"]) }
    end
    context '待ちなし場合["1", "1", "2", "5"]' do
      it { not be_tenpai?(["1", "1", "2", "5"]) }
    end
  end

  describe ":mati?" do
    context '要素が差が0の場合["1", "1"]' do
      it { be_mati?(["1", "1"]) }
    end
    context '要素が差が1の場合["1", "2"]' do
      it { be_mati?(["1", "2"]) }
    end
    context '要素が差が2の場合["1", "3"]' do
      it { be_mati?(["1", "3"]) }
    end
    context '要素が差が3の場合["1", "4"]' do
      it { not be_mati?(["1", "4"]) }
    end
  end

  describe ":candidates" do
    context '順子が存在しない場合["1","1","2"]' do
      it { do_candidates(["1","1","2"]).should == [] }
    end
    context '刻子が存在する場合["1","1","1","2"]' do
      it { do_candidates(["1","1","1","2"]).should == ["111"] }
    end
    context '刻子と順子が存在する場合["1","1","1","2","2","2","3","3","3"]' do
      it { do_candidates(["1","1","1","2","2","2","3","3","3"]).should == ["111","222","333","123"].sort }
    end
  end

  private
  def all_same?(arg)
    @m.send(:all_same?, arg)
  end
  def tenpai?(arg)
    @m.send(:tenpai?, arg, [])
  end
  def mati?(arg)
    @m.send(:mati?, arg)
  end
  def do_candidates(arg)
    @m.send(:candidates, arg)
  end
end

describe Array do
  context "重複要素を引いた場合" do
    it "1つのみ削除されること" do
      ["1", "1", "2"].minus(["1"]).should == ["1","2"]
    end
  end
  context "複数要素を引いた場合" do
    it "正しく引き算されること" do
      ["1", "1", "2","3"].minus(["1","2"]).should == ["1","3"]
    end
  end
  context "引き算対象のデータが無い場合" do
    it "selfが返却されること" do
      ["1", "2", "3"].minus(["4"]).should == ["1","2","3"]
    end
  end
end
