# extend
require "dxruby"

# �w���p�[���\�b�h�@�F�@�ړI�́A�����ɉ����点��悤�ɂ��鎖
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
# ���͒l��Proc�ł��邱�Ƃ�O��Ƃ���
# Proc���Ăяo���΁A�o�͑��̃��\�b�h���Ăяo���`�Œl������
# �v�Z���ɕK�v�Ȃ̂͐��l�ł��邪�A
# Enumerator����l���Ƃ�Ƃ���next���\�b�h���Ăяo���Ȃ��Ă͖�Ȃ�
# ���͈�����Proc�œ��ꂷ��΁A�Q�b�^�[���ɕ�����������ɂ��ށB
# �܂�A�_�b�N�^�C�s���O�̂��߂̃w���p�[���\�b�h
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
# �A�g���r���[�g�ɂ���l��Proc�ł��邱�Ƃ�O��Ƃ���
# attr_caller�́A�L�q������̂��߂̃��\�b�h
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
 