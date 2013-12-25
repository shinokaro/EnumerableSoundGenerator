=begin
==Ticksについて
　Ticksは整数です。0から始まり1ずつ増加します。
　Ticksは飛びのある増加はありません。つまり、2以上の増加はありえません。
　Ticksは内部でマイナス値をとることもありますが、その場合は値がマイナスの間、常に0を出力します。
　Ticksに依存する処理はこ、のことを前提としてかまいません。
=end
class Ticks < Enumerator  
  def initialize(ticks=0)
    super { |output| ticks += 1 while output << (0 < ticks ? ticks : 0) }
  end
  alias tick! next
  alias ticks peek
end
