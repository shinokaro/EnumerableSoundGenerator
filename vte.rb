require_relative "ticks"
=begin
  VTEは
  Virtual Time Enumerator または Vicarious Trial and Error
  の略称です。
  
  サウンドジェネレーターおよび、その集合体がそれぞれの時間軸で動作することを可能とします。
  共通のTicksを参照することで、計算時の同時性を実現します。
  実時間time,tを取得できます。tはtimeのエイリアスであり、数学式を記述するときのヘルパーです。
  
  サンプリングレートは固定ですが、将来的にはインスタンスごとに独立した値をもてるようにする予定です。
  
  { |output| nil while output << 0.0 }
=end
class VTE < Enumerator

  SAMPLE_RATE = 44_100
  
  attr_caller :ticks
  
  def initialize(*, ticks:Ticks.new, **inputs, &block)
    self.ticks= ticks
    super(&block)
  end
  def stop
    raise StopIteration
  end
  def time
    Rational(ticks, SAMPLE_RATE)
  end
  alias t time
end