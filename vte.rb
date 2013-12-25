require_relative "ticks"
=begin
  VTE��
  Virtual Time Enumerator �܂��� Vicarious Trial and Error
  �̗��̂ł��B
  
  �T�E���h�W�F�l���[�^�[����сA���̏W���̂����ꂼ��̎��Ԏ��œ��삷�邱�Ƃ��\�Ƃ��܂��B
  ���ʂ�Ticks���Q�Ƃ��邱�ƂŁA�v�Z���̓��������������܂��B
  ������time,t���擾�ł��܂��Bt��time�̃G�C���A�X�ł���A���w�����L�q����Ƃ��̃w���p�[�ł��B
  
  �T���v�����O���[�g�͌Œ�ł����A�����I�ɂ̓C���X�^���X���ƂɓƗ������l�����Ă�悤�ɂ���\��ł��B
  
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