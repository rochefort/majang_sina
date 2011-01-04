require 'app'
require 'spec/spec_helper'

describe 'App' do
  context 'GET /' do
    before { get '/' }
    it { last_response.ok?.should be_true }
  end

  describe 'POST /' do
    context "アルファベットをを含んだ値を入力された場合" do
      before { post '/', params = {:tehai => "111222458889a"} }
      subject { last_response }
      its(:ok?) { should be_true }
      its(:body) { should match(%r|<textarea id='mati_area'>数字以外が入力されています</textarea>|) }
    end

    context "13文字より少ない値が入力された場合" do
      before { post '/', params = {:tehai => "111222458889"} }
      subject { last_response }
      its(:ok?) { should be_true }
      its(:body) { should match(%r|<textarea id='mati_area'>少牌</textarea>|) }
    end

    context "13文字より多い値が入力された場合" do
      before { post '/', params = {:tehai => "11122245888999"} }
      subject { last_response }
      its(:ok?) { should be_true }
      its(:body) { should match(%r|<textarea id='mati_area'>多牌</textarea>|) }
    end

    context "ノーテンの場合" do
      before { post '/', params = {:tehai => "1112224788899"} }
      subject { last_response }
      its(:ok?) { should be_true }
      its(:body) { should match(%r|<textarea id='mati_area'>ノーテン</textarea>|) }
    end

    #spec/lib/majang_spec.rbでやっているので省略してもいいかも
    context "1112224588899" do
      before { post '/', params = {:tehai => "1112224588899"} }
      subject { last_response }
      its(:ok?) { should be_true }
      its(:body) { should match(%r|<textarea id='mati_area'>\(111\)\(222\)\(888\)\(99\)\[45\]</textarea>|) }
    end

    context "1112223335559" do
      before { post '/', params = {:tehai => "1112223335559"} }
      subject { last_response }
      its(:ok?) { should be_true }
      its(:body) { should match(%r|\(111\)\(222\)\(333\)\(555\)\[9\]|) }
      its(:body) { should match(%r|\(123\)\(123\)\(123\)\(555\)\[9\]|) }
    end
  end
end
