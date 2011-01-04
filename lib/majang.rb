class Majang
  def initialize
    @tenpai = []
  end
  attr_reader :tenpai

  def mati(haipai)
    @tenpai = []
    mati_check(haipai.split(//).sort)
    @tenpai.uniq!
    #@tenpai.each{|x| puts x}
  end

  private
  def append_tenpai(mentu, mati)
    @tenpai << format_tenapi(mentu, mati)
  end

  def format_tenapi(mentu, mati)
    mentu.sort.map{|x| "(#{x})"}.to_s + "[#{mati.to_s}]"
  end

  def mati_check(hais, kakutei_mentu = [])
    #最後の１枚は上がり
    if hais.size == 1
      append_tenpai(kakutei_mentu, hais) and return
    end

    #最後の4枚
    if hais.size == 4
      #全部同じ場合は、役無し
      return if all_same?(hais)
      #テンパイ確定後、終了
      return if tenpai?(hais, kakutei_mentu)
    end

    #面子候補を取得
    candidates(hais).each do |cand|
      next_hais = hais.minus(cand.split(//))
      next_kakutei_mentu = kakutei_mentu + cand.to_a
      mati_check(next_hais, next_kakutei_mentu)
    end
  end

  def all_same?(ar)
    return false if ar.size == 0
    ((ar - ar[0].to_a).size == 0)? true : false
  end

  def tenpai?(hais, kakutei_mentu)
    val = false
    hais.each_with_index do |hai, i|
      hai2  = hais[i, 2]   # 2枚ずつ取り出す
      return val unless hai2.size == 2
      atama = hai2
      mati  = hais.minus(atama)
      if atama?(atama) and mati?(mati)
        append_tenpai(kakutei_mentu + [atama.to_s], mati)
        val = true
      end
    end
    val
  end

  def atama?(hais)
    all_same?(hais)
  end

  def mati?(hais)
    (hais[1].to_i - hais[0].to_i) <= 2 ? true : false
  end

  def candidates(hais)
    work = []
    hais.each_with_index do |hai, i|
      #刻子
      work << (hai + hais[i+1] + hais[i+2]) if hai == hais[i+1] and hai == hais[i+2]
      #順子
      work << (hai + hai.succ + hai.succ.succ) if hais.include?(hai.succ) and hais.include?(hai.succ.succ)
    end
    work.uniq
  end
end

class Array
  def minus(ar)
    work = self.dup
    ar.each do |val|
      work[work.index(val)] = nil if self.include?(val)
    end
    work.compact
  end
end