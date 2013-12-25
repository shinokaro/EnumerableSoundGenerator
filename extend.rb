# extend
require "dxruby"

# ヘルパーメソッド　：　目的は、すぐに音が鳴らせるようにする事
class Array
  def to_sound
    ::DXRuby::SoundEffect.new(self)
  end
end
class Enumerator::Lazy
  def to_sound
    ::DXRuby::SoundEffect.new(self.to_a)
  end
end
# 入力値はProcであることを前提とする
# Procを呼び出せば、出力側のメソッドを呼び出す形で値が取れる
# 計算時に必要なのは数値であるが、
# Enumeratorから値をとるときはnextメソッドを呼び出さなくては鳴らない
# 入力引数をProcで統一すれば、ゲッター時に分岐を書かずにすむ。
# つまり、ダックタイピングのためのヘルパーメソッド
class Object
  def to_proc
    proc { |*| self }
  end
end
class Enumerator
  def to_proc
    proc { |*| self.next }
  end
end
# アトリビュートにある値をProcであることを前提とする
# attr_callerは、記述性向上のためのメソッド
class Module
  private
  def attr_caller(*attr_names)
    attr_names.each do |name|
      class_eval(%Q{
        def #{name}
          @#{name}.call
        end
        def #{name}=(obj)
          @#{name} = obj.to_proc
        end
      })
    end
  end
end
 