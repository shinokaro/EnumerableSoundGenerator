=begin
　VTE継承クラスの記述方法

　initialize中に列挙ブロックを定義しsuperで渡す。
　通常引数は信号入力
　キーワード引数はパラメーター
　パラメーター取得はアクセッサーを経由する
　アトリビュートはprocが入っている。procをcallして取得する
　よって、パラメーターに与えるオブジェクトはto_procをサポートしている必要がある。
  call時に値を与えるかは検討中。
  
  Enumuratorを親としているので列挙が無限に続いてよい。
  列挙に終わりがあってもよい、StopIteration例外が発生することで後処理ができる。
=end
module VTEHelper
  def attr_set(name, val)
    __send__([name, :'='].join, val)
  end
  def attr_sets(**name_and_val)
    name_and_val.each do |name, val|
      attr_set(name, val)
    end
  end
  def keyword_args
    p self.class.instance_method(:initialize).parameters.select{|(k, v)| k == :key}.map{|(k, v)| v}
    Hash[self.method(:initialize).parameters.select{|(k, v)| k == :key}.flatten!]
  end
  def period
    Rational(SAMPLE_RATE, ticks)
  end
  alias T period
end


class FmOperator < VTE
  
  include VTEHelper
  include Math
  
  attr_caller :input, :frequency, :multiple, :detune, :phase, :volume
  
  def initialize(input=0.0, frequency:440.0, multiple:1.0, detune:0.0, phase:0.0, volume:1.0, **inputs)
    attr_sets(keyword_args)
    self.input= input
    super { |output| output << proccess while true }
  end
  def proccess
    f = 2 * PI * multiple * (frequency + detune)
    p = phase / (2 * PI * frequency)
    volume * sin(f * (time + p) + input)
  end
end
class Sin < VTE
  include VTEHelper
  include Math
  
  attr_caller :frequency, :multiple, :detune, :phase
  
  def initialize(frequency:0.0, multiple:1.0, detune:0.0, phase:0.0, **kwargs)
    self.frequency= frequency
    self.multiple=  multiple
    self.detune=    detune
    self.phase=     phase
    super { |output| output << self.proccess while true }
  end
  def proccess
    f = 2 * PI * multiple * (frequency + detune)
    p = phase / (2 * PI * frequency)
    sin(f * (time + p))
  end
end

class Amp < VTE
  
  attr_caller :input, :volume
  
  def initialize(input, volume:1.0)
    self.input= input
    self.volume= volume
    super { |output| output << input * volume while true }
  end
end

class Mixer < VTE
  def initialize(*inputs)
    inn = inputs.map(&:to_proc)
    super { |output|
      output << inn.map { |ch|
        begin
          inn.call
        rescue
          inn.delete(ch)  
        end
      }.inject(&:+) while true
    }
  end
end

class Slope < VTE
  def initialize(limit_time: 1.0)
    super { |output| output << Rational(time, limit_time) while time <= limit_time }
  end
end
class ISlope < VTE
  def initialize(limit_time: 1.0)
    super { |output| output << Rational(limit_time - time, limit_time) while time <= limit_time }
  end
end
class Flat < VTE
  def initialize(limit_time: 1.0, level: 1.0)
    super { |output| output << level while time <= limit_time }
  end
end
class Combo < VTE
  def initialize(*vtes)
    super { |output|
      vtes.each do |vte|
        begin
          vte.each { |input| output << input }
        rescue StopIteration
          next
        end
      end
    }
  end
end

class EG < VTE
  def initialize(attack_time:1.0, decay_time:1.0, sustain_time:1.0, sustain_level:1.0, release_time:1.0)
    super { |output|
      attack  = Slope.new( limit_time: attack_time)
      decay   = ISlope.new(limit_time: decay_time)
      sustain = Flat.new(  limit_time: sustain_time, level: sustain_level)
      release = ISlope.new(limit_time: release_time)
      
      attack.each { |input| output << input }
      decay.each  { |input| output << input * (1.0 - sustain_level) + sustain_level}
      sustain.each{ |input| output << input }
      release.each{ |input| output << input * sustain_level }
    }
  end
end
class PCM < VTE
  
end
module Key
  def key_on
    @key = true if @key.nil?
  end
  def key_on?
    !!@key
  end
  def key_off
    @key = false if @key
  end
  def key_off?
    !@key
  end
  def key_oned?
    !@key.nil?
  end
end